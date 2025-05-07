import 'package:flutter/material.dart';
import 'package:NegXus/Config/Images.dart';
import 'package:NegXus/Config/String.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:slide_to_act/slide_to_act.dart';

class WelcomeFooterButton extends StatelessWidget {
  const WelcomeFooterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SlideAction(
      onSubmit: () {
        Get.offAllNamed("/authPage");
      },
      sliderButtonIcon: Container(
        width: 25,
        height: 25,
        child: SvgPicture.asset(
          AssetsImage.socketSVG,
          width: 25,
        ),
      ),
      text: WelcomePageString.slide,
      textStyle: Theme.of(context).textTheme.labelLarge,
      animationDuration: Duration(seconds: 1),
      reversed: false,
      sliderRotate: false,
      submittedIcon: SvgPicture.asset(
        AssetsImage.socketSVG,
        width: 25,
      ),
      innerColor: Colors.orange,
      outerColor: Theme.of(context).colorScheme.primaryContainer,
    );
  }
}
