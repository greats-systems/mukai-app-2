import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ri.dart';
import 'package:mukai/src/apps/transactions/controllers/transactions_controller.dart';
import 'package:mukai/src/apps/transactions/views/screens/transfers.dart';
import 'package:mukai/theme/theme.dart';

class TransferTransactionScreen extends StatefulWidget {
  const TransferTransactionScreen({super.key});

  @override
  State<TransferTransactionScreen> createState() =>
      _TransferTransactionScreenState();
}

class _TransferTransactionScreenState extends State<TransferTransactionScreen> {
  TransactionController get transactionController =>
      Get.put(TransactionController());
  late double height;
  late double width;

  final activeList = [
    {
      "image": "assets/addAccount/account-16.png",
      "option": 'wallet',
      "category": 'internal',
      "title": "Internal Wallet"
    },
    {
      "image": "assets/addAccount/account-16.png",
      "option": 'ecocash',
      "category": 'mobile_money',
      "title": "Ecocash"
    },
    {
      "image": "assets/addAccount/account-16.png",
      "option": 'innbucks',
      "category": 'money_wallet',
      "title": "InnBucks"
    },
    {
      "image": "assets/addAccount/account-16.png",
      "option": 'Omari',
      "category": 'money_wallet',
      "title": "O'Mari"
    },
    {
      "image": "assets/addAccount/account-16.png",
      "option": 'one_money',
      "category": 'mobile_money',
      "title": "One Money"
    },
    {
      "image": "assets/addAccount/account-16.png",
      "option": 'bank',
      "category": 'zipit',
      "title": "Bank Account"
    },
  ];
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
          backgroundColor: primaryColor,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: whiteF5Color,
            ),
          ),
          centerTitle: false,
          titleSpacing: 20.0,
          toolbarHeight: 70.0,
          title: const SizedBox(
            child: Text(
              'Transfer Transaction',
              style: medium18WhiteF5,
            ),
          ),
        ),
        body: Container(
          color: whiteF5Color,
          child: Column(
            children: [
              heightBox(30),
              SizedBox(
                height: height * 0.5,
                child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(
                      left: fixPadding * 2.0,
                      right: fixPadding * 2.0,
                      bottom: fixPadding * 2.0,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: fixPadding * 2.0,
                            crossAxisSpacing: fixPadding * 2.0,
                            childAspectRatio: 1.5),
                    itemCount: activeList.length,
                    itemBuilder: (context, index) {
                      return listTileWidget(
                          activeList[index]['category'].toString(),
                          activeList[index]['option'].toString(),
                          activeList[index]['title'].toString(),
                          () {});
                    }),
              ),
            ],
          ),
        ));
  }

  Widget divider() {
    return Container(
      width: double.maxFinite,
      height: 1.0,
      color: blackOrignalColor.withOpacity(0.1),
    );
  }

  listTileWidget(String category, String option, String title, Function() onTap,
      {Color color = blackOrignalColor}) {
    return InkWell(
      onTap: () {
        transactionController.selectedTransferOption.value = option;
        transactionController.selectedTransferOptionCategory.value = category;
        transactionController.selectedTransferOption.refresh();
        transactionController.transferTransaction.value.transferCategory =
            category;
        transactionController.transferTransaction.value.transferMode = option;
        log('${transactionController.selectedTransferOptionCategory.value}');
        Get.to(() => TransfersScreen(
              category: category,
            ));
      },
      child: Container(
        width: double.maxFinite,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: recShadow,
        ),
        child: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(fixPadding),
          decoration: BoxDecoration(
            color: recWhiteColor,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: blackOrignalColor.withOpacity(0.3)),
          ),
          alignment: Alignment.center,
          child: Center(
            child: SizedBox(
              width: width,
              child: AutoSizeText(
                  maxLines: 2,
                  title,
                  style: medium14Black,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center),
            ),
          ),
        ),
      ),
    );
  }
}
