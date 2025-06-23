import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ri.dart';
import 'package:mukai/src/apps/chats/views/screen/group_chats.dart';
import 'package:mukai/src/controllers/auth.controller.dart';
import 'package:mukai/src/apps/chats/views/screen/notifications/notifications_list.dart';
import 'package:mukai/src/apps/chats/views/screen/notifications/directchats_list.dart';
import 'package:mukai/src/apps/chats/views/widgets/realtime_conversations_list.dart';
// import 'package:mukai/src/apps/groups/views/widgets/group_members_list.dart';
// import 'package:mukai/src/apps/home/widgets/admin_app_header.dart';
import 'package:mukai/src/apps/home/widgets/admin_app_header_logo.dart';
import 'package:mukai/src/apps/transactions/controllers/transactions_controller.dart';
import 'package:mukai/theme/theme.dart';
// import 'package:mukai/utils/utils.dart';

class CommunicationsScreen extends StatefulWidget {
  int initialselectedTab;

  CommunicationsScreen({super.key, required this.initialselectedTab});

  @override
  State<CommunicationsScreen> createState() => _GroupMembersScreenState();
}

class _GroupMembersScreenState extends State<CommunicationsScreen> {
  AuthController get authController => Get.put(AuthController());
  GetStorage _getStorage = GetStorage();
  TransactionController get transactionController =>
      Get.put(TransactionController());
  late PageController pageController = PageController();
  final tabList = ["My Coops", "Messages", "Notifications"];
  int selectedTab = 0;
  bool refresh = false;
  late double height;
  late double width;
  String? role;

  @override
  void initState() {
    pageController = PageController(initialPage: widget.initialselectedTab);
    role = _getStorage.read('account_type');
    super.initState();
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
        backgroundColor: secondaryColor.withAlpha(50),
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 0.0,
        toolbarHeight: 100.0,
        title: Column(
          children: [
            // const AdminAppHeaderLogoWidget(),
            tabBar()
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: whiteF5Color,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(0.0),
                ),
                border: Border.all(
                  color: whiteF5Color,
                ),
                boxShadow: boxShadow,
              ),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(fixPadding * 2.0),
                children: [tabPreviews()],
              ),
            ),
          )
        ],
      ),
    );
  }

  logoButton() {
    return GestureDetector(
      onTap: () {
        log('CommunicationsScreen role: $role');
        // Navigator.pushNamed(context, '/bottomBar');
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

  tabPreviews() {
    return SizedBox(
      height: height,
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
                  color: whiteF5Color,
                  child: GroupsList(
                    index: 0,
                  ),
                ),
                Container(
                    color: whiteF5Color,
                    child: RealTimeConversationsList(
                      index: 0,
                    )),
                Container(
                    color: whiteF5Color,
                    child: NotificationsList(
                      index: 0,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  tabBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: secondaryColor.withAlpha(100),
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  padding: const EdgeInsets.all(fixPadding * 1),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  child: Column(
                    children: [
                      Iconify(
                        index == 0
                            ? Ri.group_line
                            : index == 1
                                ? Ri.chat_3_line
                                : Ri.notification_2_fill,
                        color: selectedTab == index
                            ? blackOrignalColor
                            : blackColor,
                      ),
                      Text(
                        tabList[index].toString(),
                        style: selectedTab == index
                            ? TextStyle(color: blackColor, fontSize: 14)
                            : semibold14Black,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
