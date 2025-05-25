import 'package:NegXus/Config/CustomMessage.dart';
import 'package:NegXus/Controller/ProfileController.dart';
import 'package:NegXus/Model/ChatModel.dart';
import 'package:NegXus/Model/GroupModel.dart';
import 'package:NegXus/Model/UserModel.dart';
import 'package:NegXus/Pages/HomePage/HomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class GroupController extends GetxController {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  final uuid = Uuid();

  static const String groupCollection = "groups";
  static const String messageCollection = "messages";

  RxList<UserModel> groupMembers = <UserModel>[].obs;
  RxBool isLoading = false.obs;
  RxString selectedImagePath = "".obs;
  RxString selectedAudioPath = "".obs;
  RxList<GroupModel> groupList = <GroupModel>[].obs;
  ProfileController profileController = Get.put(ProfileController());
  RxMap<String, String> userIdToProfileImage = <String, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    getGroups();
  }

  void selectMember(UserModel user) {
    if (groupMembers.contains(user)) {
      groupMembers.remove(user);
    } else {
      groupMembers.add(user);
    }
  }

  Future<void> createGroup(String groupName, String imagePath) async {
    isLoading.value = true;
    try {
      final String groupId = uuid.v6();

      groupMembers.removeWhere((u) => u.id == auth.currentUser!.uid);
      groupMembers.add(
        UserModel(
          id: auth.currentUser!.uid,
          name: profileController.currentUser.value.name,
          profileImage: profileController.currentUser.value.profileImage,
          email: profileController.currentUser.value.email,
          role: "admin",
        ),
      );

      String imageUrl = "";
      if (imagePath.isNotEmpty) {
        imageUrl = await profileController.uploadImageToCloudinary(imagePath);
      }

      await db.collection(groupCollection).doc(groupId).set({
        "id": groupId,
        "name": groupName,
        "profileUrl": imageUrl,
        "members": groupMembers.map((e) => e.toJson()).toList(),
        "membersIds": groupMembers.map((e) => e.id).toList(),
        "createdAt": FieldValue.serverTimestamp(),
        "createdBy": auth.currentUser!.uid,
        "timeStamp": FieldValue.serverTimestamp(),
      });

      groupMembers.clear();
      selectedImagePath.value = "";
      await getGroups();
      successMessage("Group Created");
      Get.offAll(HomePage());
    } catch (e) {
      errorMessage("Failed to create group");
      print("CreateGroup Error: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  void buildUserIdToProfileImageMap(List<UserModel> members) {
    userIdToProfileImage.clear();
    for (var user in members) {
      if (user.id != null) {
        userIdToProfileImage[user.id!] = user.profileImage ?? "";
      }
    }
  }

  Future<void> refreshAllGroupUserImages() async {
    for (var group in groupList) {
      buildUserIdToProfileImageMap(group.members ?? []);
    }
  }

  Future<void> getGroups() async {
    isLoading.value = true;
    try {
      final snapshot = await db.collection(groupCollection).where("membersIds", arrayContains: auth.currentUser!.uid).get();

      final tempGroup = snapshot.docs.map((e) => GroupModel.fromJson(e.data())).toList();
      groupList.value = tempGroup;

      if (groupList.isNotEmpty) {
        buildUserIdToProfileImageMap(groupList.first.members!);
      }
    } catch (e) {
      errorMessage("Failed to load groups");
      print("GetGroups Error: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Stream<List<GroupModel>> getGroupss() {
    return db
        .collection(groupCollection)
        .where("membersIds", arrayContains: auth.currentUser!.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => GroupModel.fromJson(doc.data())).toList());
  }

  Future<void> sendGroupMessage(String message, String groupId, {String? videoPath}) async {
    isLoading.value = true;
    try {
      final String trimmedMessage = message.trim();
      String imageUrl = "";
      String audioUrl = "";
      String videoUrl = "";

      // Upload image if selected
      if (selectedImagePath.value.isNotEmpty) {
        imageUrl = await profileController.uploadImageToCloudinary(
          selectedImagePath.value,
        );
      }

      // Upload audio if selected
      if (selectedAudioPath.value.isNotEmpty) {
        audioUrl = await profileController.uploadAudioToCloudinary(
          selectedAudioPath.value,
        );
      }

      // Upload video if passed

      // Prevent empty messages
      if (trimmedMessage.isEmpty && imageUrl.isEmpty && audioUrl.isEmpty && videoUrl.isEmpty) {
        errorMessage("Cannot send empty message");
        return;
      }

      final chatId = uuid.v6();

      final newChat = ChatModel(
        id: chatId,
        message: trimmedMessage,
        imageUrl: imageUrl,
        audioUrl: audioUrl,
        videoUrl: videoUrl,
        senderId: auth.currentUser!.uid,
        senderName: profileController.currentUser.value.name,
        receiverId: groupId,
        timestamp: DateTime.now().toString(),
      );

      await db.collection(groupCollection).doc(groupId).collection(messageCollection).doc(chatId).set({
        ...newChat.toJson(),
        "timestamp": FieldValue.serverTimestamp(),
      });

      selectedImagePath.value = "";
      selectedAudioPath.value = "";
    } catch (e) {
      errorMessage("Failed to send message");
      print("SendGroupMessage Error: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Stream<List<ChatModel>> getGroupMessages(String groupId) {
    return db
        .collection(groupCollection)
        .doc(groupId)
        .collection(messageCollection)
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => ChatModel.fromJson(doc.data())).toList());
  }

  Future<void> addMemberToGroup(String groupId, UserModel user) async {
    isLoading.value = true;
    try {
      final doc = await db.collection(groupCollection).doc(groupId).get();
      final existingMembers = List<Map<String, dynamic>>.from(doc['members']);
      final existingMemberIds = List<String>.from(doc['membersIds']);

      if (existingMemberIds.contains(user.id)) {
        errorMessage("User already in group");
        return;
      }

      await db.collection(groupCollection).doc(groupId).update({
        "members": FieldValue.arrayUnion([user.toJson()]),
        "membersIds": FieldValue.arrayUnion([user.id]),
      });

      await getGroups();
    } catch (e) {
      errorMessage("Failed to add member");
      print("AddMember Error: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }
}
