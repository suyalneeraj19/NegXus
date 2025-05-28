import 'dart:convert';
import 'dart:io';

import 'package:NegXus/Controller/ContactController.dart';
import 'package:NegXus/Controller/ProfileController.dart';
import 'package:NegXus/Model/CallModel.dart';
import 'package:NegXus/Model/ChatModel.dart';
import 'package:NegXus/Model/ChatRoomModel.dart';
import 'package:NegXus/Model/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../Config/CustomMessage.dart';

class ChatController extends GetxController {
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  RxBool isLoading = false.obs;
  RxBool isRecording = false.obs;
  var uuid = Uuid();
  RxString selectedImagePath = "".obs;
  RxString selectedAudioPath = "".obs;

  @override
  ProfileController profileController = Get.put(ProfileController());
  ContactController contactController = Get.put(ContactController());

  String getRoomId(String targetUserId) {
    String currentUserId = auth.currentUser!.uid;
    return currentUserId.compareTo(targetUserId) > 0 ? currentUserId + targetUserId : targetUserId + currentUserId;
  }

  UserModel getSender(UserModel currentUser, UserModel targetUser) {
    return currentUser.id!.compareTo(targetUser.id!) > 0 ? currentUser : targetUser;
  }

  UserModel getReciver(UserModel currentUser, UserModel targetUser) {
    return currentUser.id!.compareTo(targetUser.id!) > 0 ? targetUser : currentUser;
  }

  Future<void> sendMessage(
    String targetUserId,
    String message,
    UserModel targetUser, {
    String? audioPath,
    String? videoPath,
  }) async {
    isLoading.value = true;

    try {
      final String trimmedMessage = message.trim();
      String imageUrl = "";
      String audioUrl = "";
      String uploadedVideoUrl = "";

      String chatId = uuid.v6();
      String roomId = getRoomId(targetUserId);
      DateTime timestamp = DateTime.now();
      String nowTime = DateFormat('hh:mm a').format(timestamp);

      UserModel sender = getSender(profileController.currentUser.value, targetUser);
      UserModel receiver = getReciver(profileController.currentUser.value, targetUser);

      // Upload image if selected
      if (selectedImagePath.value.isNotEmpty) {
        imageUrl = await profileController.uploadImageToCloudinary(selectedImagePath.value);
      }

      // Upload audio if provided (from param or selectedAudioPath)
      String? audioToUpload = audioPath ?? selectedAudioPath.value;
      if (audioToUpload != null && audioToUpload.isNotEmpty && File(audioToUpload).existsSync()) {
        audioUrl = await profileController.uploadAudioToCloudinary(audioToUpload);
      }

      // Upload video if selected
      if (videoPath != null && videoPath.isNotEmpty) {
        uploadedVideoUrl = await profileController.uploadVideoToCloudinary(videoPath);
      }

      // Prevent empty messages
      if (trimmedMessage.isEmpty && imageUrl.isEmpty && audioUrl.isEmpty && uploadedVideoUrl.isEmpty) {
        errorMessage("Cannot send empty message");
        isLoading.value = false;
        return;
      }

      var newChat = ChatModel(
        id: chatId,
        message: trimmedMessage,
        imageUrl: imageUrl,
        videoUrl: uploadedVideoUrl,
        audioUrl: audioUrl,
        senderId: auth.currentUser!.uid,
        receiverId: targetUserId,
        senderName: profileController.currentUser.value.name,
        timestamp: timestamp.toString(),
        readStatus: "unread",
      );

      var lastMessageText = trimmedMessage.isNotEmpty
          ? trimmedMessage
          : imageUrl.isNotEmpty
              ? "[Image]"
              : uploadedVideoUrl.isNotEmpty
                  ? "[Video]"
                  : audioUrl.isNotEmpty
                      ? "[Audio]"
                      : "";

      var roomDetails = ChatRoomModel(
        id: roomId,
        lastMessage: lastMessageText,
        lastMessageTimestamp: nowTime,
        sender: sender,
        receiver: receiver,
        timestamp: timestamp.toString(),
        unReadMessNo: 0,
      );

      await db.collection("chats").doc(roomId).collection("messages").doc(chatId).set(newChat.toJson());
      selectedImagePath.value = "";
      selectedAudioPath.value = "";
      await db.collection("chats").doc(roomId).set(roomDetails.toJson());
      await contactController.saveContact(targetUser);
    } catch (e) {
      print("Error sending message: $e");
      errorMessage("Failed to send message");
    } finally {
      isLoading.value = false;
    }
  }

  Stream<List<ChatModel>> getMessages(String targetUserId) {
    String roomId = getRoomId(targetUserId);
    return db
        .collection("chats")
        .doc(roomId)
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => ChatModel.fromJson(doc.data())).toList());
  }

  Stream<UserModel> getStatus(String uid) {
    return db.collection('users').doc(uid).snapshots().map((event) => UserModel.fromJson(event.data()!));
  }

  Stream<List<CallModel>> getCalls() {
    return db
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("calls")
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => CallModel.fromJson(doc.data())).toList());
  }

  Stream<int> getUnreadMessageCount(String roomId) {
    return db
        .collection("chats")
        .doc(roomId)
        .collection("messages")
        .where("readStatus", isEqualTo: "unread")
        .where("senderId", isNotEqualTo: profileController.currentUser.value.id)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Future<void> markMessagesAsRead(String roomId) async {
    QuerySnapshot<Map<String, dynamic>> messagesSnapshot =
        await db.collection("chats").doc(roomId).collection("messages").where("readStatus", isEqualTo: "unread").get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> messageDoc in messagesSnapshot.docs) {
      String senderId = messageDoc.data()["senderId"];
      if (senderId != profileController.currentUser.value.id) {
        await db.collection("chats").doc(roomId).collection("messages").doc(messageDoc.id).update({"readStatus": "read"});
      }
    }
  }
}
