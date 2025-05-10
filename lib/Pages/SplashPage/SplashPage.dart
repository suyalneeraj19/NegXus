import 'package:NegXus/Config/Images.dart';
import 'package:NegXus/Controller/SplashController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class Splashpage extends StatelessWidget {
  const Splashpage({super.key});

  @override
  Widget build(BuildContext context) {
    SplashController spalshController = Get.put(SplashController());
    return Scaffold(
      body: Center(
        child: SvgPicture.asset(
          AssetsImage.appIconSVG,
          color: Colors.orange,
        ),
      ),
    );
  }
}
