import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mukai/brick/models/group.model.dart';
import 'package:mukai/src/apps/converter/views/converter_screen.dart';
import 'package:mukai/src/apps/home/apps/loans/loan_landing_page.dart';
import 'package:mukai/src/apps/home/apps/pay_bills/pay_bills_transactions.dart';
import 'package:mukai/src/apps/home/apps/savings/savings_landing_page.dart';
import 'package:mukai/src/apps/home/widgets/assets/assets_list.dart';
import 'package:mukai/src/apps/transactions/views/screens/transfer_transaction.dart';
import 'package:mukai/src/apps/transactions/views/screens/transfers.dart';
import 'package:mukai/theme/theme.dart';

class TransactFeatureApps extends StatefulWidget {
  final String category;

  const TransactFeatureApps({super.key, required this.category});

  @override
  State<TransactFeatureApps> createState() => _TransactFeatureAppsState();
}

class _TransactFeatureAppsState extends State<TransactFeatureApps> {
  int? selectedCategory;
  String category = '1 day';
  late double height;
  late double width;
  final accountList = [
    // {"image": "assets/icons/Buy stocks.png", "title": "Pay Subs"},

    {"image": "assets/icons/vaadin_money-withdraw.png", "title": "CashOut"},
    {"image": "assets/icons/game-icons_cash.png", "title": "CashIn"},
    {
      "image": "assets/icons/mingcute_transfer-horizontal-line.png",
      "title": "Transfer"
    },

    {
      "image": "assets/icons/ic_outline-business-center.png",
      "title": "Pay Bill"
    },
    {"image": "assets/icons/Group.png", "title": "Airtime"},
    {"image": "assets/icons/hugeicons_sale-tag-02.png", "title": "Pos Pay"},
  ];

  final portfolioList = [
    {"image": "assets/icons/game-icons_wallet.png", "title": "Savings"},
    {"image": "assets/icons/mdi_file-sign.png", "title": "Loans"},
    {
      "image": "assets/icons/material-symbols_folder-managed-rounded.png",
      "title": "Assets"
    },
    {"image": "assets/icons/mdi_bank.png", "title": "Banking"},
  ];
  final stocksList = [
    {"image": "assets/icons/Buy stocks.png", "title": "Buy Stocks"},
    {"image": "assets/icons/wpf_bank-cards.png", "title": "Sell Stocks"},
    {
      "image": "assets/icons/material-symbols_folder-managed-rounded.png",
      "title": "Manage stocks"
    },
    {"image": "assets/icons/game-icons_wallet.png", "title": "Gazette Stocks"},
  ];
  final assetsList = [
    {
      "image": "assets/icons/material-symbols_folder-managed-rounded.png",
      "title": "Assets"
    },
    {"image": "assets/icons/gridicons_add-outline.png", "title": "Add Asset"},
    {"image": "assets/icons/Group.png", "title": "Declare Ownership"},
    {"image": "assets/icons/game-icons_cash.png", "title": "Request Valuation"},
    {"image": "assets/icons/mdi_file-sign.png", "title": "Mint Assets"},
    {
      "image": "assets/icons/teenyicons_share-solid.png",
      "title": "Share Asset Ownership"
    },
    {
      "image": "assets/icons/hugeicons_sale-tag-02.png",
      "title": "Sale Asset Token"
    },
    {
      "image": "assets/icons/ic_outline-business-center.png",
      "title": "Transfer and Revoke Ownership"
    },
    {
      "image": "assets/icons/healthicons_money-bag.png",
      "title": "Liquidate Assets"
    }
  ];

  void _handleItemTap(String title) {
    switch (title) {
      case 'Savings':
        Get.to(() => SavingsLandingPageScreen(
              group: Group(),
            ));
      case 'Loans':
        Get.to(() => CoopLoanLandingPageScreen(group: Group()));
      case 'Withdraw':
        Get.to(() => TransfersScreen(
              category: 'cashout',
            ));
      case 'CashOut':
        Get.to(() => TransfersScreen(
              category: 'cashout',
            ));
      case 'CashIn':
        Get.to(() => TransfersScreen(
              category: 'cashin',
            ));
      case 'Transfer':
        Get.to(() => TransferTransactionScreen());
        break;
      case 'Convertor':
        Get.to(() => ConverterScreen());
        break;
      case 'Pay Bill':
        Get.to(() => PayBillsTransactionsScreen());
        break;
      case 'Buy Airtime':
        Get.to(() => TransferTransactionScreen());
      case 'Pos Pay':
        Get.to(() => TransfersScreen(
              category: 'pos_payment',
            ));
      case 'Linked Bank':
        Get.to(() => TransfersScreen(
              category: 'cashout',
            ));
      case 'Assets':
        Get.to(() => MemberAssetsList());
        break;
      // case 'Pay Subs':
      //   Get.to(() => MemberPaySubs());
      //   break;

      /*
      case 'Pay Subs':
      Get.to(() => TransferTransactionScreen(purpose: 'subscription'));
      break;
      */
      case 'Transfer Wallet':

        // Get.to(() => TransferWalletScreen());
        throw UnimplementedError();
      case 'Share wallet':
        // Get.to(() => ShareWalletScreen());
        throw UnimplementedError();
      case 'Sub Wallets':
        // Get.to(() => SubWalletsScreen());
        throw UnimplementedError();
      case 'Buy Stocks':
        // Get.to(() => BuyStocksScreen());
        throw UnimplementedError();
      case 'Sell Stocks':
        // Get.to(() => SellStocksScreen());
        throw UnimplementedError();
      // Add cases for all your other options
      default:
        Get.snackbar('Coming Soon', 'This feature is under development');
        break;
    }
  }

  @override
  void initState() {
    log('Getting apps ${widget.category}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;
    var activeList = widget.category == 'walletList'
        ? portfolioList
        : widget.category == 'accountList'
            ? accountList
            : widget.category == 'assetsList'
                ? assetsList
                : widget.category == 'stocksList'
                    ? stocksList
                    : accountList;
    return Column(
      children: [
        heightBox(height * 0.01),
        SizedBox(
          width: width,
          height: height * 0.4,
          // height: widget.category == 'accountList' ||
          //         widget.category == 'walletList'
          //     ? height * 0.4
          //     : widget.category == 'stocksList'
          //         ? height * 0.25
          //         : height * 0.3,
          child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(
              left: fixPadding * 2.0,
              right: fixPadding * 2.0,
              bottom: fixPadding * 0.0,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: fixPadding * 2.0,
                crossAxisSpacing: fixPadding * 2.0,
                childAspectRatio: 0.68),
            itemCount: activeList.length,
            itemBuilder: (context, index) {
              return InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  _handleItemTap(activeList[index]['title'].toString());
                },
                child: Column(
                  children: [
                    Container(
                      width: double.maxFinite,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: recShadow,
                      ),
                      child: Container(
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: recWhiteColor,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        alignment: Alignment.center,
                        child: Image.asset(
                          activeList[index]['image'].toString(),
                          height: 70,
                        ),
                      ),
                    ),
                    heightBox(height * 0.002),
                    Center(
                      child: SizedBox(
                        width: width * 0.2,
                        child: AutoSizeText(
                            maxLines: 2,
                            activeList[index]['title'].toString(),
                            style: selectedCategory == index
                                ? medium15Primary
                                : medium14Black,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
        // RecentTransactionsWidget(
        //   category: widget.category,
        // )
      ],
    );
  }
}
