import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mukai/brick/models/group.model.dart';
import 'package:mukai/constants.dart';
import 'package:mukai/src/apps/chats/views/screen/mukando_members_list.dart';
import 'package:mukai/src/apps/groups/views/screens/add_asset.dart';
import 'package:mukai/src/apps/groups/views/screens/coop_assets.dart';
import 'package:mukai/src/apps/groups/views/screens/coop_memeber_analytics.dart';
import 'package:mukai/src/apps/groups/views/screens/coop_reports.dart';
import 'package:mukai/src/apps/groups/views/screens/coop_wallet_balances.dart';
import 'package:mukai/src/apps/home/widgets/assets/pay_subs.dart';
import 'package:mukai/src/bottom_bar.dart';
import 'package:mukai/src/controllers/auth.controller.dart';
import 'package:mukai/src/apps/transactions/controllers/transactions_controller.dart';
import 'package:mukai/src/apps/transactions/views/screens/transfers.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/utils/utils.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CoopLandingScreen extends StatefulWidget {
  const CoopLandingScreen({super.key, required this.group});
  final Group group;
  static const routeName = '/home';
  @override
  State<CoopLandingScreen> createState() => _CoopLandingScreenState();
}

class _CoopLandingScreenState extends State<CoopLandingScreen> {
  final AuthController authController = Get.find<AuthController>();
  final TransactionController transactionController = Get.find<TransactionController>();
  late PageController pageController = PageController();
  final GetStorage _getStorage = GetStorage();
  final tabList = ["Dashboard", "Members", "Assets"];
  int selectedTab = 0;
  bool refresh = false;
  late double height;
  late double width;
  dynamic? walletId;

  String? userId;
  String? role;
  bool _isLoading = false;
  final dio = Dio();

  void fetchProfile() async {
    if (_isDisposed) return;
    setState(() {
      _isLoading = true;
      userId = _getStorage.read('userId');
      role = _getStorage.read('role');
    });
    final walletJson =
        await supabase.from('wallets').select('id').eq('profile_id', userId!);
    // .single();
    setState(() {
      walletId = walletJson;
    });
    log('CoopLandingScreen walletId: $walletId');

    // final userjson = await profileController.getUserDetails(userId!);

    if (_isDisposed) return;
    setState(() {
      // userProfile = userjson;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    log('CoopLandingScreen group.id: ${widget.group.id}');
    pageController = PageController(initialPage: selectedTab);
    // walletId = _getStorage.read('walletId');
    fetchProfile();

    super.initState();
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
      floatingActionButton: role == 'coop-manager' && selectedTab == 2
          ? FloatingActionButton(
              onPressed: () {
                Get.to(() => AddAssetWidget(group: widget.group));
              },
              backgroundColor: primaryColor,
              child: const Icon(Icons.add, color: tertiaryColor, size: 36,),
            )
          : null,
      backgroundColor: primaryColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150.0), // Match the toolbarHeight
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
            toolbarHeight: 150.0,
            elevation: 0,
            title: _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                profileButton(),
                                logoButton(),
                              ],
                            ),
                            heightBox(20),
                            tabBar(),
                            heightBox(20),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
      body: Container(
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: whiteF5Color,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
          ),
          child: ListView(
            children: [adminOptions()],
          )),
    );
  }

  logoButton() {
    return GestureDetector(
      onTap: () {
        log('CoopHeaderWidget\nuserId: $userId\nrole: $role');
        if (role == 'coop-manager') {
          Get.to(() => BottomBar());
        } else {
          Get.to(() => BottomBar());
        }
      },
      child: Container(
        height: 55.0,
        width: 55.0,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: whiteF5Color,
              blurRadius: 10.0,
              offset: const Offset(0, 0),
            )
          ],
          shape: BoxShape.circle,
          color: whiteF5Color.withOpacity(0),
        ),
        // alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Image.asset(
            'assets/images/logo-nobg.png',
          ),
        ),
      ),
    );
  }

  profileButton() {
    return GestureDetector(
      onTap: () {
        // Get.to(() => const ProfileScreen());
      },
      child: Row(
        spacing: 15,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: width * 0.3,
                child: AutoSizeText(
                  Utils.trimp(widget.group.name ?? 'No name on landing page'),
                  style: semibold18WhiteF5,
                ),
              ),
            ],
          )
        ],
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
      children: [
        // heightBox(20),
        tabPreviews()
      ],
    );
  }

  tabPreviews() {
    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.only(top: 3.0),
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
                  Column(
                    children: [
                      downloadReports(context),
                      SizedBox(
                          height: height * 0.38, child: CoopReportsWidget()),
                      if (role == 'coop-manager')
                        CoopMemeberAnalytics(group: widget.group),
                      // if (role == 'coop-manager')
                      CoopWalletBalancesWidget(group: widget.group),
                    ],
                  ),
                  //  GroupMembersList(groupId: widget.group.id!, category: 'accepted',),
                  MukandoMembersList(
                    group: widget.group,
                  ),
                  CoopAssetsWidget(
                    group: widget.group,
                  ),
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

  downloadReports(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Get.to(() => MemberPaySubs(group: widget.group));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: tertiaryColor.withAlpha(100),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text(
                    'Pay Subscription',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // TODO: Implement download functionality
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Download Report'),
                  content: Text('Choose download format'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Download as PDF
                      },
                      child: Text('PDF'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Download as Excel
                      },
                      child: Text('Excel'),
                    ),
                  ],
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: primaryColor.withAlpha(100),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.download, color: Colors.black, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'Download Report',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
