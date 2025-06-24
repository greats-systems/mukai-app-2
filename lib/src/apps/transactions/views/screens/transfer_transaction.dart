import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mukai/brick/models/group.model.dart';
import 'package:mukai/brick/models/profile.model.dart';
import 'package:mukai/brick/models/wallet.model.dart';
import 'package:mukai/src/apps/transactions/controllers/transactions_controller.dart';
import 'package:mukai/src/apps/transactions/views/screens/transfers.dart';
import 'package:mukai/src/controllers/profile_controller.dart';
import 'package:mukai/src/controllers/wallet.controller.dart';
import 'package:mukai/theme/theme.dart';

class TransferTransactionScreen extends StatefulWidget {
  final String? purpose;
  final Group? group;
  final String? receivingWalletId;
  const TransferTransactionScreen(
      {super.key, this.purpose, this.receivingWalletId, 
      this.group
      });

  @override
  State<TransferTransactionScreen> createState() =>
      _TransferTransactionScreenState();
}

class _TransferTransactionScreenState extends State<TransferTransactionScreen> {
  TransactionController get transactionController =>
      Get.put(TransactionController());
  final WalletController walletController = WalletController();

  ProfileController get profileController => Get.put(ProfileController());

  late double height;
  late double width;

  final activeList = [
    {
      "image": "assets/addAccount/account-16.png",
      "option": 'wallet',
      "category": 'internal',
      "title": "Internal Wallet"
    },
    {
      "image": "assets/addAccount/account-16.png",
      "option": 'ecocash',
      "category": 'mobile_money',
      "title": "Ecocash"
    },
    {
      "image": "assets/addAccount/account-16.png",
      "option": 'innbucks',
      "category": 'money_wallet',
      "title": "InnBucks"
    },
    {
      "image": "assets/addAccount/account-16.png",
      "option": 'Omari',
      "category": 'money_wallet',
      "title": "O'Mari"
    },
    {
      "image": "assets/addAccount/account-16.png",
      "option": 'one_money',
      "category": 'mobile_money',
      "title": "One Money"
    },
    {
      "image": "assets/addAccount/account-16.png",
      "option": 'bank',
      "category": 'zipit',
      "title": "Bank Account"
    },
  ];
  final GetStorage _getStorage = GetStorage();
  var profile = Profile(full_name: '', id: '');
  int selectedTab = 0;
  String? userId;
  String? role;
  Map<String, dynamic>? userProfile = {};
  Map<String, dynamic>? walletProfile = {};
  List<Map<String, dynamic>>? profileWallets = [];
  Map<String, dynamic>? zigWallet = {};
  Map<String, dynamic>? usdWallet = {};
  bool _isLoading = false;
  Wallet? wallet;
  Future? _fetchDataFuture;

  void fetchId() async {
    if (_isDisposed) return;

    setState(() {
      _isLoading = true;
      userId = _getStorage.read('userId');
      role = _getStorage.read('account_type');
    });

    final userjson = await profileController.getUserDetails(userId!);
    // final walletJson = await profileController.getWalletDetails(userId!);
    final profileWallets = await profileController.getProfileWallet(userId!);

    if (_isDisposed) return;
    log('profileWallets: $profileWallets');
    setState(() {
      userProfile = userjson;
      if (profileWallets != null && profileWallets.isNotEmpty) {
        try {
          zigWallet = profileWallets.firstWhere(
            (element) => element['default_currency']?.toLowerCase() == 'zig',
            orElse: () => {'balance': '0.00', 'default_currency': 'ZIG'},
          );
          usdWallet = profileWallets.firstWhere(
            (element) => element['default_currency']?.toLowerCase() == 'usd',
            orElse: () => {'balance': '0.00', 'default_currency': 'USD'},
          );
          log('zigWallet: $zigWallet');
          log('usdWallet: $usdWallet');
        } catch (e) {
          log('Error finding wallets: $e');
          zigWallet = {'balance': '0.00', 'default_currency': 'ZIG'};
          usdWallet = {'balance': '0.00', 'default_currency': 'USD'};
        }
      } else {
        zigWallet = {'balance': '0.00', 'default_currency': 'ZIG'};
        usdWallet = {'balance': '0.00', 'default_currency': 'USD'};
      }
      _isLoading = false;
    });
  }

  @override
  void initState() {
    log('TransferTransactionScreen group ID: ${widget.group?.id ?? 'No ID'}');
    super.initState();
    fetchId();
  }

  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
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
          title: SizedBox(
            child: Text(
              widget.group != null
                  ? 'Pay Subscription'
                  : 'Transfer Transaction',
              style: medium18WhiteF5,
            ),
          ),
        ),
        body: Container(
          color: whiteF5Color,
          child: Column(
            children: [
              heightBox(30),
              Obx(() => walletController.selectedWallet.value.id != null
                  ? SizedBox(
                      height: height * 0.5,
                      child: GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(
                            left: fixPadding * 2.0,
                            right: fixPadding * 2.0,
                            bottom: fixPadding * 2.0,
                          ),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: fixPadding * 2.0,
                                  crossAxisSpacing: fixPadding * 2.0,
                                  childAspectRatio: 1.5),
                          itemCount: activeList.length,
                          itemBuilder: (context, index) {
                            return listTileWidget(
                                activeList[index]['category'].toString(),
                                activeList[index]['option'].toString(),
                                activeList[index]['title'].toString(),
                                () {});
                          }),
                    )
                  : Center(
                      child: Column(
                      children: [
                        Text(
                          'No wallet selected',
                          style: semibold12black,
                        ),
                        Text(
                          'Please select a wallet first',
                          style: semibold12black,
                        ),
                        heightBox(10),

                        // generete a FutureBuilder to fetch the wallet details
                        //  generate a button to select a wallet between usd and zig
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    zigWallet?['default_currency'] == 'zig'
                                        ? primaryColor
                                        : tertiaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  walletController.selectedWallet.value =
                                      Wallet.fromJson(zigWallet!);
                                  transactionController.transferTransaction
                                          .value.sending_wallet =
                                      walletController.selectedWallet.value.id;
                                  transactionController.transferTransaction
                                      .refresh();
                                });
                              },
                              child: Column(
                                children: [
                                  Text(
                                    'Select ZIG Wallet',
                                    style: semibold12White,
                                  ),
                                  Text(
                                    '${zigWallet?['balance']} ZIG',
                                    style: semibold12White,
                                  ),
                                ],
                              ),
                            ),
                            widthBox(10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    usdWallet?['default_currency'] == 'usd'
                                        ? primaryColor
                                        : tertiaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  walletController.selectedWallet.value =
                                      Wallet.fromJson(usdWallet!);
                                  transactionController.transferTransaction
                                          .value.sending_wallet =
                                      walletController.selectedWallet.value.id;
                                  transactionController.transferTransaction
                                      .refresh();
                                });
                              },
                              child: Column(
                                children: [
                                  Text(
                                    'Select USD Wallet ',
                                    style: semibold12White,
                                  ),
                                  Text(
                                    '${usdWallet?['balance']} USD',
                                    style: semibold12White,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ))),
            ],
          ),
        ));
  }

  Widget divider() {
    return Container(
      width: double.maxFinite,
      height: 1.0,
      color: blackOrignalColor.withOpacity(0.1),
    );
  }

  listTileWidget(String category, String option, String title, Function() onTap,
      {Color color = blackOrignalColor}) {
    return InkWell(
      onTap: () {
        transactionController.selectedTransferOption.value = option;
        transactionController.selectedTransferOptionCategory.value = category;
        transactionController.selectedTransferOption.refresh();
        transactionController.transferTransaction.value.transferCategory =
            category;
        transactionController.transferTransaction.value.transferMode = option;
        log('${transactionController.selectedTransferOptionCategory.value}');
        Get.to(() => TransfersScreen(
              category: category,
            ));
      },
      child: Container(
        width: double.maxFinite,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: recShadow,
        ),
        child: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(fixPadding),
          decoration: BoxDecoration(
            color: recWhiteColor,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: blackOrignalColor.withOpacity(0.3)),
          ),
          alignment: Alignment.center,
          child: Center(
            child: SizedBox(
              width: width,
              child: AutoSizeText(
                  maxLines: 2,
                  title,
                  style: medium14Black,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center),
            ),
          ),
        ),
      ),
    );
  }
}
