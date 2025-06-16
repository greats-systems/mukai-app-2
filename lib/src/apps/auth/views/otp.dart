import 'dart:async';
import 'dart:developer';

import 'package:mukai/src/controllers/auth.controller.dart';
import 'package:mukai/theme/theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pinput/pinput.dart';

class OTPScreen extends StatelessWidget {
  OTPScreen({super.key});
  Timer? countdownTimer;
  Duration myDuration = const Duration(minutes: 1);
  AuthController get authController => Get.put(AuthController());
  final GetStorage _getStorage = GetStorage();

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: recColor,
        elevation: 0.0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        toolbarHeight: 50.0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: whiteF5Color,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: recColor,
                boxShadow: boxShadow,
              ),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(fixPadding * 2.0),
                children: [
                  heightSpace,
                  heightSpace,
                  otpContent(),
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  otpField(),
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  timer(minutes, seconds),
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
                              "verifying ...",
                              style: semibold14LightWhite,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )
                      : verifyButton(context)),
                  heightSpace,
                  heightSpace,
                  resendText()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  timer(String minutes, String seconds) {
    return Text(
      "$minutes:$seconds",
      style: semibold18Primary,
      textAlign: TextAlign.center,
    );
  }

  resendText() {
    return Text.rich(
      TextSpan(
        text: "Didn’t receive code?",
        style: medium18WhiteF5,
        children: [
          const TextSpan(text: " "),
          TextSpan(
            text: "Resend",
            style: semibold18Primary,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // if (myDuration == const Duration(seconds: 0)) {
                //   resetTimer();
                //   startTimer();
                // }
              },
          )
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  verifyButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await authController.verify();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: fixPadding * 1.4, horizontal: fixPadding * 2.0),
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: buttonShadow,
        ),
        alignment: Alignment.center,
        child: const Text(
          "Verify",
          style: bold18White,
        ),
      ),
    );
  }

  pleaseWaitDialog(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Dialog(
          surfaceTintColor: Colors.transparent,
          backgroundColor: dialogBgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          insetPadding: const EdgeInsets.all(fixPadding * 2.0),
          child: Container(
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(
                vertical: fixPadding * 4.5, horizontal: fixPadding * 2.0),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: whiteF5Color,
                  strokeWidth: 3.0,
                ),
                heightSpace,
                Text(
                  "Please wait",
                  style: semibold18WhiteF5,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  otpField() {
    return Pinput(
      length: 6,
      cursor: Container(
        height: 20.0,
        width: 2.0,
        color: primaryColor,
      ),
      onCompleted: (value) {
        log('Pinput $value');
        authController.otp_secret.value = value;
      },
      defaultPinTheme: PinTheme(
        height: 50.0,
        width: 50.0,
        textStyle: semibold18White,
        margin: const EdgeInsets.symmetric(horizontal: fixPadding / 3),
        decoration: BoxDecoration(
          color: recWhiteColor,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
                color: blackOrignalColor.withOpacity(0.1),
                blurRadius: 10.0,
                blurStyle: BlurStyle.outer)
          ],
        ),
      ),
    );
  }

  otpContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "OTP Verification",
          style: semibold20White,
          textAlign: TextAlign.center,
        ),
        heightSpace,
        Text(
          "A 6 digit code send on your mobile number",
          style: semibold14LightWhite,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  appLogo() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/logo.png",
            height: 100.0,
          ),
        ],
      ),
    );
  }
}
