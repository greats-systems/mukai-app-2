import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mukai/brick/models/transaction.model.dart';
import 'package:mukai/src/apps/home/admin/admin_transaction_detail.dart';
import 'package:mukai/src/apps/home/admin/admin_transaction_item.dart';
import 'package:mukai/src/apps/transactions/controllers/transactions_controller.dart';
import 'package:mukai/src/bottom_bar.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/utils/utils.dart';
import 'package:mukai/widget/loading_shimmer.dart';

class TransactionsList extends StatefulWidget {
  const TransactionsList({super.key});

  @override
  State<TransactionsList> createState() => _TransactionsList();
}

class _TransactionsList extends State<TransactionsList> {
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
    return Scaffold(
      appBar: AppBar(
      leading: IconButton(
        onPressed: () => Get.off(()=> BottomBar(index: 2)),
        icon: const Icon(Icons.arrow_back, color: whiteF5Color),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.0)),
      ),
      elevation: 0,
      backgroundColor: primaryColor,
      automaticallyImplyLeading: false,
      centerTitle: false,
      titleSpacing: 20.0,
      toolbarHeight: 70.0,
      title: Text(
        Utils.trimp('Transactions list'),
        style: bold18WhiteF5,
      ),
    ),
      body: StreamBuilder<List<Transaction>>(
        stream: transactionController.streamAccountTransaction(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
      
          if (!snapshot.hasData) {
            return const LoadingShimmerWidget();
          }

          if(snapshot.data!.isEmpty || snapshot.data == null) {
            return Center(
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
                padding: const EdgeInsets.all(16.0),
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
      ),
    );
  }
}
