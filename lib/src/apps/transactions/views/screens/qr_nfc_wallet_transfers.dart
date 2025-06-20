import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/eva.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/icons/ri.dart';
import 'package:mukai/src/controllers/auth.controller.dart';
import 'package:mukai/src/apps/transactions/controllers/transactions_controller.dart';
import 'package:mukai/src/apps/transactions/views/widgets/transfer_to_wallet.dart';
import 'package:mukai/src/controllers/wallet.controller.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/utils/utils.dart';

class QrNfcWalletTransferScreen extends StatelessWidget {
  final String wallet_id;
  QrNfcWalletTransferScreen({super.key, required this.wallet_id});
  AuthController get authController => Get.put(AuthController());
  TransactionController get transactionController =>
      Get.put(TransactionController());
  final WalletController walletController = WalletController();

  final TextEditingController amountController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final province_field_key = GlobalKey<DropdownSearchState>();
  final agritex_officer_key = GlobalKey<DropdownSearchState>();
  final district_key = GlobalKey<DropdownSearchState>();
  final town_city_key = GlobalKey<DropdownSearchState>();
  late double height;
  late double width;
  final dropDownKey = GlobalKey<DropdownSearchState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20.0), // Adjust the radius as needed
          ),
        ),
        elevation: 0,
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: whiteF5Color,
          ),
        ),
        centerTitle: false,
        titleSpacing: 20.0,
        toolbarHeight: 70.0,
        title: Obx(() => Text(
              'Transfer to ${Utils.trimp(transactionController.selectedProfile.value.last_name!)}',
              style: medium18WhiteF5,
            )),
      ),
      body: Column(
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
                  sendToMobileWallet(),
                  height20Space,
                  registerContent(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  sendToMobileWallet() {
    return Column(
      children: [
        heightSpace,
        Obx(() => transactionController.selectedProfile.value.id != null
            ? detailsField()
            : SizedBox()),
        heightSpace,
        amountField(),
        heightSpace,
      ],
    );
  }

  detailsField() {
    return Card(
      color: primaryColor.withAlpha(100),
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recieving Account',
              style: TextStyle(
                  color: blackOrignalColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Email:\t',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${transactionController.selectedProfile.value.email}',
                  // style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'First Name:\t',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${transactionController.selectedProfile.value.first_name}',
                  // style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Last Name:\t',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${transactionController.selectedProfile.value.last_name}',
                  // style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Wallet ID:\t',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "${wallet_id.substring(0, 8)}...${wallet_id.substring(28, 36)}",
                  // style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  goBackButton() {
    return GestureDetector(
      onTap: () {
        Get.back();
        // transactionController.selectedProfile.value.email = '';
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
        transactionController.accountNumber.value = '';
        // transactionController.
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

  town_cityField() {
    return Container(
      width: double.maxFinite,
      clipBehavior: Clip.hardEdge,
      decoration: bgBoxDecoration,
      child: Container(
        decoration: BoxDecoration(
          color: recWhiteColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Obx(() => DropdownSearch<String>(
              onChanged: (value) => {
                authController.town_city.value = value!,
              },
              key: town_city_key,
              selectedItem: authController.town_city.value,
              items: (filter, infiniteScrollProps) =>
                  authController.selected_province_town_city_options,
              decoratorProps: DropDownDecoratorProps(
                decoration: InputDecoration(
                  border: InputBorder.none,

                  labelText: 'Select Town/City',
                  labelStyle: const TextStyle(
                      color: blackOrignalColor,
                      fontSize: 22), // Black label text
                  // border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: recWhiteColor, // White background for input field
                ),
                baseStyle: const TextStyle(
                    color: blackOrignalColor,
                    fontSize: 18), // Black text for selected item
              ),
              popupProps: PopupProps.menu(
                itemBuilder: (context, item, isDisabled, isSelected) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(item,
                      style: const TextStyle(
                          color: blackOrignalColor, fontSize: 18)),
                ),
                fit: FlexFit.loose,
                constraints: const BoxConstraints(),
                menuProps: const MenuProps(
                  backgroundColor: whiteF5Color,
                  elevation: 4,
                ),
              ),
            )),
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
          hintText: "${wallet_id}",
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
