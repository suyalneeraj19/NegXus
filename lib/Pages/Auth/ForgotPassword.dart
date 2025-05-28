import 'package:NegXus/Controller/AuthController.dart';
import 'package:NegXus/Pages/Widgets/PrimaryButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
    AuthController authController = Get.put(AuthController());
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Enter your email id and we will send you reset password link on email",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: email,
              decoration: InputDecoration(
                hintText: "Enter Email id",
                fillColor: Theme.of(context).colorScheme.primaryContainer,
              ),
            ),
            SizedBox(height: 20),
            PrimaryButton(
              btnName: "Reset Now",
              icon: Icons.password_outlined,
              ontap: () {
                authController.resetPassword(email.text);
              },
            ),
          ],
        ),
      ),
    );
  }
}
