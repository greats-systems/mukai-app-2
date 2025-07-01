import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/eva.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/icons/ri.dart';
import 'package:mukai/brick/models/profile.model.dart';
import 'package:mukai/brick/models/wallet.model.dart';
import 'package:mukai/src/apps/home/qr_code.dart';
import 'package:mukai/src/controllers/auth.controller.dart';
import 'package:mukai/src/apps/transactions/controllers/transactions_controller.dart';
import 'package:mukai/src/apps/transactions/views/widgets/transfer_to_wallet.dart';
import 'package:mukai/src/controllers/wallet.controller.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/utils/utils.dart';
import 'dart:developer';

import 'package:qr_flutter/qr_flutter.dart';

class TransfersScreen extends StatefulWidget {
  final String category;
  TransfersScreen({super.key, required this.category});

  @override
  State<TransfersScreen> createState() => _TransfersScreenState();
}

class _TransfersScreenState extends State<TransfersScreen> {
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

  final WalletController _walletController = WalletController();

  final GetStorage _getStorage = GetStorage();

  late double height;

  late double width;

  final dropDownKey = GlobalKey<DropdownSearchState>();

  String? userId;
  List<Wallet>? wallets;
  String? walletId;
  bool _isDisposed = false;
  bool _isLoading = false;

  void fetchProfile() async {
    if (_isDisposed) return;

    setState(() {
      _isLoading = true;
      userId = _getStorage.read('userId');
    });

    try {
      final walletJson = await _walletController.getIndividualWallets(userId!);

      if (!_isDisposed && mounted) {
        setState(() {
          wallets = walletJson;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!_isDisposed && mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    setState(() => userId = _getStorage.read('userId'));
    log(userId!);
    super.initState();
    fetchProfile();
  }

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
        title: Obx(
            () => transactionController.selectedTransferOption.value.isNotEmpty
                ? Text(
                    Utils.trimp(
                        '${Utils.trimp(transactionController.selectedTransferOption.value)} Transfer'),
                    style: medium18WhiteF5,
                  )
                : Text(
                    Utils.trimp('${Utils.trimp(widget.category)} Transfer'),
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
                  // if (transactionController.selectedTransferOptionCategory.value ==
                  //     'mobile_money')
                  //   sendToMobileWallet(),
                  // Text(
                  //     '${transactionController.selectedTransferOption.value}'),
                  Obx(() =>
                      transactionController.selectedTransferOption.value ==
                              'manual_wallet'
                          ? ManualTransferToWalletWidget()
                          : widget.category == 'internal'
                              ? sendToWalletPlus()
                              : widget.category == 'zipit'
                                  ? sendToWalletPlus()
                                  : widget.category == 'pos_payment'
                                      ? posPayment()
                                      : widget.category == 'cashout'
                                          ? sendToAgentWallet()
                                          : widget.category == 'cashin'
                                              ? memberInitiateTrans()
                                              : widget.category == 'zipit'
                                                  ? memberInitiateTrans()
                                                  : sendToMobileWallet()),

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
        numberField(),
        heightSpace,
        amountField(),
        heightSpace,
      ],
    );
  }

  memberInitiateTrans() {
    return Row(
      children: [
        Column(
          children: [
            Text('Scan QR-Code to Pay', style: bold16Black),
            heightBox(height * 0.02),
            Column(
              children: [
                QrImageView(
                  data: wallets?.first.id ?? 'No wallet ID 3',
                  version: QrVersions.auto,
                  size: 140.0,
                ),
                Text('${userId?.substring(24, 36)}')
              ],
            ),
          ],
        ),
        SizedBox(
          width: width * 0.43,
          child: Column(
            children: [
              heightBox(height * 0.08),
              GestureDetector(
                onTap: () {
                  transactionController.selectedTransferOption.value = 'wallet';
                  transactionController.selectedTransferOption.refresh();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const QRViewExample(),
                  ));
                  // Get.to(() => TransfersScreen(
                  //       category: 'wallet',
                  //     ));
                },
                child: Container(
                    alignment: Alignment(0, 0),
                    height: height * 0.05,
                    width: width * 0.9,
                    // padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: tertiaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 5,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: Image.asset(
                            "assets/icons/mage_qr-code-fill.png",
                            height: 40,
                            color: whiteF5Color,
                          ),
                        ),
                        Text(
                          'Scan QR Code',
                          style: bold16White,
                        ),
                      ],
                    )),
              ),
              heightBox(20),
              Container(
                  alignment: Alignment(0, 0),
                  height: height * 0.05,
                  width: width * 0.9,
                  // padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 5,
                    children: [
                      Text(
                        "Use NFC Tap n' Pay",
                        style: bold16White,
                      ),
                    ],
                  )),
              heightBox(20),
              GestureDetector(
                onTap: () {
                  transactionController.selectedTransferOption.value =
                      'manual_wallet';
                  transactionController.selectedTransferOption.refresh();
                  transactionController.selectedProfile.value = Profile();
                  Get.to(() => TransfersScreen(
                        category: 'Direct Wallet',
                      ));
                },
                child: Container(
                    alignment: Alignment(0, 0),
                    height: height * 0.05,
                    width: width * 0.9,
                    // padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: tertiaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 5,
                      children: [
                        Text(
                          'Add Wallet Address',
                          style: bold16White,
                        ),
                      ],
                    )),
              ),
            ],
          ),
        )
      ],
    );
  }

  posPayment() {
    return Column(
      children: [
        Row(
          children: [
            Text('Enter Merchant Number', style: bold16Black),
          ],
        ),
        heightSpace,
        merchantNumberField(),
        heightSpace,
        Row(
          children: [
            Column(
              children: [
                Text('Scan QR-Code to Pay', style: bold16Black),
                heightBox(height * 0.02),
                Column(
                  children: [
                    QrImageView(
                      data: wallets?.first.id ?? 'No wallet ID 3',
                      version: QrVersions.auto,
                      size: 140.0,
                    ),
                    Text('${userId?.substring(24, 36)}')
                  ],
                ),
              ],
            ),
            SizedBox(
              width: width * 0.43,
              child: Column(
                children: [
                  heightBox(height * 0.08),
                  GestureDetector(
                    onTap: () {
                      transactionController.selectedTransferOption.value =
                          'wallet';
                      transactionController.selectedTransferOption.refresh();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const QRViewExample(),
                      ));
                      // Get.to(() => TransfersScreen(
                      //       category: 'wallet',
                      //     ));
                    },
                    child: Container(
                        alignment: Alignment(0, 0),
                        height: height * 0.05,
                        width: width * 0.9,
                        // padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: tertiaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 5,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: Image.asset(
                                "assets/icons/mage_qr-code-fill.png",
                                height: 40,
                                color: whiteF5Color,
                              ),
                            ),
                            Text(
                              'Scan QR Code',
                              style: bold16White,
                            ),
                          ],
                        )),
                  ),
                  heightBox(20),
                  Container(
                      alignment: Alignment(0, 0),
                      height: height * 0.05,
                      width: width * 0.9,
                      // padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 5,
                        children: [
                          Text(
                            "Use NFC Tap n' Pay",
                            style: bold16White,
                          ),
                        ],
                      )),
                  heightBox(20),
                  GestureDetector(
                    onTap: () {
                      transactionController.selectedTransferOption.value =
                          'manual_wallet';
                      transactionController.selectedTransferOption.refresh();
                      transactionController.selectedProfile.value = Profile();
                      Get.to(() => TransfersScreen(
                            category: 'Direct Wallet',
                          ));
                    },
                    child: Container(
                        alignment: Alignment(0, 0),
                        height: height * 0.05,
                        width: width * 0.9,
                        // padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: tertiaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 5,
                          children: [
                            Text(
                              'Add Wallet Address',
                              style: bold16White,
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  sendToAgentWallet() {
    return Column(
      children: [
        heightSpace,
        agentNumberField(),
        heightSpace,
        amountField(),
        heightSpace,
      ],
    );
  }

  sendToWalletPlus() {
    return Column(
      children: [
        heightSpace,
        accountNumberField(),
        heightSpace,
        amountField(),
        heightSpace,
      ],
    );
  }

  sendToSelectedWallet() {
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
                // Text(
                //   "${wallet_id.substring(0, 8)}...${wallet_id.substring(28, 36)}",
                //   // style: TextStyle(fontWeight: FontWeight.bold),
                // ),
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

  initiateTransfer() {
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
                  initiateTransfer(),
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

  agentNumberField() {
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
          hintText: "Agent Number",
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

  merchantNumberField() {
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
          hintText: "Merchant Account",
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

  accountNumberField() {
    return Container(
      decoration: BoxDecoration(
        color: recWhiteColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextField(
        onChanged: (value) async {
          transactionController.transferTransaction.value.receiving_wallet =
              value;
          final json = await _walletController.getWalletLikeID(userId!);
          log(json.toString());
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
          hintText: "Account number",
          hintStyle: medium15Grey,
          prefixIconConstraints: BoxConstraints(maxWidth: 45.0),
          prefixIcon: Center(
            child: Icon(
              Icons.wallet,
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
