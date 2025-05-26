import 'dart:io';

import 'package:NegXus/Config/Images.dart';
import 'package:NegXus/Controller/CallController.dart';
import 'package:NegXus/Controller/ChatController.dart';
import 'package:NegXus/Controller/ProfileController.dart';
import 'package:NegXus/Model/UserModel.dart';
import 'package:NegXus/Pages/CallPage/AudioCallPage.dart';
import 'package:NegXus/Pages/CallPage/VideoCallPage.dart';
import 'package:NegXus/Pages/Chat/ChatBubble.dart';
import 'package:NegXus/Pages/Chat/TypeMessage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../UserProfile/UserProfilePage.dart';

class ChatPage extends StatelessWidget {
  final UserModel userModel;
  const ChatPage({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.put(ChatController());
    final ProfileController profileController = Get.put(ProfileController());
    final CallController callController = Get.put(CallController());
    final TextEditingController messageController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Get.to(() => UserProfilePage(userModel: userModel)),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                userModel.profileImage ?? AssetsImage.defaultProfileUrl,
              ),
            ),
          ),
        ),
        title: GestureDetector(
          onTap: () => Get.to(() => UserProfilePage(userModel: userModel)),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(userModel.name ?? "User", style: Theme.of(context).textTheme.bodyLarge),
                  StreamBuilder(
                    stream: chatController.getStatus(userModel.id!),
                    builder: (context, snapshot) {
                      final status = snapshot.data?.status ?? "Unknown";
                      return Text(
                        status,
                        style: TextStyle(
                          fontSize: 12,
                          color: status == "Online" ? Colors.green : Colors.grey,
                        ),
                      );
                    },
                  )
                ],
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.phone),
            onPressed: () {
              Get.to(() => AudioCallPage(target: userModel));
              callController.callAction(userModel, profileController.currentUser.value, "audio");
            },
          ),
          IconButton(
            icon: Icon(Icons.video_call),
            onPressed: () {
              Get.to(() => VideoCallPage(target: userModel));
              callController.callAction(userModel, profileController.currentUser.value, "video");
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  StreamBuilder(
                    stream: chatController.getMessages(userModel.id!),
                    builder: (context, snapshot) {
                      final roomId = chatController.getRoomId(userModel.id!);
                      chatController.markMessagesAsRead(roomId!);

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      }

                      final messages = snapshot.data;
                      if (messages == null || messages.isEmpty) {
                        return const Center(child: Text("No Messages"));
                      }

                      return ListView.builder(
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final msg = messages[index];
                          final timestamp = DateTime.parse(msg.timestamp!);
                          final formattedTime = DateFormat('hh:mm a').format(timestamp);

                          bool isComming = msg.receiverId == profileController.currentUser.value.id;
                          String profileImage = isComming
                              ? userModel.profileImage ?? AssetsImage.defaultProfileUrl
                              : profileController.currentUser.value.profileImage ?? AssetsImage.defaultProfileUrl;

                          return ChatBubble(
                            message: msg.message ?? "",
                            imageUrl: msg.imageUrl ?? "",
                            audioUrl: msg.audioUrl ?? "",
                            isComming: isComming,
                            status: msg.readStatus ?? "",
                            time: formattedTime,
                            profileImage: profileImage,
                          );
                        },
                      );
                    },
                  ),
                  Obx(() {
                    final imagePath = chatController.selectedImagePath.value;
                    return imagePath.isNotEmpty
                        ? Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Stack(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  height: 500,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: FileImage(File(imagePath)),
                                      fit: BoxFit.contain,
                                    ),
                                    color: Theme.of(context).colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  child: IconButton(
                                    icon: Icon(Icons.close),
                                    onPressed: () => chatController.selectedImagePath.value = "",
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox.shrink();
                  }),
                ],
              ),
            ),
            TypeMessage(
              userModel: userModel,
              messageController: messageController,
            ),
          ],
        ),
      ),
    );
  }
}
