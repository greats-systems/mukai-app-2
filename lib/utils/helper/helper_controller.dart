import 'package:mukai/theme/theme.dart';
import 'package:mukai/utils/constants/colors.dart';
import 'package:mukai/utils/constants/sizes.dart';
import 'package:mukai/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class Helper extends GetxController {
  var uuid = const Uuid();

  /* -- ============= VALIDATIONS ================ -- */

  static String? validateEmail(value) {
    if (value == null || value.isEmpty) return tEmailCannotEmpty;
    if (!GetUtils.isEmail(value)) return tInvalidEmailFormat;
    return null;
  }

  static String? validatePassword(value) {
    if (value == null || value.isEmpty) return 'Password cannot be empty';

    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Use 8 characters, an uppercase letter, number and symbol';
    }
    return null;
  }

  /* -- ============= SNACK-BARS ================ -- */

  static successSnackBar({required title, message, duration}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: tSecondaryColor,
      backgroundColor: successColor,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: duration),
      margin: const EdgeInsets.all(tDefaultSpace - 10),
      icon: const Icon(Icons.check_circle, color: tWhiteColor),
    );
  }

  static warningSnackBar({required title, message, duration}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: tWhiteColor,
      backgroundColor: Colors.orange,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: duration),
      margin: const EdgeInsets.all(tDefaultSpace - 10),
      icon: const Icon(Icons.question_answer, color: tWhiteColor),
    );
  }

  static errorSnackBar({required title, message, duration}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: tWhiteColor,
      backgroundColor: Colors.red.shade600,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: duration ?? 3),
      margin: const EdgeInsets.all(tDefaultSpace - 10),
      icon: const Icon(Icons.timelapse_rounded, color: tWhiteColor),
    );
  }

  static modernSnackBar({required title, message, duration}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      colorText: tWhiteColor,
      backgroundColor: Colors.blueGrey,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: duration),
      margin: const EdgeInsets.all(tDefaultSpace - 10),
    );
  }

  static fullScreenDialogLoader() {
    showDialog(
      barrierDismissible: false,
      context: Get.context!,
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

  static String getInitials(String name) {
    if (name.isEmpty) return '';

    final nameParts = name.trim().split(' ');
    if (nameParts.isEmpty) return '';

    if (nameParts.length == 1) {
      return nameParts[0].substring(0, 1).toUpperCase();
    }

    return '${nameParts[0].substring(0, 1)}${nameParts[1].substring(0, 1)}'
        .toUpperCase();
  }
}
