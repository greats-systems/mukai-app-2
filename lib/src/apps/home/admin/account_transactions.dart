import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mukai/brick/models/transaction.model.dart';
import 'package:mukai/src/apps/home/admin/admin_transaction_detail.dart';
import 'package:mukai/src/apps/home/admin/admin_transaction_item.dart';
import 'package:mukai/src/apps/transactions/controllers/transactions_controller.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/utils/utils.dart';
import 'package:mukai/widget/loading_shimmer.dart';

class AccountTransactionsList extends StatefulWidget {
  const AccountTransactionsList({super.key});

  @override
  State<AccountTransactionsList> createState() => _AccountTransactionsList();
}

class _AccountTransactionsList extends State<AccountTransactionsList> {
  TransactionController get transactionController =>
      Get.put(TransactionController());
  bool refresh = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return listContent(context);
  }

  listContent(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    double width = size.width;  
    double height = size.height;
    return StreamBuilder<List<Transaction>>(
      stream: transactionController.streamAccountTransaction(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData) {
          return const LoadingShimmerWidget();
        }

        if(snapshot.data!.isEmpty || snapshot.data == null) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                Utils.trimp('No transactions found'),
                style: regular16Black,
              ),
            );
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
              padding: EdgeInsets.only(top: height/10),
              child: ListView.builder(
                itemCount: data
                    .length, // Replace with your marketPlaceProducts count
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
                      child: AdminTransactionItem(
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
