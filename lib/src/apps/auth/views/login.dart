import 'dart:io';

import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ri.dart';
import 'package:mukai/src/controllers/auth.controller.dart';
import 'package:mukai/src/apps/auth/views/register.dart';
import 'package:mukai/src/apps/auth/views/widgets/emailpass.dart';
import 'package:mukai/src/apps/auth/views/widgets/phone_auth_widget.dart';
import 'package:mukai/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  DateTime? backPressTime;
  AuthController get authController => Get.put(AuthController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    authController.initialize();
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        bool backStatus = onPopInvoked();
        if (backStatus) {
          exit(0);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: whiteF5Color,
        ),
        backgroundColor: whiteF5Color,
        body: Column(
          children: [
            Expanded(
              child: Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: whiteF5Color,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20.0),
                  ),
                  border: Border.all(
                    color: whiteF5Color.withOpacity(0.05),
                  ),
                  boxShadow: boxShadow,
                ),
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(fixPadding * 2.0),
                  children: [
                    appLogo(),
                    loginContent(),
                    heightSpace,
                    heightSpace,
                    Obx(() => authController.loginOption.value == 'email'
                        ? EmailnPasswordWidget()
                        : PhoneAuthWidget()),
                    heightSpace,
                    heightSpace,
                    heightSpace,
                    heightSpace,
                    heightSpace,
                    Obx(() => authController.isLoading.value == true
                        ? Column(
                            children: [
                              const LinearProgressIndicator(),
                              Text(
                                "Signing in ...",
                                style: semibold14Black,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )
                        : loginButton()),
                    heightSpace,
                    heightSpace,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.to(() => RegisterScreen());
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              heightSpace,
                              Text(
                                "New to our platform?",
                                style: semibold14Black,
                                textAlign: TextAlign.center,
                              ),
                              widthSpace,
                              Row(
                                spacing: 10,
                                children: [
                                  Text(
                                    "Register",
                                    style: TextStyle(color: secondaryColor),
                                    textAlign: TextAlign.center,
                                  ),
                                  Iconify(
                                    Ri.arrow_right_line,
                                    size: 24,
                                    color: secondaryColor,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  loginButton() {
    return GestureDetector(
      onTap: () {
        if (authController.loginOption.value == 'phone') {
          authController.login();
        } else {
          authController.signin();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: fixPadding * 1.4, horizontal: fixPadding * 2.0),
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        alignment: Alignment.center,
        child: const Text(
          "Login",
          style: bold18WhiteF5,
        ),
      ),
    );
  }

  loginContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        heightSpace,
        Text(
          "Login into your account using phone number or email and password.",
          style: semibold14Black,
          textAlign: TextAlign.center,
        ),
        height20Space,
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                  vertical: fixPadding * 0.4, horizontal: fixPadding * 1.0),
              decoration: BoxDecoration(
                color: whiteF5Color,
                borderRadius: BorderRadius.circular(10.0),
              ),
              alignment: Alignment.center,
              height: 40,
              child: Text(
                'Login with phone number instead?',
                style: semibold14Black,
              ),
            ),
            Obx(
              () => Switch(
                activeColor: primaryColor,
                value:
                    authController.loginOption.value == 'phone' ? true : false,
                onChanged: (bool value) {
                  value == true
                      ? authController.loginOption('phone')
                      : authController.loginOption('email');
                },
              ),
            )
          ],
        )
      ],
    );
  }

  appLogo() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/logo-nobg.png",
            height: 200.0,
          ),
          Text(
            'express your greatness',
            style: TextStyle(
                fontStyle: FontStyle.italic,
                color: blackOrignalColor,
                fontSize: 11),
          )
        ],
      ),
    );
  }

  onPopInvoked() {
    DateTime now = DateTime.now();
    if (backPressTime == null ||
        now.difference(backPressTime!) >= const Duration(seconds: 2)) {
      backPressTime = now;
      return false;
    } else {
      return true;
    }
  }
}
