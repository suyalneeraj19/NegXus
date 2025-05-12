import 'package:NegXus/Pages/Chat/ChatPage.dart';
import 'package:NegXus/Pages/HomePage/ChatTile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../Config/Images.dart';

class ChatsList extends StatelessWidget {
  const ChatsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        InkWell(
            onTap: () {
              Get.toNamed("/chatPage");
            },
            child: ChatTile(
              imageUrl: AssetsImage.defaultProfileUrl,
              name: "Ritika ",
              lastChat: "Let's Catch up later",
              lastTime: "09:00 P.M",
            )),
        ChatTile(
          imageUrl: AssetsImage.defaultProfileUrl,
          name: "Aman ",
          lastChat: "kaisa hai bhai",
          lastTime: "07:00 P.M",
        ),
      ],
    );
  }
}
