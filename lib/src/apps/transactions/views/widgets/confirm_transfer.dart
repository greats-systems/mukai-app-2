import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/eva.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/icons/ri.dart';
import 'package:mukai/src/controllers/auth.controller.dart';
import 'package:mukai/src/apps/transactions/controllers/transactions_controller.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/utils/utils.dart';

class ConfirmTransferWidget extends StatelessWidget {
  ConfirmTransferWidget({super.key});
  AuthController get authController => Get.put(AuthController());
  TransactionController get transactionController =>
      Get.put(TransactionController());
  final TextEditingController amountController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  late double height;
  late double width;
  final dropDownKey = GlobalKey<DropdownSearchState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;
    return Column(
      children: [
        Expanded(
          child: Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: whiteF5Color,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(0.0),
              ),
              border: Border.all(
                color: whiteF5Color,
              ),
              boxShadow: boxShadow,
            ),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(fixPadding * 2.0),
              children: [
                height20Space,
                Text(
                  'Name',
                  style: semibold12black,
                ),
                height5Space,
                Text(
                  'Innocent',
                  style: semibold12black,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  sendToMobileWallet() {
    return Column(
      children: [
        numberField(),
        heightSpace,
        amountField(),
        heightSpace,
      ],
    );
  }

  cooperative_category() {
    return Container(
      width: double.maxFinite,
      clipBehavior: Clip.hardEdge,
      decoration: bgBoxDecoration,
      child: Obx(() => DropdownSearch<String>(
            onChanged: (value) => {
              authController.cooperative_category.value = value!,
            },
            key: dropDownKey,
            selectedItem:
                Utils.trimp(authController.cooperative_category.value),
            items: (filter, infiniteScrollProps) =>
                authController.cooperative_category_options,
            decoratorProps: DropDownDecoratorProps(
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: primaryColor), // Border color when focused
                  borderRadius: BorderRadius.circular(10.0),
                ),

                labelText: 'Select Cooperative Category',
                labelStyle: const TextStyle(
                    height: 10,
                    color: blackColor,
                    fontSize: 22), // Black label text
                // border: const OutlineInputBorder(),
                filled: true,
                fillColor: recWhiteColor, // White background for input field
              ),
              baseStyle: const TextStyle(
                  color: blackColor,
                  fontSize: 18), // Black text for selected item
            ),
            popupProps: PopupProps.menu(
              itemBuilder: (context, item, isDisabled, isSelected) => Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(Utils.trimp(item),
                    style: const TextStyle(color: blackColor, fontSize: 18)),
              ),
              fit: FlexFit.loose,
              constraints: const BoxConstraints(),
              menuProps: const MenuProps(
                backgroundColor: whiteF5Color,
                elevation: 4,
              ),
            ),
          )),
    );
  }

  goBackButton() {
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: Container(
        width: width * 0.3,
        height: height * 0.05,
        decoration: BoxDecoration(
          color: greyColor,
          borderRadius: BorderRadius.circular(10.0),
          // boxShadow: buttonShadow,
        ),
        alignment: Alignment.center,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Iconify(
              Eva.chevron_left_outline,
              color: whiteF5Color,
            ),
            Text(
              "Previous",
              style: bold18WhiteF5,
            ),
          ],
        ),
      ),
    );
  }

  registerButton() {
    return GestureDetector(
      onTap: () async {
        await transactionController.initiateTransfer();
      },
      child: Container(
        width: width * 0.3,
        height: height * 0.05,
        decoration: BoxDecoration(
          color: authController.farm_name.isNotEmpty ? greyColor : primaryColor,
          borderRadius: BorderRadius.circular(10.0),
          // boxShadow: buttonShadow,
        ),
        alignment: Alignment.center,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Next",
              style: bold18WhiteF5,
            ),
            Iconify(
              Eva.chevron_right_outline,
              color: whiteF5Color,
            )
          ],
        ),
      ),
    );
  }

  registerContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Obx(() => transactionController.isLoading.value == true
            ? Column(
                children: [
                  SizedBox(
                      width: width * 0.6,
                      child: const LinearProgressIndicator(
                        color: primaryColor,
                      )),
                  Text(
                    "please wait ...",
                    style: semibold14LightWhite,
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  goBackButton(),
                  registerButton(),
                ],
              )),
      ],
    );
  }

  numberField() {
    return Container(
      decoration: BoxDecoration(
        color: recWhiteColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextField(
        onChanged: (value) => {
          transactionController.transferTransaction.value.receiving_phone =
              value,
        },
        style: medium14Black,
        cursorColor: primaryColor,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: greyB5Color), // Border color when not focused
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: primaryColor), // Border color when focused
            borderRadius: BorderRadius.circular(10.0),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: fixPadding * 1.5),
          hintText: "Phone Number",
          hintStyle: medium15Grey,
          prefixIconConstraints: BoxConstraints(maxWidth: 45.0),
          prefixIcon: Center(
            child: Icon(
              Icons.phone_android_outlined,
              color: primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  amountField() {
    return Container(
      decoration: BoxDecoration(
        color: recWhiteColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextField(
        onChanged: (value) => {
          transactionController.transferTransaction.value.amount =
              double.parse(value),
        },
        style: medium14Black,
        cursorColor: primaryColor,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: greyB5Color), // Border color when not focused
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: primaryColor), // Border color when focused
            borderRadius: BorderRadius.circular(10.0),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: fixPadding * 1.5),
          hintText: "Amount",
          hintStyle: medium15Grey,
          prefixIconConstraints: BoxConstraints(maxWidth: 45.0),
          prefixIcon: Center(
            child: Iconify(
              Ri.money_dollar_box_line,
              color: primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  appLogo() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/images/logo-nobg.png", height: 150.0),
          Text(
            'express your greatness',
            style:
                TextStyle(fontStyle: FontStyle.italic, color: secondaryColor),
          )
        ],
      ),
    );
  }

  BoxDecoration bgBoxDecoration = BoxDecoration(
    border: Border(
        left: BorderSide(color: greyB5Color),
        right: BorderSide(color: greyB5Color),
        bottom: BorderSide(color: greyB5Color),
        top: BorderSide(color: greyB5Color)),
    color: whiteF5Color,
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: recShadow,
  );
}
