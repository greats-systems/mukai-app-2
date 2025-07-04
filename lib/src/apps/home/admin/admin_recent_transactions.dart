import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mukai/brick/models/transaction.model.dart';
import 'package:mukai/constants.dart';
import 'package:mukai/main.dart';
import 'package:mukai/src/apps/home/admin/account_transactions.dart';
import 'package:mukai/src/apps/home/admin/admin_transaction_detail.dart';
import 'package:mukai/src/apps/home/admin/admin_transaction_item.dart';
// import 'package:mukai/src/apps/home/widgets/transaction_item.dart';
import 'package:mukai/src/apps/transactions/controllers/transactions_controller.dart';
import 'package:mukai/src/routes/app_pages.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/utils/helper/helper_controller.dart';

class AdminRecentTransactionsWidget extends StatefulWidget {
  final String category;

  const AdminRecentTransactionsWidget({super.key, required this.category});

  @override
  State<AdminRecentTransactionsWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<AdminRecentTransactionsWidget> {
  TransactionController get transactionController =>
      Get.put(TransactionController());
  late final Stream<List<Transaction>> _transactionsStream;
  late double height;
  late double width;
  @override
  void initState() {
    log('Getting transaction filter ${widget.category}');
    _transactionsStream = supabase
        .from('transactions')
        .stream(primaryKey: ['id'])
        .order('created_at')
        .asyncMap((maps) async {
          List<Transaction> transactions = [];
          try {
            transactions = await Future.wait(
              maps.map((map) async {
                Transaction transaction = Transaction.fromJson(map);
                return transaction;
              }).toList(),
            );
            // log('transactions toList ${transactions.toList()}');
            return transactions;
          } catch (error) {
            log('Getting transaction error ${error}');
            return transactions;
          }
        });

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
                Text(
                  'View All',
                  style: TextStyle(color: blackColor),
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
