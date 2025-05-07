import 'package:NegXus/Config/Images.dart';
import 'package:NegXus/Config/String.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WelcomeHeading extends StatelessWidget {
  const WelcomeHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AssetsImage.appIconSVG,
              color: Colors.white,
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          AppString.appName,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.orange),
        )
      ],
    );
  }
}
