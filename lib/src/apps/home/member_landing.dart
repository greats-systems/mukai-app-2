import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mukai/brick/models/profile.model.dart';
import 'package:mukai/brick/models/wallet.model.dart';
import 'package:mukai/src/apps/home/qr_code.dart';
import 'package:mukai/src/apps/home/wallet_balances.dart';
import 'package:mukai/src/apps/home/widgets/app_header.dart';
import 'package:mukai/src/apps/home/widgets/apps_features.dart';
import 'package:mukai/src/apps/transactions/controllers/transactions_controller.dart';
import 'package:mukai/src/apps/transactions/views/screens/transfers.dart';
import 'package:mukai/src/controllers/auth.controller.dart';
import 'package:mukai/src/controllers/wallet.controller.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/widget/loading_shimmer.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:io';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class MemberLandingScreen extends StatefulWidget {
  const MemberLandingScreen({super.key, this.userId});
  final String? userId;
  static const routeName = '/home';

  @override
  State<MemberLandingScreen> createState() => _MemberLandingScreenState();
}

class _MemberLandingScreenState extends State<MemberLandingScreen> {
  late PageController pageController = PageController();
  AuthController get authController => Get.put(AuthController());
  final WalletController _walletController = WalletController();
  final GetStorage _getStorage = GetStorage();
  TransactionController get transactionController =>
      Get.put(TransactionController());
  QRViewController? controller;

  // final tabList = ["Account", "Wallets", "Assets"];
  final tabList = ["Account", "Assets"];
  int selectedTab = 0;
  bool refresh = false;
  late double height;
  late double width;
  List<Wallet>? wallets;
  String? walletId;
  String? userId;
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
  void dispose() {
    _isDisposed = true;
    pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: selectedTab);
    // walletId = _getStorage.read('walletId');
    fetchProfile();
  }

  @override
  void reassemble() {
    super.reassemble();
    try {
      if (Platform.isAndroid) {
        controller!.pauseCamera();
      }
      controller!.resumeCamera();
    } catch (error) {
      log('reassemble error occured ${error}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;

    return Scaffold(
      appBar: buildAppBar(),
      body: Container(
        color: const Color.fromRGBO(255, 255, 255, 1),
        child: Obx(() => authController.initiateNewTransaction.value
            ? memberInitiateTrans()
            : buildTabList()),
      ),
    );
  }

  PreferredSizeWidget buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(
          authController.initiateNewTransaction.value ? 240.0 : 336.0),
      child: _isLoading
          ? Center(
              child: LoadingShimmerWidget(),
            )
          : Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8.0,
                    spreadRadius: 2.0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: AppBar(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20.0),
                  ),
                ),
                backgroundColor: whiteColor,
                automaticallyImplyLeading: false,
                centerTitle: false,
                titleSpacing: -1.0,
                toolbarHeight:
                    authController.initiateNewTransaction.value ? 240.0 : 340.0,
                elevation: 0,
                title: Column(
                  children: [
                    const AppHeaderWidget(),
                    const WalletBalancesWidget(),
                    if (!authController.initiateNewTransaction.value) ...[
                      heightBox(15),
                      tabBar(),
                    ],
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildTabList() {
    return _isLoading
        ? Center(
            child: LoadingShimmerWidget(),
          )
        : Column(
            children: [
              heightBox(20),
              Expanded(
                child: PageView(
                  controller: pageController,
                  onPageChanged: (index) {
                    setState(() {
                      refresh = true;
                      selectedTab = index;
                    });
                    setState(() {
                      refresh = false;
                    });
                  },
                  children: [
                    Container(
                        color: whiteColor,
                        child: const HomeAccountWidgetApps(
                          category: 'accountList',
                        )),
                    // Container(
                    //   color: whiteColor,
                    //   child: const HomeAccountWidgetApps(
                    //     category: 'walletList',
                    //   ),
                    // ),
                    Container(
                        color: whiteColor,
                        child: const HomeAccountWidgetApps(
                          category: 'assetsList',
                        )),
                  ],
                ),
              ),
            ],
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
                  ),
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

  tabBar() {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: recColor,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15.0),
            bottomRight: Radius.circular(15.0)),
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
                  padding: const EdgeInsets.all(fixPadding * 2),
                  decoration: BoxDecoration(
                      color:
                          selectedTab == index ? primaryColor : tertiaryColor),
                  child: Text(
                    tabList[index].toString(),
                    style: selectedTab == index
                        ? semibold12White
                        : semibold12black,
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
