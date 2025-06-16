import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mukai/brick/models/group.model.dart';
import 'package:mukai/src/apps/chats/views/screen/mukando_members_list.dart';
import 'package:mukai/src/apps/groups/views/screens/group_wallet_details.dart';
import 'package:mukai/src/apps/transactions/controllers/transactions_controller.dart';
import 'package:mukai/src/components/my_app_bar.dart';
import 'package:mukai/src/controllers/auth.controller.dart';
import 'package:mukai/theme/theme.dart';

class MukandoMembersLandingPage extends StatefulWidget {
  final Group group;
  const MukandoMembersLandingPage({super.key, required this.group});

  @override
  State<MukandoMembersLandingPage> createState() =>
      _MukandoMembersLandingPageState();
}

class _MukandoMembersLandingPageState extends State<MukandoMembersLandingPage> {
  AuthController get authController => Get.put(AuthController());
  TransactionController get transactionController =>
      Get.put(TransactionController());
  late PageController pageController = PageController();
  // final GetStorage _getStorage = GetStorage();
  final tabList = ["Members", "Wallets Info"];
  int selectedTab = 0;
  bool refresh = false;
  late double height;
  late double width;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;
    return Scaffold(
      // backgroundColor: primaryColor,
      appBar: MyAppBar(title: 'Mukando details'),
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
            children: [groupOptions()],
          )),
    );
  }

  groupOptions() {
    return Column(
      children: [tabBar(), tabPreviews()],
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
                  Container(color: whiteColor, child: MukandoMembersList(group: widget.group,)),
                  Container(
                    color: whiteColor,
                    child: GroupWalletDetails(),
                  ),
                  /*
                  Container(
                      color: whiteColor,
                      child: const AdminRecentTransactionsWidget(
                        category: 'monthly',
                      )
                      ),
                      */
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
