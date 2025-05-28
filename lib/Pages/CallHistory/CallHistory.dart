import 'package:NegXus/Config/Images.dart';
import 'package:NegXus/Controller/ChatController.dart';
import 'package:NegXus/Controller/ProfileController.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CallHistory extends StatelessWidget {
  const CallHistory({super.key});

  @override
  Widget build(BuildContext context) {
    ChatController chatController = Get.put(ChatController());
    ProfileController profileController = Get.put(ProfileController());

    return StreamBuilder(
      stream: chatController.getCalls(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No call history available."));
        }

        final calls = snapshot.data!;

        return ListView.builder(
          itemCount: calls.length,
          itemBuilder: (context, index) {
            final call = calls[index];

            if (call.timestamp == null) {
              // Skip or show error tile if timestamp is missing
              return ListTile(
                leading: Icon(Icons.error),
                title: Text("Invalid call record"),
                subtitle: Text("Missing timestamp"),
              );
            }

            late String formattedTime;
            try {
              DateTime timestamp = DateTime.parse(call.timestamp!);
              formattedTime = DateFormat('hh:mm a').format(timestamp);
            } catch (e) {
              return ListTile(
                leading: Icon(Icons.error),
                title: Text("Invalid timestamp"),
                subtitle: Text(call.timestamp!),
              );
            }

            final isCurrentUserCaller = call.callerUid == profileController.currentUser.value.id;

            final profilePic = isCurrentUserCaller
                ? (call.receiverPic ?? AssetsImage.defaultProfileUrl)
                : (call.callerPic ?? AssetsImage.defaultProfileUrl);

            final displayName = isCurrentUserCaller ? (call.receiverName ?? "Unknown") : (call.callerName ?? "Unknown");

            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CachedNetworkImage(
                  imageUrl: profilePic,
                  fit: BoxFit.cover,
                  width: 50,
                  height: 50,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              title: Text(
                displayName,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              subtitle: Text(
                formattedTime,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              trailing: IconButton(
                icon: Icon(call.type == "video" ? Icons.video_call : Icons.call),
                onPressed: () {},
              ),
            );
          },
        );
      },
    );
  }
}
