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
  RxList<GroupModel> groupList = <GroupModel>[].obs;
  ProfileController profileController = Get.put(ProfileController());

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

      // Ensure the current user is not added twice
      if (!groupMembers.any((u) => u.id == auth.currentUser!.uid)) {
        groupMembers.add(
          UserModel(
            id: auth.currentUser!.uid,
            name: profileController.currentUser.value.name,
            profileImage: profileController.currentUser.value.profileImage,
            email: profileController.currentUser.value.email,
            role: "admin",
          ),
        );
      }

      String imageUrl = await profileController.uploadImageToCloudinary(imagePath);

      await db.collection(groupCollection).doc(groupId).set({
        "id": groupId,
        "name": groupName,
        "profileUrl": imageUrl,
        "members": groupMembers.map((e) => e.toJson()).toList(),
        "createdAt": DateTime.now().toString(),
        "createdBy": auth.currentUser!.uid,
        "timeStamp": DateTime.now().toString(),
      });

      await getGroups();
      successMessage("Group Created");
      Get.offAll(HomePage());
    } catch (e) {
      errorMessage("Failed to create group");
      print("CreateGroup Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getGroups() async {
    isLoading.value = true;
    try {
      final snapshot = await db.collection(groupCollection).get();
      final tempGroup = snapshot.docs.map((e) => GroupModel.fromJson(e.data())).toList();

      groupList.value = tempGroup
          .where(
            (e) => e.members!.any((element) => element.id == auth.currentUser!.uid),
          )
          .toList();
    } catch (e) {
      errorMessage("Failed to load groups");
      print("GetGroups Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Stream<List<GroupModel>> getGroupss() {
    return db.collection(groupCollection).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => GroupModel.fromJson(doc.data()))
          .where((group) => group.members!.any((member) => member.id == auth.currentUser!.uid))
          .toList();
    });
  }

  Future<void> sendGroupMessage(String message, String groupId, String imagePath) async {
    isLoading.value = true;
    try {
      final String trimmedMessage = message.trim();
      String imageUrl = "";

      if (selectedImagePath.value.isNotEmpty) {
        imageUrl = await profileController.uploadImageToCloudinary(selectedImagePath.value);
      }

      if (trimmedMessage.isEmpty && imageUrl.isEmpty) {
        errorMessage("Cannot send empty message");
        return;
      }

      final chatId = uuid.v6();

      final newChat = ChatModel(
        id: chatId,
        message: trimmedMessage,
        imageUrl: imageUrl,
        senderId: auth.currentUser!.uid,
        senderName: profileController.currentUser.value.name,
        receiverId: groupId,
        timestamp: DateTime.now().toString(),
      );

      await db.collection(groupCollection).doc(groupId).collection(messageCollection).doc(chatId).set(newChat.toJson());

      selectedImagePath.value = "";
    } catch (e) {
      errorMessage("Failed to send message");
      print("SendGroupMessage Error: $e");
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
      await db.collection(groupCollection).doc(groupId).update({
        "members": FieldValue.arrayUnion([user.toJson()]),
      });
      await getGroups();
    } catch (e) {
      errorMessage("Failed to add member");
      print("AddMember Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
