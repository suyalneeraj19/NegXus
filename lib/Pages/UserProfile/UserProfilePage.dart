import 'package:NegXus/Config/Images.dart';
import 'package:NegXus/Controller/AuthController.dart';
import 'package:NegXus/Controller/ProfileController.dart';
import 'package:NegXus/Model/UserModel.dart';
import 'package:NegXus/Pages/ProfilePage/ProfilePage.dart';
import 'package:NegXus/Pages/UserProfile/UserInfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class UserProfilePage extends StatelessWidget {
  final UserModel userModel;
  const UserProfilePage({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.put(AuthController());
    ProfileController profileController = Get.put(ProfileController());
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            LoginUserInfo(
              profileImage: userModel.profileImage ?? AssetsImage.defaultProfileUrl,
              userName: userModel.name ?? "User",
              userEmail: userModel.email ?? "",
              userModel: userModel,
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                authController.logoutUser();
              },
              child: Text("Logout"),
            )
          ],
        ),
      ),
    );
  }
}
