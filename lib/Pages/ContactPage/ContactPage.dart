import 'package:NegXus/Pages/ContactPage/ContactSearch.dart';
import 'package:NegXus/Pages/ContactPage/NewContactTile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../Config/Images.dart';
import '../HomePage/ChatTile.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool isSearchEnabled = false.obs;
    return Scaffold(
      appBar: AppBar(
        title: Text("Select contact"),
        actions: [
          Obx(
            () => IconButton(
              onPressed: () {
                isSearchEnabled.value = !isSearchEnabled.value;
              },
              icon: isSearchEnabled.value ? Icon(Icons.close) : Icon(Icons.search),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: ListView(
          children: [
            Obx(
              () => isSearchEnabled.value ? ContactSearch() : SizedBox(),
            ),
            SizedBox(height: 10),
            NewContactTile(
              btnName: "New Contact",
              icon: Icons.person_add,
              ontap: () {},
            ),
            SizedBox(height: 10),
            NewContactTile(
              btnName: "New Group",
              icon: Icons.group_add,
              ontap: () {},
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  "Contacts on NegXus",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            SizedBox(height: 10),
            Column(
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
                ),
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
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
