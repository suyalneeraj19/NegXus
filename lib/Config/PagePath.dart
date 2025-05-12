import 'package:NegXus/Pages/Auth/AuthPage.dart';
import 'package:NegXus/Pages/Chat/ChatPage.dart';
import 'package:NegXus/Pages/ContactPage/ContactPage.dart';
import 'package:NegXus/Pages/HomePage/HomePage.dart';
import 'package:NegXus/Pages/UserProfile/UserProfilePage.dart';
import 'package:NegXus/Pages/UserProfile/UserUpdateProfile.dart';
import 'package:get/get.dart';

var getPath = [
  GetPage(
    name: "/authPage",
    page: () => AuthPage(),
    transition: Transition.leftToRight,
  ),
  GetPage(
    name: "/homePage",
    page: () => HomePage(),
    transition: Transition.leftToRight,
  ),
  GetPage(
    name: "/chatPage",
    page: () => ChatPage(),
    transition: Transition.leftToRight,
  ),
  GetPage(
    name: "/ProfilePage",
    page: () => UserProfilePage(),
    transition: Transition.leftToRight,
  ),
  GetPage(
    name: "/updateProfilePage",
    page: () => UserUpdateProfile(),
    transition: Transition.leftToRight,
  ),
  GetPage(
    name: "/contactPage",
    page: () => ContactPage(),
    transition: Transition.leftToRight,
  ),
];
