import 'package:mukai/src/controllers/auth.controller.dart';
import 'package:mukai/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/eva.dart';
import 'package:get/get.dart';

class EmailnPasswordWidget extends StatelessWidget {
  EmailnPasswordWidget({super.key});
  AuthController get authController => Get.put(AuthController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(0.0),
        ),
        border: Border.all(
          color: Colors.transparent,
        ),
        // boxShadow: boxShadow,
      ),
      child: Column(
        children: [
          emailField(),
          height20Space,
          passwordField(),
        ],
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
          style: TextStyle(color: Colors.black), // Changed to black text
          cursorColor: primaryColor,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.grey), // Border color when not focused
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: primaryColor), // Border color when focused
              borderRadius: BorderRadius.circular(10.0),
            ),
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
            authController.password.value = value,
          },
          obscureText: true,
          style: TextStyle(color: Colors.black), // Changed to black text
          cursorColor: primaryColor,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.grey), // Border color when not focused
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: primaryColor), // Border color when focused
              borderRadius: BorderRadius.circular(10.0),
            ),
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
    color: whiteF5Color,
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: recShadow,
  );
}