import 'package:NegXus/Config/Images.dart';
import 'package:NegXus/Pages/Chat/ChatBubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Image.asset(AssetsImage.girlPicPNG),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Ritika"),
            Text(
              "Online",
              style: Theme.of(context).textTheme.labelSmall,
            )
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.phone),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.video_call),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(10),
                children: const [
                  ChatBubble(
                    sms: "Hello World",
                    imageUrl: '',
                    isComing: true,
                    status: "read",
                    time: "10:30 A.M",
                  ),
                  ChatBubble(
                    sms: "Hello World",
                    imageUrl: "https://i.pinimg.com/564x/2d/1d/0c/2d1d0c17ecb30e266f2aaa29da8566a7.jpg",
                    isComing: false,
                    status: "read",
                    time: "10:30 A.M",
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: SvgPicture.asset(
                      AssetsImage.micSVG,
                      width: 25,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        filled: false,
                        hintText: "Type Message",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: SvgPicture.asset(
                      AssetsImage.gallerySVG,
                      width: 25,
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: SvgPicture.asset(
                      AssetsImage.sendSVG,
                      width: 25,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
