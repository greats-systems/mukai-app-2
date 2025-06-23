import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mukai/brick/models/group.model.dart';
import 'package:mukai/brick/models/profile.model.dart';
import 'package:mukai/brick/models/wallet.model.dart';
import 'package:mukai/src/apps/home/widgets/subs/pay_sub_trans_detail.dart';
import 'package:mukai/src/apps/transactions/controllers/transactions_controller.dart';
// import 'package:muc/apps/transactions/views/screens/transfers.dart';
import 'package:mukai/src/apps/transactions/views/screens/transfers.dart';
import 'package:mukai/src/controllers/auth.controller.dart';
import 'package:mukai/src/controllers/profile_controller.dart';
import 'package:mukai/src/controllers/wallet.controller.dart';
import 'package:mukai/theme/theme.dart';

class MemberPaySubs extends StatefulWidget {
  MemberPaySubs({super.key, required this.group});
  Group group;

  @override
  State<MemberPaySubs> createState() => _TransferTransactionScreenState();
}

class _TransferTransactionScreenState extends State<MemberPaySubs> {
  TransactionController get transactionController =>
      Get.put(TransactionController());
  final WalletController walletController = WalletController();
  AuthController get authController => Get.put(AuthController());
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
  List<Wallet>? sendingWallet = [];
  List<Wallet>? receivingWallet = [];
  List<Map<String, dynamic>>? profileWallets = [];
  Map<String, dynamic>? zigWallet = {};
  Map<String, dynamic>? usdWallet = {};
  bool _isLoading = false;
  Wallet? wallet;
  // Future? _fetchDataFuture;

  void fetchId() async {
    if (_isDisposed) return;

    setState(() {
      _isLoading = true;
      userId = _getStorage.read('userId');
      role = _getStorage.read('account_type');
    });
    final walletJsonData =
        await walletController.getWalletsByProfileID(widget.group.admin_id!);
    final userWalletJsonData =
        await walletController.getWalletsByProfileID(userId!);
    log(userWalletJsonData.toString());
    final userjson = await profileController.getUserDetails(userId!);
    final profileWallets = await profileController.getProfileWallets(userId!);
    await authController.getAcountCooperatives(userId!);

    if (_isDisposed) return;
    log('profileWallets: $profileWallets');
    setState(() {
      userProfile = userjson;
      if (walletJsonData != null) {
        for (var data in walletJsonData) {
          if (data.is_group_wallet!) {
            log('Group wallet id: ${data.id!}');
            receivingWallet = walletJsonData;
            widget.group.wallet_id = data.id;
            transactionController.selectedTransaction.value.receiving_wallet =
                data.id;
          }
          sendingWallet =
              userWalletJsonData;
        }
      }
      if (profileWallets != null && profileWallets.isNotEmpty) {
        try {
          zigWallet = profileWallets.firstWhere(
            (element) => element!['default_currency']?.toLowerCase() == 'zig',
            orElse: () => {'balance': '0.00', 'default_currency': 'ZIG'},
          );
          usdWallet = profileWallets.firstWhere(
            (element) => element!['default_currency']?.toLowerCase() == 'usd',
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
    super.initState();
    fetchId();
    log('MemberPaySubs group admin ID: ${widget.group.admin_id}');
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
          title: const SizedBox(
            child: Text(
              'Pay Cooperative Subscription',
              style: medium18WhiteF5,
            ),
          ),
        ),
        body: Container(
          color: whiteF5Color,
          child: Column(
            children: [
              receivingWallet!= null
                  ? Column(
                      children: [
                        heightBox(10),
                        transactionController.isLoading.value
                            ? Center(
                                child: Column(
                                children: [
                                  Text(
                                    'Processing payment...',
                                    style: semibold12black,
                                  ),
                                  heightBox(10),
                                  LinearProgressIndicator(
                                    minHeight: 2,
                                    color: primaryColor,
                                  ),
                                ],
                              ))
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    PaySubTransDetail(group: widget.group),
                                    heightBox(10),
                                    accountWallets(),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: primaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: () async {
                                          transactionController
                                                  .transferTransaction
                                                  .value
                                                  .amount =
                                              widget.group.monthly_sub ?? 0.0;
                                          transactionController
                                                  .transferTransaction
                                                  .value
                                                  .sending_wallet =
                                              sendingWallet![0].id;
                                          transactionController
                                                  .transferTransaction
                                                  .value
                                                  .receiving_wallet =
                                             receivingWallet![0].id;
                                          transactionController
                                              .transferTransaction
                                              .value
                                              .transferCategory = 'transfer';
                                          transactionController
                                              .transferTransaction
                                              .value
                                              .transferMode = 'WALLETPLUS';
                                          transactionController
                                              .transferTransaction
                                              .value
                                              .transactionType = 'subscription';
                                          await transactionController
                                              .initiateTransfer();
                                        },
                                        child: Text(
                                          'Pay Subscription',
                                          style: semibold12White,
                                        )),
                                  ],
                                ),
                              )
                      ],
                    )
                  : SizedBox(
                      child: Center(
                        child: Text(
                          'No  Cooperative wallet found',
                          style: semibold12black,
                        ),
                      ),
                    ),
            ],
          ),
        ));
  }

  accountWallets() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Select Wallet',
            style: semibold12black,
          ),
          heightBox(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: zigWallet?['default_currency'] == 'ZIG'
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
                    transactionController
                            .transferTransaction.value.sending_wallet =
                        walletController.selectedWallet.value.id;
                    transactionController.transferTransaction.refresh();
                  });
                },
                child: Column(
                  children: [
                    Text(
                      'ZIG Wallet',
                      style: semibold12White,
                    ),
                    Text(
                      'Current Balance:',
                      style: semibold12White,
                    ),
                    Text(
                      ' ${zigWallet?['balance']} ZIG',
                      style: semibold12White,
                    ),
                  ],
                ),
              ),
              widthBox(10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: tertiaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    walletController.selectedWallet.value =
                        Wallet.fromJson(usdWallet!);
                    transactionController
                            .transferTransaction.value.sending_wallet =
                        walletController.selectedWallet.value.id;
                    transactionController.transferTransaction.refresh();
                  });
                },
                child: Column(
                  children: [
                    Text(
                      'USD Wallet ',
                      style: semibold12black,
                    ),
                    Text(
                      'Current Balance',
                      style: semibold12black,
                    ),
                    Text(
                      '${usdWallet?['balance']} USD',
                      style: semibold12black,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget divider() {
    return Container(
      width: double.maxFinite,
      height: 1.0,
      color: blackOrignalColor.withOpacity(0.1),
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
