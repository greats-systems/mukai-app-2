import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mukai/src/apps/home/admin/account_transactions.dart';
import 'package:mukai/src/apps/home/transactions_list.dart';
// import 'package:mukai/src/apps/home/widgets/transaction_item.dart';
import 'package:mukai/src/apps/transactions/controllers/transactions_controller.dart';
import 'package:mukai/theme/theme.dart';

class AdminRecentTransactionsWidget extends StatefulWidget {
  final String category;

  const AdminRecentTransactionsWidget({super.key, required this.category});

  @override
  State<AdminRecentTransactionsWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<AdminRecentTransactionsWidget> {
  TransactionController get transactionController =>
      Get.put(TransactionController());
  late double height;
  late double width;
  @override
  void initState() {
    log('Getting transaction filter ${widget.category}');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Recent Transactions',
                    style: TextStyle(color: blackColor)),
                GestureDetector(
                  onTap: () => Get.to(() => TransactionsList()),
                  child: Text(
                    'View All',
                    style: TextStyle(color: blackColor),
                  ),
                ),
              ],
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            child: AccountTransactionsList(),
          )
        ],
      ),
    );
  }
}
