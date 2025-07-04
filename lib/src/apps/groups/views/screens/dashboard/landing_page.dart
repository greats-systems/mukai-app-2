import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ri.dart';
import 'package:mukai/brick/models/group.model.dart';
import 'package:mukai/constants.dart';
import 'package:mukai/src/apps/chats/views/screen/mukando_members_list.dart';
import 'package:mukai/src/apps/groups/views/screens/assets/add_asset.dart';
import 'package:mukai/src/apps/groups/views/screens/assets/coop_assets.dart';
import 'package:mukai/src/apps/groups/views/screens/dashboard/coop_memeber_analytics.dart';
import 'package:mukai/src/apps/groups/views/screens/dashboard/coop_reports.dart';
import 'package:mukai/src/apps/groups/views/screens/dashboard/coop_wallet_balances.dart';
import 'package:mukai/src/apps/groups/views/widgets/polls_list.dart';
import 'package:mukai/src/apps/home/apps/contribution/make_contribution.dart';
import 'package:mukai/src/apps/home/apps/group_loans/loan_landing_page.dart';
import 'package:mukai/src/apps/home/apps/loans/loan_landing_page.dart';
import 'package:mukai/src/apps/home/apps/loans/loan_application.dart';
import 'package:mukai/src/apps/home/apps/subscriptions/subscriptions.dart';
// import 'package:mukai/src/apps/home/widgets/assets/pay_subs.dart';
import 'package:mukai/src/bottom_bar.dart';
import 'package:mukai/src/controllers/auth.controller.dart';
import 'package:mukai/src/apps/transactions/controllers/transactions_controller.dart';
import 'package:mukai/src/apps/transactions/views/screens/transfers.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/utils/utils.dart';
import 'package:mukai/widget/loading_shimmer.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CoopLandingScreen extends StatefulWidget {
  const CoopLandingScreen({super.key, required this.group});
  final Group group;
  static const routeName = '/home';
  @override
  State<CoopLandingScreen> createState() => _CoopLandingScreenState();
}

class _CoopLandingScreenState extends State<CoopLandingScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthController authController = Get.find<AuthController>();
  final TransactionController transactionController =
      Get.find<TransactionController>();
  late PageController pageController = PageController();
  final GetStorage _getStorage = GetStorage();
  final tabList = ["Dashboard", "Members", "Assets", "Polls"];
  int selectedTab = 0;
  bool refresh = false;
  late double height;
  late double width;
  String? walletId;

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
    try {
      final response = await dio.get(
          '${EnvConstants.APP_API_ENDPOINT}/wallets/coop/${widget.group.id}');
      log(response.data.toString());
      if (response.data['data'] != 'No wallet found') {
        final walletJson = response.data['data'];
        setState(() {
          walletId = walletJson['id'];
          _isLoading = false;
        });
      } else {
        log('No wallet found');
      }
    } on Exception catch (e, s) {
      log('CoopLandingScreen fetchProfile error: $e $s');
      if (_isDisposed) return;
    } finally {
      setState(() {
        // userProfile = userjson;
        _isLoading = false;
      });
    }
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
      key: _scaffoldKey,
      floatingActionButtonLocation: floatingActionButtonLocation(),
      floatingActionButton: floatingActionButton(),
      backgroundColor: primaryColor,
      appBar: appBar(),
      body: buildBody(),
      drawer: openDrawer(),
    );
  }

  Widget openDrawer() {
    final size = MediaQuery.of(context).size;
    return Drawer(
      backgroundColor: whiteColor,
      child: SizedBox(
        height: height * 0.8,
        child: ListView(
          // Important: Remove any padding from the ListView.
          // padding: EdgeInsets.symmetric(vertical: 5),
          children: [
            ListTile(
              title: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Iconify(
                    Ri.bank_line,
                    color: primaryColor,
                  ),
                  SizedBox(
                    width: size.width / 24,
                  ),
                  const Text(
                    'Loans',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              onTap: () {
                Get.to(() => LoanLandingPageScreen(
                      group: widget.group,
                    ));
              },
            ),
            ListTile(
              title: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Iconify(
                    Ri.money_dollar_box_line,
                    color: primaryColor,
                  ),
                  SizedBox(
                    width: size.width / 24,
                  ),
                  const Text(
                    'Subscriptions',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              onTap: () {
                Get.to(() => MySubscriptionsScreen(
                      group: widget.group,
                    ));
              },
            ),
            ListTile(
              title: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Iconify(
                    Ri.hand_coin_line,
                    color: primaryColor,
                  ),
                  SizedBox(
                    width: size.width / 24,
                  ),
                  const Text(
                    'Contributions',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              onTap: () {
                Get.to(() => MakeContributionScreen(
                      group: widget.group,
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }

  FloatingActionButtonLocation floatingActionButtonLocation() {
    return selectedTab == 0
        ? FloatingActionButtonLocation.startFloat
        : FloatingActionButtonLocation.endFloat;
  }

  FloatingActionButton? floatingActionButton() {
    return role == 'coop-manager' && selectedTab == 2
        ? FloatingActionButton(
            onPressed: () {
              Get.to(() => AddAssetWidget(group: widget.group));
            },
            backgroundColor: primaryColor,
            child: const Icon(
              Icons.add,
              color: tertiaryColor,
              size: 36,
            ),
          )
        : null;
  }

  Widget buildBody() {
    return Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: whiteF5Color,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
        ),
        child: tabPreviews());
  }

  PreferredSizeWidget appBar() {
    return PreferredSize(
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
          title: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        profileButton(),
                        IconButton(
                          // Menu button on the right
                          icon: const Icon(
                            Icons.menu,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () {
                            _scaffoldKey.currentState?.openDrawer();
                          },
                        ),
                      ],
                    ),
                    tabBar(),
                    heightBox(20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget logoButton() {
    return GestureDetector(
      onTap: () {
        log('CoopHeaderWidget\nuserId: $userId\nrole: $role');
        Get.to(() => BottomBar());
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
                  SizedBox(
                    height: height,
                    child: Column(
                      children: [
                        SizedBox(
                            height: height * 0.4125,
                            child: walletId != null
                                ? CoopReportsWidget(
                                    walletId: walletId!,
                                    group: widget.group,
                                  )
                                : Center(
                                    child: Text('Nothing to display'),
                                  )),
                        CoopWalletBalancesWidget(group: widget.group),
                      ],
                    ),
                  ),
                  MukandoMembersList(
                    group: widget.group,
                  ),
                  CoopAssetsWidget(
                    group: widget.group,
                  ),
                  CoopPollsScreen(group: widget.group),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tabBar() {
    return Container(
      height: height * 0.065,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: secondaryColor.withAlpha(75),
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      child: Row(
        children: List.generate(
          tabList.length,
          (index) {
            return GestureDetector(
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
                  style:
                      selectedTab == index ? semibold12White : semibold12White,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
