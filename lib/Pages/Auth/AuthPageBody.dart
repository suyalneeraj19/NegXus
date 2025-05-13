import 'package:NegXus/Pages/Auth/LoginForm.dart';
import 'package:NegXus/Pages/Auth/SignupForm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthPageBody extends StatelessWidget {
  const AuthPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool isLogin = true.obs;
    return Obx(() => AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => isLogin.value = true,
                      child: SizedBox(
                        width: MediaQuery.sizeOf(context).width / 2.7,
                        child: Column(
                          children: [
                            Text(
                              "Login",
                              style: isLogin.value ? Theme.of(context).textTheme.bodyLarge : Theme.of(context).textTheme.labelLarge,
                            ),
                            const SizedBox(height: 5),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: isLogin.value ? 100 : 0,
                              height: 5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => isLogin.value = false,
                      child: SizedBox(
                        width: MediaQuery.sizeOf(context).width / 2.7,
                        child: Column(
                          children: [
                            Text(
                              "SignUp",
                              style: isLogin.value ? Theme.of(context).textTheme.labelLarge : Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 5),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: isLogin.value ? 0 : 100,
                              height: 5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                isLogin.value ? const LoginForm() : const SignupForm(),
              ],
            ),
          ),
        ));
  }
}
