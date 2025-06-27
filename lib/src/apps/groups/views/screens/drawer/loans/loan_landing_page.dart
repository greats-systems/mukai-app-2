import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mukai/brick/models/group.model.dart';
import 'package:mukai/brick/models/loan.model.dart';
import 'package:mukai/brick/models/wallet.model.dart';
import 'package:mukai/components/app_bar.dart';
import 'package:mukai/src/apps/groups/views/screens/drawer/loans/coop_loans.dart';
import 'package:mukai/src/apps/groups/views/screens/drawer/loans/loan_application.dart';
import 'package:mukai/src/apps/groups/views/screens/drawer/loans/loan_detail.dart';
import 'package:mukai/src/apps/groups/views/screens/drawer/loans/my_loans.dart';
import 'package:mukai/src/apps/groups/views/widgets/loan_item.dart';
import 'package:mukai/src/controllers/loan.controller.dart';
import 'package:mukai/src/controllers/wallet.controller.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/widget/loading_shimmer.dart';

class LoanLandingPageScreen extends StatefulWidget {
  final Group group;
  const LoanLandingPageScreen({super.key, required this.group});

  @override
  State<LoanLandingPageScreen> createState() => _LoanLandingPageScreenState();
}

class _LoanLandingPageScreenState extends State<LoanLandingPageScreen> {
  final tabList = ["Create Loan", "My Loans", "Coop Loans"];
  int selectedTab = 0;
  final GetStorage _getStorage = GetStorage();
  final WalletController _walletController = WalletController();
  final LoanController _loanController = LoanController();
  List<Wallet>? wallets;
  List<Loan>? loans;
  String? userId;
  String? role;
  bool _isLoading = false;
  bool refresh = false;
  late double height;
  late double width;
  late PageController pageController = PageController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    pageController = PageController(initialPage: selectedTab);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;
    return Scaffold(
      appBar: MyAppBar(title: 'Loans'),
      body: buildBody(),
    );
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
        child: ListView(
          children: [adminOptions()],
        ));
  }

  Widget adminOptions() {
    return Column(
      children: [
        tabBar(),
        // heightBox(20),
        tabPreviews()
      ],
    );
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
          backgroundColor: primaryColor,
          automaticallyImplyLeading: false,
          centerTitle: false,
          titleSpacing: 0.0,
          toolbarHeight: 90.0,
          elevation: 0,
          title: _isLoading
              ? Center(
                  child: LoadingShimmerWidget(),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        children: [
                          heightBox(20),
                          // tabBar(),
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

  Widget tabBar() {
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

  Widget tabPreviews() {
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
                  LoanApplicationScreen(group: widget.group),
                  MyLoansScreen(),
                  CoopLoansScreen(group: widget.group),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
