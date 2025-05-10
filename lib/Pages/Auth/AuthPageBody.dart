import 'package:NegXus/Pages/Auth/LoginForm.dart';
import 'package:NegXus/Pages/Auth/SignupForm.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class AuthPageBody extends StatefulWidget {
  const AuthPageBody({super.key});

  @override
  State<AuthPageBody> createState() => _AuthPageBodyState();
}

class _AuthPageBodyState extends State<AuthPageBody> with TickerProviderStateMixin {
  final RxBool isLogin = true.obs;

  @override
  Widget build(BuildContext context) {
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
