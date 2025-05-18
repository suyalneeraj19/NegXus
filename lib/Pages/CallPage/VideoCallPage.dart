import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:NegXus/Controller/ChatController.dart';
import 'package:NegXus/Controller/ProfileController.dart';
import 'package:NegXus/Model/UserModel.dart';

import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../../Config/String.dart';

class VideoCallPage extends StatefulWidget {
  final UserModel target;
  const VideoCallPage({Key? key, required this.target}) : super(key: key);

  @override
  _VideoCallPageState createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  late final String _callId;

  @override
  void initState() {
    super.initState();

    // 1️⃣ Compute a unique room/call ID
    final chatController = Get.find<ChatController>();
    _callId = chatController.getRoomId(widget.target.id!);

    // 2️⃣ Send the system call invitation (video)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ZegoUIKitPrebuiltCallInvitationService().send(
        invitees: [
          // positional constructor: (id, name)
          ZegoCallUser(widget.target.id!, widget.target.name!),
        ],
        isVideoCall: true, // true = video call
        callID: _callId, // your generated call ID
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();

    // 3️⃣ Present the in‑app video‑call UI
    return ZegoUIKitPrebuiltCall(
      appID: ZegoCloudConfig.appId,
      appSign: ZegoCloudConfig.appSign,
      userID: profileController.currentUser.value.id ?? 'root',
      userName: profileController.currentUser.value.name ?? 'root',
      callID: _callId,
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
    );
  }
}
