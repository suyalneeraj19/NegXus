import 'dart:io';
import 'package:NegXus/Config/Images.dart';
import 'package:NegXus/Controller/GroupController.dart';
import 'package:NegXus/Controller/ProfileController.dart';
import 'package:NegXus/Model/GroupModel.dart';
import 'package:NegXus/Pages/Chat/ChatBubble.dart';
import 'package:NegXus/Pages/GroupChat/GroupTypeMessage.dart';
import 'package:NegXus/Pages/GroupInfo/GroupInfo.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class GroupChatPage extends StatelessWidget {
  final GroupModel groupModel;
  const GroupChatPage({super.key, required this.groupModel});

  @override
  Widget build(BuildContext context) {
    final GroupController groupController = Get.find<GroupController>();
    final ProfileController profileController = Get.find<ProfileController>();

    // Ensure the profile image map is populated when the page builds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      groupController.buildUserIdToProfileImageMap(groupModel.members ?? []);
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: InkWell(
          onTap: () => Get.to(() => GroupInfo(groupModel: groupModel)),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                  groupModel.profileUrl?.isEmpty ?? true ? AssetsImage.defaultProfileUrl : groupModel.profileUrl!,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(groupModel.name ?? "Group Name", style: Theme.of(context).textTheme.bodyLarge),
                  Text("Online", style: Theme.of(context).textTheme.labelSmall),
                ],
              ),
            ],
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.phone)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.video_call)),
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
                    stream: groupController.getGroupMessages(groupModel.id!),
                    builder: (context, snapshot) {
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
                          final timestamp = DateTime.tryParse(msg.timestamp ?? "") ?? DateTime.now();
                          final formattedTime = DateFormat('hh:mm a').format(timestamp);

                          final isComming = msg.senderId != profileController.currentUser.value.id;
                          final profileImage = groupController.userIdToProfileImage[msg.senderId] ?? AssetsImage.defaultProfileUrl;

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
                    final selectedPath = groupController.selectedImagePath.value;
                    if (selectedPath.isEmpty) return const SizedBox();

                    return Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        height: 300,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: FileImage(File(selectedPath)),
                            fit: BoxFit.contain,
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => groupController.selectedImagePath.value = "",
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            GroupTypeMessage(groupModel: groupModel),
          ],
        ),
      ),
    );
  }
}
