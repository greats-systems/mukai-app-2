// import 'dart:developer';

// import 'dart:nativewrappers/_internal/vm/lib/developer.dart';

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mukai/brick/models/profile.model.dart';
import 'package:mukai/src/controllers/auth.controller.dart';
import 'package:mukai/src/apps/groups/views/screens/create_group.dart';
import 'package:mukai/src/apps/groups/views/widgets/group_members_list.dart';
import 'package:mukai/src/apps/transactions/controllers/transactions_controller.dart';
// import 'package:mukai/src/controllers/group.controller.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/utils/utils.dart';

class GroupMembersScreen extends StatefulWidget {
  final int initialselectedTab;
  final String? groupId;
  final List<Profile>? profiles;

  GroupMembersScreen({
    super.key,
    required this.initialselectedTab,
    this.groupId,
    this.profiles,
  });

  @override
  State<GroupMembersScreen> createState() => _GroupMembersScreenState();
}

class _GroupMembersScreenState extends State<GroupMembersScreen> {
  AuthController get authController => Get.put(AuthController());
  TransactionController get transactionController =>
      Get.put(TransactionController());
  // final GroupController _groupController = GroupController();
  late PageController pageController = PageController();
  final tabList = ["Members", "Wallet details"];
  int selectedTab = 0;
  bool refresh = false;
  late double height;
  late double width;

  @override
  void initState() {
    pageController = PageController(initialPage: widget.initialselectedTab);
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
            bottom: Radius.circular(20.0),
          ),
        ),
        elevation: 0,
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: whiteF5Color,
          ),
        ),
        centerTitle: false,
        titleSpacing: 20.0,
        toolbarHeight: 70.0,
        title: Text(
          Utils.trimp('Group Members'),
          style: bold18WhiteF5,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
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
              child: Column(
                children: [tabBar(), tabPreviews()],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Container(
        color: tertiaryColor,
        child: GestureDetector(
          child: Icon(
            Icons.add,
            size: 30,
            color: Colors.white,
          ),
          onTap: () {
            log('Tapped');
            Get.to(() => CreateGroup());
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  tabPreviews() {
    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: SafeArea(
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
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            color: whiteF5Color,
                            child: GroupMembersList(
                              groupId: widget.groupId?? 'no ID',
                              category: 'accepted',
                            ),
                          ),
                          // ElevatedButton(
                          //   onPressed: () => Get.to(() => CreateGroup()),
                          //   child: const Icon(Icons.add),
                          // ),
                        ],
                      ),
                    ),
                    Container(
                      color: whiteF5Color,
                      child: GroupMembersList(
                        groupId: widget.groupId ?? 'No ID',
                        category: 'unresolved',
                      ),
                    ),
                    Container(
                      color: whiteF5Color,
                      child: GroupMembersList(
                        groupId: widget.groupId?? 'No ID',
                        category: 'declined',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
