import 'package:NegXus/Pages/Auth/AuthPage.dart';
import 'package:NegXus/Pages/HomePage/HomePage.dart';
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
];
