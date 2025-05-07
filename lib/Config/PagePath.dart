import 'package:NegXus/Pages/Auth/AuthPage.dart';
import 'package:get/get.dart';

var getPath = [
  GetPage(
    name: "/authPage",
    page: () => AuthPage(),
    transition: Transition.leftToRight,
  )
];
