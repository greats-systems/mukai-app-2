import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconify_flutter_plus/icons/ri.dart';
import 'package:mukai/brick/models/profile.model.dart';
import 'package:mukai/brick/models/wallet.model.dart';
import 'package:mukai/src/apps/groups/views/screens/members/create_group.dart';
import 'package:mukai/src/apps/home/landing_quick_transact.dart';
import 'package:mukai/src/apps/home/qr_code.dart';
import 'package:mukai/src/apps/home/widgets/admin_app_header.dart';
import 'package:mukai/src/apps/reports/views/reports_screen.dart';
import 'package:mukai/src/apps/transactions/controllers/transactions_controller.dart';
import 'package:mukai/src/apps/transactions/views/screens/transfers.dart';
import 'package:mukai/src/controllers/auth.controller.dart';
import 'package:mukai/src/apps/chats/views/screen/communications_screen.dart';
// import 'package:mukai/src/apps/chats/views/widgets/realtime_conversations_list.dart';
import 'package:mukai/src/apps/home/admin_landing.dart';
import 'package:mukai/src/apps/settings/screens/adming_setttings_landing.dart';
import 'package:mukai/src/apps/settings/screens/member_settings_landing.dart';
import 'package:mukai/src/controllers/profile_controller.dart';
import 'package:mukai/src/controllers/wallet.controller.dart';
import 'package:mukai/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:qr_flutter/qr_flutter.dart';

class BottomBar extends StatefulWidget {
  final String? role;
  final int? index;
  final int? alterIndex;
  final int? alterTabIndex;
  const BottomBar(
      {super.key, this.index, this.alterIndex, this.alterTabIndex, this.role});
  static const routeName = '/bottomBar';

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  AuthController get authController => Get.put(AuthController());
  final GetStorage _getStorage = GetStorage();
  final autoSizeGroup = AutoSizeGroup();
  TransactionController get transactionController =>
      Get.put(TransactionController());
  final WalletController _walletController = WalletController();
  final ProfileController _profileController = ProfileController();

  // late List<Widget> membermanagerPages;
  String? userId;
  String? userRole;
  int _currentIndex = 0;
  late double height;
  late double width;
  List<Wallet>? wallets;
  String? walletId;

  bool _isDisposed = false;
  bool _isLoading = false;
  Future<void> _fetchData() async {
    userId = await _getStorage.read('userId');
    userRole = await _getStorage.read('role');
  }

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
      if (walletJson != null) {
        setState(() {
          walletId = walletJson[0]['id'];
        });
      }
    }
  }

  final iconList = <IconData>[
    MingCute.wallet_2_line,
    BoxIcons.bx_wallet,
    BoxIcons.bx_donate_heart,
    BoxIcons.bx_user_circle
  ];
  final iconTitleList = <String>['Home', 'Reports', 'Coops', 'Settings'];
  int selectedIndex = 0;
  DateTime? backPressTime;

  final managerPages = [
    const AdminLandingScreen(),
    ReportsScreen(),
    CommunicationsScreen(
      initialselectedTab: 0,
    ),
    const AdmingSettingsLandingScreen(),
  ];

  final membermanagerPages = [
    AdminLandingScreen(),
    ReportsScreen(),
    CommunicationsScreen(
      initialselectedTab: 0,
    ),
    const MemberSettingsLandingScreen(),
  ];

  int? currentIndex = 0;
  int? subIndex = 2;

  @override
  void initState() {
    log(widget.role ?? 'No role');
    super.initState();
    _fetchData();
    authController.getAccount();
    if (widget.index != null) {
      setState(() {
        selectedIndex = widget.index!;
        subIndex = widget.alterIndex;
      });
    } else {
      setState(() {
        selectedIndex = 0;
        subIndex = 0;
      });
    }
  }

  changeIndex(index, subIndex) {
    setState(() {
      debugPrint('subIndex $subIndex');
      selectedIndex = index;
      subIndex = subIndex;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;
    return Scaffold(
      body: Obx(() => authController.initiateNewTransaction.value == true
          ? LandingQuickTransactScreen()
          : Container(
              color: whiteF5Color, // Background color
              child: userRole == 'coop-manager'
                  ? managerPages[_currentIndex]
                  : membermanagerPages[_currentIndex],
            )),
      floatingActionButton: userRole == 'coop-manager' && selectedIndex == 2
          ? addGroup()
          : scanQR(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: gappedBottombar(),
    );
  }

  PreferredSizeWidget buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(105.0), // Match the toolbarHeight
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
          toolbarHeight: 100.0,
          elevation: 0,
          title: const AdminAppHeaderWidget(),
        ),
      ),
    );
  }

  scanQR() {
    return GestureDetector(
      onTap: () {
        log('Tapped!');
        authController.initiateNewTransaction.value =
            !authController.initiateNewTransaction.value;
      },
      child: Container(
        height: 52.0,
        width: 52.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: tertiaryColor,
          boxShadow: [
            BoxShadow(
              color: primaryColor,
              blurRadius: 5.0,
            )
          ],
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.qr_code_2_outlined,
          color: whiteF5Color,
          size: 40.0,
        ),
      ),
    );
  }

  addGroup() {
    return GestureDetector(
      onTap: () {
        Get.to(() => CreateGroup());
      },
      child: Container(
        height: 52.0,
        width: 52.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: tertiaryColor,
          boxShadow: [
            BoxShadow(
              color: primaryColor,
              blurRadius: 5.0,
            )
          ],
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.add,
          color: whiteF5Color,
          size: 40.0,
        ),
      ),
    );
  }

  gappedBottombar() {
    return AnimatedBottomNavigationBar.builder(
      backgroundColor: whiteF5Color,
      itemCount: 4,
      tabBuilder: (int index, bool isActive) {
        final color =
            isActive ? primaryColor : const Color.fromRGBO(20, 19, 19, 1);
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (index == 0)
              Container(
                  height: 30.0,
                  width: 30.0,
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/icons/tabler_home.png',
                    color: color,
                  ))
            else if (index == 1)
              Container(
                  height: 30.0,
                  width: 30.0,
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/icons/mdi_graph-box-multiple.png",
                  ))
            else if (index == 3)
              Container(
                  height: 30.0,
                  width: 30.0,
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/icons/material-symbols_settings.png",
                  ))
            else
              Container(
                  height: 30.0,
                  width: 30.0,
                  alignment: Alignment.center,
                  child: Iconify(
                    Ri.inbox_archive_fill,
                    color: primaryColor,
                    size: 30,
                  )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: AutoSizeText(
                iconTitleList[index],
                maxLines: 1,
                style: TextStyle(color: color),
                group: autoSizeGroup,
              ),
            )
          ],
        );
      },
      activeIndex: _currentIndex,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.softEdge,
      borderColor: recWhiteColor,
      notchMargin: 10.0,
      shadow: Shadow(
        color: blackOrignalColor.withOpacity(0.2),
        blurRadius: 6.0,
        offset: const Offset(4, 0),
      ),
      splashRadius: 0,
      scaleFactor: 0.9,
      onTap: (index) {
        authController.initiateNewTransaction.value = false;
        setState(() => _currentIndex = index);
      },
    );
  }

  onPopInvoked() {
    DateTime now = DateTime.now();
    if (backPressTime == null ||
        now.difference(backPressTime!) >= const Duration(seconds: 2)) {
      backPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(milliseconds: 1500),
          behavior: SnackBarBehavior.floating,
          backgroundColor: whiteF5Color,
          content: Text(
            "Press back once again to exit",
            style: semibold15black,
          ),
        ),
      );
      return false;
    } else {
      return true;
    }
  }
}
