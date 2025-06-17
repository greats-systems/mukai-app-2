import 'dart:developer';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconify_flutter_plus/icons/ri.dart';
import 'package:mukai/src/apps/groups/views/screens/create_group.dart';
import 'package:mukai/src/apps/reports/views/reports_screen.dart';
import 'package:mukai/src/controllers/auth.controller.dart';
import 'package:mukai/src/apps/chats/views/screen/communications_screen.dart';
// import 'package:mukai/src/apps/chats/views/widgets/realtime_conversations_list.dart';
import 'package:mukai/src/apps/home/admin_landing.dart';
import 'package:mukai/src/apps/home/member_landing.dart';
import 'package:mukai/src/apps/settings/screens/adming_setttings_landing.dart';
import 'package:mukai/src/apps/settings/screens/member_settings_landing.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/widget/render_supabase_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/carbon.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

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
  final GetStorage _getStrorage = GetStorage();
  final autoSizeGroup = AutoSizeGroup();
  // late List<Widget> memberPages;
  String? userId;
  String? userRole;

  void _fetchData() async {
    final id = await _getStrorage.read('userId');
    // final role = await _getStrorage.read('account_type');
    setState(() {
      userId = id;
      // userRole = role;
      /*
      memberPages = [
        MemberLandingScreen(userId: userId),
        const Text('Members Page'),
        CommunicationsScreen(initialselectedTab: 0),
        const AdmingSettingsLandingScreen(),
      ];
      */
    });
    log('BottomBar userId: $userId, role: $userRole');
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
  
  final pages = [
    const AdminLandingScreen(),
    ReportsScreen(),
    CommunicationsScreen(
      initialselectedTab: 0,
    ),
    const AdmingSettingsLandingScreen(),
  ];

  final memberPages = [
    MemberLandingScreen(),
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
    /*
    memberPages = [
      const MemberLandingScreen(userId: null), // Handle null case in MemberLandingScreen
      const Text('Members Page'),
      CommunicationsScreen(initialselectedTab: 0),
      const AdmingSettingsLandingScreen(),
    ];
    */
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
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        bool backStatus = onPopInvoked();
        if (backStatus) {
          exit(0);
        }
      },
      child: Scaffold(
        extendBody: true,
        body: widget.role == 'admin'
            ? pages.elementAt(selectedIndex)
            : memberPages.elementAt(selectedIndex),
        floatingActionButton: selectedIndex==2 ? addGroup() : addButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: gappedBottombar(),
      ),
      /*
      child: widget.role == 'admin'
          ? Scaffold(
              extendBody: true,
              body: pages.elementAt(selectedIndex),
              floatingActionButton: addButton(),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              bottomNavigationBar: gappedBottombar(),
            )
          : Scaffold(
              extendBody: true,
              body: memberPages.elementAt(selectedIndex),
              floatingActionButton: addButton(),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
              bottomNavigationBar: gappedBottombar(),
            ),
            */
      /*
      child: Scaffold(
        extendBody: true,
        body: widget.role == 'admin'
            ? pages.elementAt(selectedIndex)
            : memberPages.elementAt(selectedIndex),
        floatingActionButton: addButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: gappedBottombar(),
      ),
      */
    );
  }

  addButton() {
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
      activeIndex: selectedIndex,
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
      onTap: (index) => setState(() => selectedIndex = index),
    );
  }

  Widget bottombar() {
    return Container(
      decoration: const BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      padding:
          const EdgeInsets.fromLTRB(0, 2.0, 0, 5.0), // Increased bottom padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => setState(() => selectedIndex = 0),
              child: Iconify(
                Carbon.home,
                color: selectedIndex == 0 ? primaryColor : recColor,
                size: 40.0,
              ),
            ),
          ),
          _buildNavItem(
            icon: BoxIcons.bx_command,
            label: 'Accounts',
            index: 1,
          ),
          // Cart Icon with Label

          // Search Icon with Label
          _buildNavItem(
            icon: BoxIcons.bx_abacus,
            label: 'Books',
            index: 2,
          ),
          Obx(() => authController.person.value.account_type != null
              ? _buildNavItemWithBadge(
                  icon: BoxIcons.bx_message_check,
                  label: 'Inbox',
                  index: 3,
                )
              : const SizedBox()),
          // Favorites Icon with Label
          GestureDetector(
            // onTap: () => Get.to(() => const ProfileScreen()),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              direction: Axis.vertical,
              spacing: -3, //
              children: [
                picInfo(),
                heightBox(5),
                Text(
                  'Profile',
                  style: TextStyle(
                    color: selectedIndex == 4 ? primaryColor : recColor,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  picInfo() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Obx(() => authController.person.value.profile_picture_id != null
        ? SizedBox(
            height: height * 0.04,
            width: width * 0.08,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: RenderSupabaseImageIdWidget(
                filePath: authController.person.value.profile_picture_id!,
              ),
            ),
          )
        : const Icon(
            size: 37,
            Icons.person_2_outlined,
            color: recColor,
          ));
  }

// Method to build a nav item without badge
  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    return GestureDetector(
      onTap: () => setState(() => selectedIndex = index),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        direction: Axis.vertical,
        spacing: -12,
        children: [
          IconButton(
            icon: Icon(icon, size: 25),
            color: selectedIndex == index ? primaryColor : recColor,
            onPressed: () => setState(() => selectedIndex = index),
          ),
          Text(
            label,
            style: TextStyle(
              color: selectedIndex == index ? primaryColor : recColor,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

// Method to build a nav item with badge
  Widget _buildNavItemWithBadge({
    required IconData icon,
    required String label,
    required int index,
  }) {
    return GestureDetector(
      onTap: () => setState(() => selectedIndex = index),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        direction: Axis.vertical,
        spacing: -12, //
        children: [
          GestureDetector(
            onTap: () => setState(() => selectedIndex = index),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  icon: Icon(icon, size: 25),
                  color: selectedIndex == index ? primaryColor : recColor,
                  onPressed: () => setState(() => selectedIndex = index),
                ),
                Obx(() => authController.messages.isNotEmpty
                    ? Positioned(
                        left: 30,
                        top: 2,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 25,
                            minHeight: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${authController.messages.length}',
                                style: const TextStyle(
                                  color: recColor,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox()),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 11.0),
                child: Text(
                  label,
                  style: TextStyle(
                    color: selectedIndex == index ? primaryColor : recColor,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
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
