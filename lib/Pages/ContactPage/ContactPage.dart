import 'package:NegXus/Controller/ContactController.dart';
import 'package:NegXus/Pages/Chat/ChatPage.dart';
import 'package:NegXus/Pages/ContactPage/ContactSearch.dart';
import 'package:NegXus/Pages/ContactPage/NewContactTile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Config/Images.dart';
import '../../Controller/ChatController.dart';
import '../HomePage/ChatTile.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    final RxBool isSearchEnabled = false.obs;
    final ContactController contactController = Get.put(ContactController());
    final ChatController chatController = Get.put(ChatController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select contact"),
        actions: [
          Obx(() => IconButton(
                icon: isSearchEnabled.value ? const Icon(Icons.close) : const Icon(Icons.search),
                onPressed: () => isSearchEnabled.value = !isSearchEnabled.value,
              )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: ListView(
          children: [
            // 1. Search toggle
            Obx(() => isSearchEnabled.value ? const ContactSearch() : const SizedBox()),

            const SizedBox(height: 10),

            // 2. New contact / group
            NewContactTile(
              btnName: "New Contact",
              icon: Icons.person_add,
              ontap: () {},
            ),
            const SizedBox(height: 10),
            NewContactTile(
              btnName: "New Group",
              icon: Icons.group_add,
              ontap: () {},
            ),

            const SizedBox(height: 10),

            // 3. Section header
            Text(
              "Contacts on NegXus",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 10),

            // 4. Contacts list
            Obx(
              () => Column(
                children: contactController.userList.map((user) {
                  final imageUrl = (user.profileImage != null && user.profileImage!.startsWith('http'))
                      ? user.profileImage!
                      : AssetsImage.defaultProfileUrl;

                  return InkWell(
                    onTap: () {
                      ChatPage(userModel: user);
                      String roomId = chatController.getRoomId(user.id!);
                      print(roomId);
                    },
                    child: ChatTile(
                      imageUrl: imageUrl,
                      name: user.name ?? "User",
                      lastChat: user.about ?? "Hello",
                      lastTime: "",
                    ),
                  );
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
