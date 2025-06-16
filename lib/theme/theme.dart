import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF114b25);
const Color secondaryColor = Color(0xFFb89e52);
const Color tertiaryColor = Color(0xFFd7bb66);
const Color leafColor = Color(0xFF56a452);
const Color screenBGColor = Color.fromARGB(255, 255, 255, 255);
const Color blackOrignalColor = Colors.black;
const Color blackColor = Colors.black;
const Color whiteF5Color = Color(0xFFF5F5F5);
const Color whiteColor = Colors.white;
const Color greyColor = Color(0xFFAAA9A9);
const Color greyD9Color = Color(0xFFD9D9D9);
const Color recColor = Color(0xFF010F2E);
const Color dialogBgColor = Color(0xFF373940);
const Color redColor = Color(0xFFE46554);
const Color yellowColor = Color(0xFFE8CB36);
const Color rec2CColor = Color(0xFF2C2C33);
const Color greyB5Color = Color(0xFFB5BEC6);
const Color successColor = Color.fromARGB(182, 6, 152, 45);
Color lightWhiteColor = whiteColor.withOpacity(0.5);
Color recWhiteColor = whiteColor.withOpacity(0.05);

const double fixPadding = 10.0;

const SizedBox heightSpace = SizedBox(height: fixPadding);
const SizedBox height5Space = SizedBox(height: 5.0);
const SizedBox height20Space = SizedBox(height: 20.0);
const SizedBox widthSpace = SizedBox(width: fixPadding);
const SizedBox width5Space = SizedBox(width: 5.0);
const SizedBox width20Space = SizedBox(width: 20.0);

SizedBox heightBox(double height) {
  return SizedBox(height: height);
}

SizedBox widthBox(double width) {
  return SizedBox(width: width);
}

final List<BoxShadow> boxShadow = [
  BoxShadow(
    color: blackOrignalColor.withOpacity(0.4),
    blurRadius: 10.0,
    offset: const Offset(0, 10),
  )
];

final List<BoxShadow> recShadow = [
  BoxShadow(
    color: blackOrignalColor.withOpacity(0.1),
    blurRadius: 10.0,
    offset: const Offset(0, 10),
  )
];

final List<BoxShadow> buttonShadow = [
  BoxShadow(
    color: primaryColor.withOpacity(0.1),
    blurRadius: 12.0,
    offset: const Offset(0, 6),
  )
];

const TextStyle bold16Primary =
    TextStyle(color: primaryColor, fontSize: 16.0, fontWeight: FontWeight.w700);

const TextStyle bold18White =
    TextStyle(color: whiteColor, fontSize: 18.0, fontWeight: FontWeight.w700);

const TextStyle bold16White =
    TextStyle(color: whiteColor, fontSize: 16.0, fontWeight: FontWeight.w700);

const TextStyle bold18WhiteF5 =
    TextStyle(color: whiteF5Color, fontSize: 18.0, fontWeight: FontWeight.w700);

const TextStyle bold16Grey =
    TextStyle(color: greyColor, fontSize: 16.0, fontWeight: FontWeight.w700);

const TextStyle semibold22Primary =
    TextStyle(color: primaryColor, fontSize: 22.0, fontWeight: FontWeight.w600);

const TextStyle semibold18Primary =
    TextStyle(color: primaryColor, fontSize: 18.0, fontWeight: FontWeight.w600);

const TextStyle semibold16Primary =
    TextStyle(color: primaryColor, fontSize: 16.0, fontWeight: FontWeight.w600);

const TextStyle semibold15Primary =
    TextStyle(color: primaryColor, fontSize: 15.0, fontWeight: FontWeight.w600);

const TextStyle semibold14Primary =
    TextStyle(color: primaryColor, fontSize: 14.0, fontWeight: FontWeight.w600);

const TextStyle semibold14Secondary = TextStyle(
    color: secondaryColor, fontSize: 14.0, fontWeight: FontWeight.w600);

const TextStyle semibold20WhiteF5 =
    TextStyle(color: whiteF5Color, fontSize: 20.0, fontWeight: FontWeight.w600);

const TextStyle semibold18WhiteF5 =
    TextStyle(color: whiteF5Color, fontSize: 18.0, fontWeight: FontWeight.w600);

const TextStyle semibold17WhiteF5 =
    TextStyle(color: whiteF5Color, fontSize: 17.0, fontWeight: FontWeight.w600);

const TextStyle semibold16WhiteF5 =
    TextStyle(color: whiteF5Color, fontSize: 16.0, fontWeight: FontWeight.w600);

const TextStyle semibold15WhiteF5 =
    TextStyle(color: whiteF5Color, fontSize: 15.0, fontWeight: FontWeight.w600);

const TextStyle semibold14WhiteF5 =
    TextStyle(color: whiteF5Color, fontSize: 14.0, fontWeight: FontWeight.w600);

const TextStyle semibold20White =
    TextStyle(color: whiteColor, fontSize: 20.0, fontWeight: FontWeight.w600);

const TextStyle semibold18White =
    TextStyle(color: whiteColor, fontSize: 18.0, fontWeight: FontWeight.w600);

const TextStyle semibold16White =
    TextStyle(color: whiteColor, fontSize: 16.0, fontWeight: FontWeight.w600);

const TextStyle semibold15White =
    TextStyle(color: whiteColor, fontSize: 15.0, fontWeight: FontWeight.w600);

const TextStyle semibold14White =
    TextStyle(color: whiteColor, fontSize: 14.0, fontWeight: FontWeight.w600);

const TextStyle semibold12White =
    TextStyle(color: whiteColor, fontSize: 12.0, fontWeight: FontWeight.w600);

TextStyle semibold14LightWhite = TextStyle(
    color: lightWhiteColor, fontSize: 14.0, fontWeight: FontWeight.w600);

const TextStyle semibold16Red =
    TextStyle(color: redColor, fontSize: 16.0, fontWeight: FontWeight.w600);

const TextStyle semibold14Red =
    TextStyle(color: redColor, fontSize: 14.0, fontWeight: FontWeight.w600);

const TextStyle semibold17Grey =
    TextStyle(color: greyColor, fontSize: 17.0, fontWeight: FontWeight.w600);

const TextStyle semibold16Grey =
    TextStyle(color: greyColor, fontSize: 16.0, fontWeight: FontWeight.w600);

const TextStyle semibold15Grey =
    TextStyle(color: greyColor, fontSize: 15.0, fontWeight: FontWeight.w600);

const TextStyle semibold14Grey =
    TextStyle(color: greyColor, fontSize: 14.0, fontWeight: FontWeight.w600);

const TextStyle semibold12Grey =
    TextStyle(color: greyColor, fontSize: 12.0, fontWeight: FontWeight.w600);

const TextStyle medium15Primary =
    TextStyle(color: primaryColor, fontSize: 15.0, fontWeight: FontWeight.w500);

const TextStyle medium18WhiteF5 =
    TextStyle(color: whiteF5Color, fontSize: 18.0, fontWeight: FontWeight.w500);

const TextStyle medium16WhiteF5 =
    TextStyle(color: whiteF5Color, fontSize: 16.0, fontWeight: FontWeight.w500);

const TextStyle medium14WhiteF5 =
    TextStyle(color: whiteF5Color, fontSize: 14.0, fontWeight: FontWeight.w500);

const TextStyle medium15White =
    TextStyle(color: whiteColor, fontSize: 15.0, fontWeight: FontWeight.w500);

const TextStyle medium15Grey =
    TextStyle(color: greyColor, fontSize: 15.0, fontWeight: FontWeight.w500);

const TextStyle medium14Grey =
    TextStyle(color: greyColor, fontSize: 14.0, fontWeight: FontWeight.w500);

const TextStyle regular30White = TextStyle(
    color: Color.fromRGBO(41, 36, 33, 1),
    fontSize: 30.0,
    fontWeight: FontWeight.w400);

const TextStyle regular16ScreenBg = TextStyle(
    color: screenBGColor, fontSize: 16.0, fontWeight: FontWeight.w400);
const TextStyle regular16Black = TextStyle(
    color: blackOrignalColor, fontSize: 16.0, fontWeight: FontWeight.w400);
const TextStyle regular12whiteF5 =
    TextStyle(color: whiteF5Color, fontSize: 16.0, fontWeight: FontWeight.w400);

const TextStyle regular14Black = TextStyle(
    color: blackOrignalColor, fontSize: 14.0, fontWeight: FontWeight.w400);

const TextStyle semibold22Black = TextStyle(
    color: blackOrignalColor, fontSize: 22.0, fontWeight: FontWeight.w600);

const TextStyle medium14Black = TextStyle(
    color: blackOrignalColor, fontSize: 14.0, fontWeight: FontWeight.w500);

const TextStyle semibold15black = TextStyle(
    color: blackOrignalColor, fontSize: 15.0, fontWeight: FontWeight.w600);

const TextStyle semibold12black = TextStyle(
    color: blackOrignalColor, fontSize: 12.0, fontWeight: FontWeight.w600);
const TextStyle semibold17Black = TextStyle(
    color: blackOrignalColor, fontSize: 17.0, fontWeight: FontWeight.w600);

const TextStyle semibold14Black = TextStyle(
    color: blackOrignalColor, fontSize: 14.0, fontWeight: FontWeight.w600);

const TextStyle bold22Black = TextStyle(
    color: blackOrignalColor, fontSize: 18.0, fontWeight: FontWeight.w700);

const TextStyle bold16Black = TextStyle(
    color: blackOrignalColor, fontSize: 16.0, fontWeight: FontWeight.w700);
