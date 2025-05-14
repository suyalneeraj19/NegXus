import 'package:NegXus/Pages/Auth/AuthPage.dart';
import 'package:NegXus/Pages/ContactPage/ContactPage.dart';
import 'package:NegXus/Pages/HomePage/HomePage.dart';
import 'package:NegXus/Pages/ProfilePage/ProfilePage.dart';
import 'package:get/get.dart';

var pagePath = [
  GetPage(
    name: "/authPage",
    page: () => AuthPage(),
    transition: Transition.rightToLeft,
  ),
  GetPage(
    name: "/homePage",
    page: () => HomePage(),
    transition: Transition.rightToLeft,
  ),
  GetPage(
    name: "/profilePage",
    page: () => ProfilePage(),
    transition: Transition.rightToLeft,
  ),
  GetPage(
    name: "/contactPage",
    page: () => ContactPage(),
    transition: Transition.rightToLeft,
  ),
];
