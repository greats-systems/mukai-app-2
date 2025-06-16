import 'package:mukai/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FullScreenDialogLoader {
  static void showDialog() {
    Get.dialog(
        PopScope(
            onPopInvoked: Future.value,
            child: Dialog(
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
            )),
        barrierDismissible: false,
        barrierColor: dialogBgColor,
        useSafeArea: true);
  }

  static void cancelDialog() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }
}
