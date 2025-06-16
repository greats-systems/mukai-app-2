import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mukai/src/controllers/auth.controller.dart';
import 'package:mukai/src/apps/home/admin/admin_recent_transactions.dart';
import 'package:mukai/src/apps/home/widgets/admin_app_header.dart';
import 'package:mukai/src/apps/home/widgets/metric_row.dart';
import 'package:mukai/src/apps/transactions/controllers/transactions_controller.dart';
import 'package:mukai/src/apps/transactions/views/screens/transfers.dart';
import 'package:mukai/theme/theme.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AdminLandingScreen extends StatefulWidget {
  const AdminLandingScreen({super.key});
  static const routeName = '/home';
  @override
  State<AdminLandingScreen> createState() => _AdminLandingScreenState();
}

class _AdminLandingScreenState extends State<AdminLandingScreen> {
  AuthController get authController => Get.put(AuthController());
  TransactionController get transactionController =>
      Get.put(TransactionController());
  late PageController pageController = PageController();
  final GetStorage _getStorage = GetStorage();
  final tabList = ["Contributions", "Wallets Transfers", "Payments"];
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
      backgroundColor: primaryColor,
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
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            centerTitle: false,
            titleSpacing: 0.0,
            toolbarHeight: 225.0,
            elevation: 0,
            title: const AdminAppHeaderWidget(),
          ),
        ),
      ),
      body: Container(
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: whiteF5Color,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
          child: ListView(
            children: [
              Obx(() => authController.initiateNewTransaction.value == true
                  ? adminInitiateTrans()
                  : adminOptions())
            ],
          )),
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

  adminOptions() {
    return Column(
      children: [perWidget(), heightBox(20), tabBar(), tabPreviews()],
    );
  }

  perWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
      child: Container(
        height: height * 0.15,
        width: width * 0.9,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side with circular progress
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  value: 0.95, // 95% progress
                  valueColor: AlwaysStoppedAnimation<Color>(whiteColor),
                  backgroundColor: tertiaryColor,
                  strokeWidth: 2,
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: width * 0.2,
                  child: AutoSizeText(
                    textAlign: TextAlign.center,
                    'Subscription goals',
                    style: TextStyle(
                      color: whiteColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            width5Space,
            width5Space,
            // Vertical divider
            Container(
              color: whiteF5Color.withOpacity(0.5),
              width: 1.5,
              height: 80,
            ),

            // Right side with metrics
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MetricRow(
                      icon: "assets/icons/Vector.png",
                      title: 'Revenue Last Month',
                      value: '\$4,000.00',
                    ),
                    Container(
                      color: whiteF5Color.withOpacity(0.5),
                      width: width,
                      height: 1.5,
                    ),
                    MetricRow(
                      icon: "assets/icons/mdi_account-payment-outline.png",
                      title: 'Fines from Last Month',
                      value: '\$100.00',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
                      child: AdminRecentTransactionsWidget(
                        category: 'daily',
                      )),
                  Container(
                    color: whiteColor,
                    child: const AdminRecentTransactionsWidget(
                      category: 'weekly',
                    ),
                  ),
                  Container(
                      color: whiteColor,
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
