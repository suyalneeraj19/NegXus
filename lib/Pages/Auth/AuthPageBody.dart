import 'package:NegXus/Pages/Auth/LoginForm.dart';
import 'package:NegXus/Pages/Auth/SignupForm.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class AuthPageBody extends StatelessWidget {
  const AuthPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool isLogin = false.obs;
    return Container(
      padding: EdgeInsets.all(20),
      height: 388,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Row(
        children: [
          Expanded(
              child: Column(
            children: [
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        isLogin.value = true;
                      },
                      child: Container(
                        width: MediaQuery.sizeOf(context).width / 2.7,
                        child: Column(
                          children: [
                            Text(
                              "Login",
                              style: isLogin.value ? Theme.of(context).textTheme.bodyLarge : Theme.of(context).textTheme.labelLarge,
                            ),
                            SizedBox(height: 5),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              width: isLogin.value ? 100 : 0,
                              height: 5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        isLogin.value = false;
                      },
                      child: Container(
                        width: MediaQuery.sizeOf(context).width / 2.7,
                        child: Column(
                          children: [
                            Text(
                              "SignUp",
                              style: isLogin.value ? Theme.of(context).textTheme.labelLarge : Theme.of(context).textTheme.bodyLarge,
                            ),
                            SizedBox(height: 5),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              width: isLogin.value ? 0 : 100,
                              height: 5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Obx(() => isLogin.value ? LoginForm() : SignupForm()),
            ],
          ))
        ],
      ),
    );
  }
}
