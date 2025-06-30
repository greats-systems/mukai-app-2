import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:mukai/brick/models/profile.model.dart';
import 'package:mukai/brick/models/wallet.model.dart';
import 'package:mukai/core/config/dio_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mukai/src/apps/home/qr_code.dart';
import 'package:mukai/src/apps/home/wallet_balances.dart';
import 'package:mukai/src/apps/home/widgets/apps_features.dart';
import 'package:mukai/src/apps/home/widgets/transact_features.dart';
import 'package:mukai/src/controllers/auth.controller.dart';
import 'package:mukai/src/apps/home/admin/admin_recent_transactions.dart';
import 'package:mukai/src/apps/home/widgets/admin_app_header.dart';
import 'package:mukai/src/apps/transactions/controllers/transactions_controller.dart';
import 'package:mukai/src/apps/transactions/views/screens/transfers.dart';
import 'package:mukai/src/controllers/profile_controller.dart';
import 'package:mukai/src/controllers/wallet.controller.dart';
import 'package:mukai/theme/theme.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AdminLandingScreen extends StatefulWidget {
  const AdminLandingScreen({super.key});
  static const routeName = '/home';
  @override
  State<AdminLandingScreen> createState() => _AdminLandingScreenState();
}

class _AdminLandingScreenState extends State<AdminLandingScreen> {
  final WalletController _walletController = WalletController();

  AuthController get authController => Get.put(AuthController());
  final ProfileController _profileController = ProfileController();
  TransactionController get transactionController =>
      Get.put(TransactionController());
  late PageController pageController = PageController();
  final GetStorage _getStorage = GetStorage();
  final tabList = ["Portfolio", "Transact", "Transactions"];
  int selectedTab = 0;
  bool refresh = false;
  late double height;
  late double width;
  String? walletId;
  String? userId;
  List<Wallet>? wallets;
  Dio dio = Dio();
  bool _isDisposed = false;
  bool _isLoading = false;
  Future<void> fetchWalletID() async {
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
    final walletJson = await _profileController.getProfileWallet(userId!);
    if (mounted) {
      if (walletJson!=null) {
  setState(() {
    walletId = walletJson![0]['id'];
  });
}
    }
    log('fetchWalletID walletId: $walletId');
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    pageController = PageController(initialPage: selectedTab);
    userId = _getStorage.read('userId');
    log('AdminLandingScreen userId: $userId');
    fetchWalletID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;
    return Scaffold(
      backgroundColor: whiteF5Color,
      // appBar: MukaiAdminLandingAppBar(),
      appBar: buildAppBar(),
      body: Container(
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                whiteColor,
                whiteF5Color,
              ],
            ),
            // borderRadius: BorderRadius.only(
            //   topLeft: Radius.circular(40),
            //   topRight: Radius.circular(40),
            // ),
          ),
          child: ListView(
            children: [
              Obx(() => authController.initiateNewTransaction.value == true
                  ? memberInitiateTrans()
                  : adminOptions())
            ],
          )),
    );
  }

  memberInitiateTrans() {
    return Row(
      children: [
        Column(
          children: [
            heightBox(20),
            Text('Scan QR-Code to Pay', style: bold16Black),
            Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              child: Center(
                child: Column(
                  children: [
                    QrImageView(
                      data: wallets?.first.id ?? 'No wallet ID 3',
                      version: QrVersions.auto,
                      size: 160.0,
                    ),
                    Text('${userId?.substring(24, 36)}')
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          width: width * 0.45,
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

  PreferredSizeWidget buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(105.0), // Match the toolbarHeight
      child: Container(
        // decoration: BoxDecoration(
        //   boxShadow: [
        //     BoxShadow(
        //       color: Colors.black.withOpacity(0.2), // Shadow color
        //       blurRadius: 8.0, // Blur radius
        //       spreadRadius: 2.0, // Spread radius
        //       offset: const Offset(0, 4), // Shadow position (bottom)
        //     ),
        //   ],
        // ),
        child: AppBar(
          backgroundColor: whiteColor,
          automaticallyImplyLeading: false,
          centerTitle: false,
          titleSpacing: 0.0,
          toolbarHeight: 120.0,
          elevation: 0,
          title: const AdminAppHeaderWidget(),
        ),
      ),
    );
  }

  adminInitiateTrans() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          alignment: Alignment.center,
          child: Center(
            child: QrImageView(
              data: walletId ?? 'No wallet ID 1',
              version: QrVersions.auto,
              size: 250.0,
            ),
          ),
        ),
        Text('Scan to pay', style: bold16Black),
        heightBox(20),
        Container(
            alignment: Alignment(0, 0),
            height: height * 0.07,
            width: width * 0.6,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 5,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/icons/mingcute_nfc-fill.png",
                    height: 40,
                    color: whiteF5Color,
                  ),
                ),
                Text(
                  'Use NFC',
                  style: bold16White,
                ),
              ],
            )),
        heightBox(20),
        GestureDetector(
          onTap: () {
            transactionController.selectedTransferOption.value = 'wallet';
            transactionController.selectedTransferOption.refresh();
            Get.to(() => TransfersScreen(
                  category: 'wallet',
                ));
          },
          child: Container(
              alignment: Alignment(0, 0),
              height: height * 0.07,
              width: width * 0.6,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: whiteF5Color,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 5,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Image.asset(
                      "assets/icons/mingcute_transfer-horizontal-line.png",
                      height: 40,
                      color: whiteF5Color,
                    ),
                  ),
                  Text(
                    'Sent to Member',
                    style: bold16White,
                  ),
                ],
              )),
        )
      ],
    );
  }

  adminOptions() {
    return Column(
      children: [
        WalletBalancesWidget(),
        heightBox(20),
        tabBar(),
        tabPreviews()
      ],
    );
  }

  tabPreviews() {
    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: pageController,
                onPageChanged: (index) {
                  if (mounted) {
                    setState(() {
                      refresh = true;
                      selectedTab = index;
                    });
                    setState(() {
                      refresh = false;
                    });
                  }
                },
                children: [
                  Container(
                      color: whiteF5Color,
                      child: const HomeAccountWidgetApps(
                        category: 'portfolioList',
                      )),
                  Container(
                      color: whiteF5Color,
                      child: const HomeAccountWidgetApps(
                        category: 'transactList',
                      )),
                  Container(
                      color: whiteF5Color,
                      child: const AdminRecentTransactionsWidget(
                        category: 'monthly',
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  tabBar() {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      child: Row(
        children: List.generate(
          tabList.length,
          (index) {
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedTab = index;
                  });
                  pageController.jumpToPage(selectedTab);
                },
                child: Container(
                  margin: EdgeInsets.all(
                    fixPadding * 0.5,
                  ),
                  padding: const EdgeInsets.all(fixPadding * 1.3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      color: selectedTab == index
                          ? primaryColor
                          : Colors.transparent),
                  child: Text(
                    tabList[index].toString(),
                    style: selectedTab == index
                        ? semibold12White
                        : semibold12White,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
