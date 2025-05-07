import 'package:NegXus/Config/Images.dart';
import 'package:NegXus/Config/String.dart';
import 'package:NegXus/Pages/Welcome/WelcomeBody.dart';
import 'package:NegXus/Pages/Welcome/WelcomeFooterButton.dart';
import 'package:NegXus/Pages/Welcome/WelcomeHeading.dart';
import 'package:NegXus/Pages/Welcome/WelcomeHeading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:slide_to_act/slide_to_act.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [WelcomeHeading(), WelcomeBody(), WelcomeFooterButton()],
        ),
      )),
    );
  }
}
