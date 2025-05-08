import 'package:NegXus/Pages/HomePage/ChatTile.dart';
import 'package:flutter/material.dart';
import '../../Config/Images.dart';

class ChatsList extends StatelessWidget {
  const ChatsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ChatTile(
          imageUrl: AssetsImage.girlPicPNG,
          name: "Ritika ",
          lastChat: "Let's Catch up later",
          lastTime: "09:00 P.M",
        ),
        ChatTile(
          imageUrl: AssetsImage.boyPicPNG,
          name: "Aman ",
          lastChat: "kaisa hai bhai",
          lastTime: "07:00 P.M",
        )
      ],
    );
  }
}
