import 'package:NegXus/Model/CallModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Model/UserModel.dart';
import '../Pages/CallPage/AudioCallPage.dart';
import '../Pages/CallPage/VideoCallPage.dart';
import 'package:zego_uikit/zego_uikit.dart';

import '../main.dart';

class CallController extends GetxController {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  final uuid = Uuid().v4();

  @override
  void onInit() {
    super.onInit();
    getCallsNotification().listen((List<CallModel> callList) {
      if (callList.isNotEmpty) {
        var callData = callList[0];
        if (callData.type == "audio") {
          audioCallNotification(callData);
        } else if (callData.type == "video") {
          videoCallNotification(callData);
        }
      }
    });
  }

  @override
  void onClose() {
    cleanUpCall();
    super.onClose();
  }

  Future<void> audioCallNotification(CallModel callData) async {
    Get.snackbar(
      "Incoming Audio Call",
      callData.callerName ?? "",
      duration: Duration(days: 1),
      barBlur: 0,
      backgroundColor: Colors.grey[900]!,
      isDismissible: false,
      icon: Icon(Icons.call, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      onTap: (snack) {
        Get.back();
        Get.to(
          AudioCallPage(
            target: UserModel(
              id: callData.callerUid,
              name: callData.callerName,
              email: callData.callerEmail,
              profileImage: callData.callerPic,
            ),
          ),
        );
      },
      mainButton: TextButton(
        onPressed: () {
          endCall(callData);
          Get.back();
        },
        child: Text("End Call", style: TextStyle(color: Colors.red)),
      ),
    );
  }

  Future<void> videoCallNotification(CallModel callData) async {
    Get.snackbar(
      "Incoming Video Call",
      callData.callerName ?? "",
      duration: Duration(days: 1),
      barBlur: 0,
      backgroundColor: Colors.grey[900]!,
      isDismissible: false,
      icon: Icon(Icons.video_call, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      onTap: (snack) {
        Get.back();
        Get.to(
          VideoCallPage(
            target: UserModel(
              id: callData.callerUid,
              name: callData.callerName,
              email: callData.callerEmail,
              profileImage: callData.callerPic,
            ),
          ),
        );
      },
      mainButton: TextButton(
        onPressed: () {
          endCall(callData);
          Get.back();
        },
        child: Text("End Call", style: TextStyle(color: Colors.red)),
      ),
    );
  }

  Future<bool> requestCallPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      Permission.camera,
    ].request();

    bool allGranted = statuses.values.every((status) => status.isGranted);
    if (!allGranted) {
      Get.snackbar('Permissions Required', 'Camera and Microphone access is needed for calls.');
    }
    return allGranted;
  }

  Future<void> callAction(UserModel receiver, UserModel caller, String type) async {
    String id = uuid;
    DateTime timestamp = DateTime.now();
    String nowTime = DateFormat('hh:mm a').format(timestamp);
    var newCall = CallModel(
      id: id,
      callerName: caller.name,
      callerPic: caller.profileImage,
      callerUid: caller.id,
      callerEmail: caller.email,
      receiverName: receiver.name,
      receiverPic: receiver.profileImage,
      receiverUid: receiver.id,
      receiverEmail: receiver.email,
      status: "dialing",
      type: type,
      time: nowTime,
      timestamp: timestamp.toIso8601String(),
    );

    try {
      await db.collection("notification").doc(receiver.id).collection("call").doc(id).set(newCall.toJson());
      await db.collection("users").doc(auth.currentUser!.uid).collection("calls").add(newCall.toJson());
      await db.collection("users").doc(receiver.id).collection("calls").add(newCall.toJson());

      Future.delayed(Duration(seconds: 20), () {
        endCall(newCall);
      });
    } catch (e) {
      print("Call initiation error: $e");
    }
  }

  Stream<List<CallModel>> getCallsNotification() {
    return FirebaseFirestore.instance
        .collection("notification")
        .doc(auth.currentUser?.uid)
        .collection("call")
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => CallModel.fromJson(doc.data())).toList());
  }

  Future<void> endCall(CallModel call) async {
    try {
      await db.collection("notification").doc(call.receiverUid).collection("call").doc(call.id).delete();
    } catch (e) {
      print("Error ending call: $e");
    }
  }

  void cleanUpCall() {
    ZegoUIKit().leaveRoom();
    print("Cleaned up call session.");
  }

  void setupFCMListeners() {
    FirebaseMessaging.instance.getToken().then((token) {
      print("FCM Token: $token");
      // Optionally upload token to Firestore linked to user
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📨 Foreground message received: ${message.notification?.title}");
      _showLocalNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("📨 Message opened from terminated or background");
      // Navigate to call page or other logic
    });
  }

  void _showLocalNotification(RemoteMessage message) {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

    flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title ?? 'No Title',
      message.notification?.body ?? 'No body',
      platformDetails,
    );
  }
}
