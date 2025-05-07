import 'package:flutter/cupertino.dart';
import 'package:NegXus/Config/Images.dart';
import 'package:NegXus/Config/String.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomeBody extends StatelessWidget {
  const WelcomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Image.asset(AssetsImage.boyPicPNG), SvgPicture.asset(AssetsImage.connSVG), Image.asset(AssetsImage.girlPicPNG)],
        ),
        SizedBox(
          height: 40,
        ),
        Text(
          WelcomePageString.youAreConnected,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Text(
          WelcomePageString.connected,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.orange),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          WelcomePageString.description,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelLarge,
        )
      ],
    );
  }
}
