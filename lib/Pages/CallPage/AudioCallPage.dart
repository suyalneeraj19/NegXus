import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:NegXus/Controller/ChatController.dart';
import 'package:NegXus/Controller/ProfileController.dart';
import 'package:NegXus/Model/UserModel.dart';

import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../../Config/String.dart';

class AudioCallPage extends StatefulWidget {
  final UserModel target;
  const AudioCallPage({Key? key, required this.target}) : super(key: key);

  @override
  _AudioCallPageState createState() => _AudioCallPageState();
}

class _AudioCallPageState extends State<AudioCallPage> {
  late final String _callId;

  @override
  void initState() {
    super.initState();

    // 1️⃣ Compute a unique room/call ID
    final chatController = Get.find<ChatController>();
    _callId = chatController.getRoomId(widget.target.id!);

    // 2️⃣ Send the system call invitation (audio)
    //    Wrap in a post-frame callback so it only fires once, after the widget mounts.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ZegoUIKitPrebuiltCallInvitationService().send(
        invitees: [
          // Note: ZegoCallUser takes **positional** (id, name), not named parameters.
          ZegoCallUser(widget.target.id!, widget.target.name!),
        ],
        isVideoCall: false, // false = audio
        callID: _callId, // your generated call ID
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();

    // 3️⃣ Present the in‑app voice‑call UI
    return ZegoUIKitPrebuiltCall(
      appID: ZegoCloudConfig.appId,
      appSign: ZegoCloudConfig.appSign,
      userID: profileController.currentUser.value.id ?? 'root',
      userName: profileController.currentUser.value.name ?? 'root',
      callID: _callId,
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall(),
    );
  }
}
