import 'package:NegXus/Pages/Auth/AuthPageBody.dart';
import 'package:NegXus/Pages/Welcome/WelcomeHeading.dart';
import 'package:flutter/material.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                WelcomeHeading(),
                SizedBox(height: 30),
                AuthPageBody(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
