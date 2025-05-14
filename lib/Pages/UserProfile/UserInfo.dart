import 'package:NegXus/Controller/CallController.dart';
import 'package:NegXus/Model/UserModel.dart';
import 'package:NegXus/Pages/CallPage/VideoCallPage.dart';
import 'package:NegXus/Pages/Chat/ChatPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../Config/Images.dart';
import '../../Controller/ProfileController.dart';
import '../CallPage/AudioCallPage.dart';

class LoginUserInfo extends StatelessWidget {
  final String profileImage;
  final String userName;
  final String userEmail;
  final UserModel userModel;

  const LoginUserInfo({super.key, required this.profileImage, required this.userName, required this.userEmail, required this.userModel});

  @override
  Widget build(BuildContext context) {
    ProfileController profileController = Get.put(ProfileController());
    CallController callController = Get.put(CallController());
    return Container(
      padding: EdgeInsets.all(20),
      // height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CachedNetworkImage(
                          imageUrl: profileImage,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      userName,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      userEmail,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        context,
                        svgPath: AssetsImage.callSVG,
                        label: "Call",
                        color: Color(0xff039C00),
                        onTap: () {
                          Get.to(AudioCallPage(target: userModel));
                          callController.callAction(userModel, profileController.currentUser.value, "audio");
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _buildActionButton(
                        context,
                        svgPath: AssetsImage.videocallSVG,
                        label: "Video",
                        color: Color(0xffFF9900),
                        onTap: () {
                          Get.to(VideoCallPage(target: userModel));
                          callController.callAction(userModel, profileController.currentUser.value, "video");
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _buildActionButton(
                        context,
                        svgPath: AssetsImage.appIconSVG,
                        label: "Chat",
                        color: Color(0xff0057FF),
                        onTap: () {
                          print("Chat tapped");
                          Get.back();
                          // Add your chat logic here
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String svgPath,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).colorScheme.background,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              svgPath,
              width: 20,
              color: color,
            ),
            SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
