import 'dart:developer';
import 'package:get_storage/get_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mukai/brick/models/transaction.model.dart';
import 'package:mukai/src/apps/home/admin/admin_transaction_detail.dart';
import 'package:mukai/src/apps/home/admin/admin_transaction_item.dart';
import 'package:mukai/src/apps/home/admin/contribution_transaction_item.dart';
import 'package:mukai/src/apps/transactions/controllers/transactions_controller.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/widget/loading_shimmer.dart';

class AccountContributionsTransactionsList extends StatefulWidget {
  const AccountContributionsTransactionsList({super.key});

  @override
  State<AccountContributionsTransactionsList> createState() =>
      _AccountContributionsTransactionsList();
}

class _AccountContributionsTransactionsList
    extends State<AccountContributionsTransactionsList> {
  TransactionController get transactionController =>
      Get.put(TransactionController());
  late Future<List<Transaction>?> _futureTransaction;
  bool refresh = false;
  final GetStorage _getStorage = GetStorage();
  late final Stream<List<Transaction>> _transactionsStream;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return listContent(context);
  }

  listContent(BuildContext context) {
    return StreamBuilder<List<Transaction>>(
      stream: transactionController.streamContributionsTransaction(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData) {
          return const LoadingShimmerWidget();
        }

        // final orders = snapshot.data!;
        List<Transaction> data = snapshot.data!;
        return Container(
          decoration: BoxDecoration(
            color: recWhiteColor,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(40.0)),
            border: Border.all(color: recWhiteColor),
          ),
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount:
                    data.length, // Replace with your marketPlaceProducts count
                itemBuilder: (context, index) {
                  Transaction transaction = data[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        log('Transaction tapped');
                        Get.to(() =>
                            AdminTransactionDetail(transaction: transaction));
                      },
                      child: ContributionTransactionItem(
                        transaction: transaction,
                      ),
                    ),
                  ); // Replace with your ProductCard widget
                },
              )),
        );
      },
    );
  }
}
