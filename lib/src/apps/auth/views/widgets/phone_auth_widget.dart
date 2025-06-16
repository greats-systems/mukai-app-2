import 'package:mukai/src/controllers/auth.controller.dart';
import 'package:mukai/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/eva.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhoneAuthWidget extends StatelessWidget {
  PhoneAuthWidget({super.key});
  AuthController get authController => Get.put(AuthController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [phoneField()],
    );
  }

  registerButton() {
    return GestureDetector(
      onTap: () {
        authController.register();
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
          "Register",
          style: bold18WhiteF5,
        ),
      ),
    );
  }

  emailField() {
    return Container(
      width: double.maxFinite,
      clipBehavior: Clip.hardEdge,
      decoration: bgBoxDecoration,
      child: Container(
        decoration: BoxDecoration(
          color: recWhiteColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: TextField(
          onChanged: (value) => {
            authController.email.value = value,
          },
          style: medium15White,
          cursorColor: primaryColor,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: fixPadding * 1.5),
            hintText: "Enter email address",
            hintStyle: medium15Grey,
            prefixIconConstraints: BoxConstraints(maxWidth: 45.0),
            prefixIcon: Center(
              child: Iconify(
                Eva.email_outline,
                color: primaryColor,
                size: 22.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  phoneField() {
    return IntlPhoneField(
      // focusNode: FocusNode(onKeyEvent: ),
      keyboardType: TextInputType.phone,
      onChanged: (value) => {
        authController.phoneNumber.value =
            '${value.countryCode}${value.number.replaceFirst(RegExp(r'0'), '')}',
      },
      controller: phoneController,
      disableLengthCheck: true,
      showCountryFlag: false,
      dropdownTextStyle: semibold15Grey,
      initialCountryCode: "ZW",
      dropdownIconPosition: IconPosition.trailing,
      dropdownIcon: const Icon(
        Icons.keyboard_arrow_down,
        color: blackColor,
      ),
      style: medium15White,
      dropdownDecoration: const BoxDecoration(
        border: Border(
          right: BorderSide(color: whiteF5Color, width: 2.0),
        ),
      ),
      pickerDialogStyle: PickerDialogStyle(backgroundColor: whiteF5Color),
      flagsButtonMargin: const EdgeInsets.symmetric(
          horizontal: fixPadding, vertical: fixPadding / 1.5),
      decoration: InputDecoration(
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Colors.grey), // Border color when not focused
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: primaryColor), // Border color when focused
          borderRadius: BorderRadius.circular(10.0),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: fixPadding * 1.5),
        hintText: "Enter your mobile number",
        hintStyle: medium15Grey,
      ),
    );
  }

  passwordField() {
    return Container(
      width: double.maxFinite,
      clipBehavior: Clip.hardEdge,
      decoration: bgBoxDecoration,
      child: Container(
        decoration: BoxDecoration(
          color: recWhiteColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: TextField(
          onChanged: (value) => {
            authController.fullName.value = value,
          },
          style: medium15White,
          cursorColor: primaryColor,
          keyboardType: TextInputType.name,
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: fixPadding * 1.5),
            hintText: "Enter password",
            hintStyle: medium15Grey,
            prefixIconConstraints: BoxConstraints(maxWidth: 45.0),
            prefixIcon: Center(
              child: Icon(
                Icons.person_outline,
                color: primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration bgBoxDecoration = BoxDecoration(
    color: recColor,
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: recShadow,
  );
}
