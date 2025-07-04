import 'package:flutter/material.dart';
import 'package:mukai/brick/models/group.model.dart';
import 'package:mukai/brick/models/loan.model.dart';
import 'package:mukai/brick/models/wallet.model.dart';
import 'package:mukai/src/apps/home/apps/loans/coop_loans.dart';
import 'package:mukai/src/apps/home/apps/loans/loan_application.dart';
import 'package:mukai/src/apps/home/apps/loans/my_loans.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/widget/loading_shimmer.dart';

class CoopLoanLandingPageScreen extends StatefulWidget {
  final Group group;
  const CoopLoanLandingPageScreen({super.key, required this.group});

  @override
  State<CoopLoanLandingPageScreen> createState() => _CoopLoanLandingPageScreenState();
}

class _CoopLoanLandingPageScreenState extends State<CoopLoanLandingPageScreen> {
  final tabList = ["Request", "My Loans", "Approvals"];
  int selectedTab = 0;
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
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20.0), // Adjust the radius as needed
          ),
        ),
        elevation: 0,
        backgroundColor: whiteF5Color,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: blackOrignalColor,
          ),
        ),
        centerTitle: false,
        titleSpacing: 0.0,
        toolbarHeight: 70.0,
        title: SizedBox(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: tabBar(),
        )),
      ),
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
      children: [tabPreviews()],
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
                  MyLoansScreen(group: widget.group),
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
