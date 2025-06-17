import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mukai/brick/models/transaction.model.dart';
import 'package:mukai/constants.dart';
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
        // .eq('category', widget.category)
        .order('created_at')
        .asyncMap((maps) async {
          List<Transaction> transactions = [];
          try {
            transactions = await Future.wait(
              maps.map((map) async {
                Transaction transaction = Transaction.fromJson(map);
                // log('transaction toJson ${transaction.toJson()}');

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
            child: StreamBuilder<List<Transaction>>(
                stream: _transactionsStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final transactions = snapshot.data!;
                    return Column(
                      children: [
                        Expanded(
                          child: transactions.isEmpty
                              ? const Center(
                                  child: Text('No Transaction found'),
                                )
                              : ListView.builder(
                                shrinkWrap: true,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: fixPadding * 1.0,
                                      vertical: fixPadding),
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: transactions.length,
                                  itemBuilder: (context, index) {
                                    Transaction transaction =
                                        transactions[index];
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          log('Transaction tapped');
                                          Get.to(() => AdminTransactionDetail(transaction: transaction));
                                          /*
                                          try {
                                            transactionController
                                                .selectedTransaction
                                                .value = transaction;
                                            Get.toNamed(
                                                Routes.marketDetailScreen);
                                          } catch (e) {
                                            log('Error selecting transaction: $e');
                                            Helper.errorSnackBar(title: 'Error selecting transaction',
                                                message: e.toString(), duration: 5);
                                          }
                                          */
                                        },
                                        child: Container(
                                          width: double.maxFinite,
                                          clipBehavior: Clip.hardEdge,
                                          decoration: BoxDecoration(
                                            color: whiteColor,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            boxShadow: recShadow,
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.all(
                                                fixPadding * 1.5),
                                            margin: const EdgeInsets.symmetric(
                                                vertical: fixPadding),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              color:
                                                  whiteColor.withOpacity(0.1),
                                            ),
                                            child: AdminTransactionItem(
                                              transaction: transaction,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    );
                  } else {
                    return preloader;
                  }
                }),
          )
        ],
      ),
    );
  }
}
