import 'package:NegXus/Config/String.dart';
import 'package:NegXus/Controller/ChatController.dart';
import 'package:NegXus/Controller/ProfileController.dart';
import 'package:NegXus/Model/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class VideoCallPage extends StatelessWidget {
  final UserModel target;
  const VideoCallPage({super.key, required this.target});

  @override
  Widget build(BuildContext context) {
    ProfileController profileController = Get.put(ProfileController());
    ChatController chatController = Get.put(ChatController());

    String currentUserId = profileController.currentUser.value.id ?? "root";
    String currentUserName = profileController.currentUser.value.name ?? "root";
    String callId = chatController.getRoomId(target.id!);

    // Optional: send call invitation
    // ZegoUIKitPrebuiltCallInvitationService().sendCallInvitation(
    //   inviterName: currentUserName,
    //   invitees: [ZegoUIKitUser(id: target.id!, name: target.name!)],
    //   callID: callId,
    //   isVideoCall: true,
    // );

    return ZegoUIKitPrebuiltCall(
      appID: ZegoCloudConfig.appId,
      appSign: ZegoCloudConfig.appSign,
      userID: currentUserId,
      userName: currentUserName,
      callID: callId,
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
    );
  }
}
