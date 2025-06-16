import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mukai/src/apps/home/widgets/app_header.dart';
import 'package:mukai/src/apps/home/widgets/apps_features.dart';
import 'package:mukai/src/apps/transactions/controllers/transactions_controller.dart';
import 'package:mukai/src/apps/transactions/views/screens/transfers.dart';
import 'package:mukai/src/controllers/auth.controller.dart';
import 'package:mukai/theme/theme.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
  final GetStorage _getStorage = GetStorage();
  TransactionController get transactionController =>
      Get.put(TransactionController());
  final tabList = ["Account", "Wallets", "Assets", 'FinMarkets'];
  int selectedTab = 0;
  bool refresh = false;
  late double height;
  late double width;

  String? walletId;

  @override
  void initState() {
    pageController = PageController(initialPage: selectedTab);
    walletId = _getStorage.read('walletId');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(225.0), // Match the toolbarHeight
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // Shadow color
                blurRadius: 8.0, // Blur radius
                spreadRadius: 2.0, // Spread radius
                offset: const Offset(0, 4), // Shadow position (bottom)
              ),
            ],
          ),
          child: AppBar(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20.0), // Adjust the radius as needed
              ),
            ),
            backgroundColor: whiteF5Color,
            automaticallyImplyLeading: false,
            centerTitle: false,
            titleSpacing: -1.0,
            toolbarHeight: 225.0,
            elevation: 0,
            title: Column(
              children: [const AppHeaderWidget(), heightBox(30), tabBar()],
            ),
          ),
        ),
      ),
      body: Container(
        color: const Color.fromRGBO(255, 255, 255, 1),
        child: Obx(() => authController.initiateNewTransaction.value == true
            ? memberInitiateTrans()
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
                        Container(
                          color: whiteColor,
                          child: const HomeAccountWidgetApps(
                            category: 'walletList',
                          ),
                        ),
                        Container(
                            color: whiteColor,
                            child: const HomeAccountWidgetApps(
                              category: 'assetsList',
                            )),
                        Container(
                          color: whiteColor,
                          child: const HomeAccountWidgetApps(
                            category: 'stocksList',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
      ),
    );
  }

  memberInitiateTrans() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          alignment: Alignment.center,
          child: Center(
            child: QrImageView(
              data: walletId ?? 'No wallet ID',
              version: QrVersions.auto,
              size: 250.0,
            ),
          ),
        ),
        Text('Scan to pay', style: bold16Black),
        heightBox(20),
        Container(
            alignment: Alignment(0, 0),
            height: height * 0.06,
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
              height: height * 0.06,
              width: width * 0.6,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: tertiaryColor,
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
                      color: selectedTab == index
                          ? primaryColor
                          : Colors.transparent),
                  child: Text(
                    tabList[index].toString(),
                    style:
                        selectedTab == index ? semibold12White : semibold12Grey,
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
