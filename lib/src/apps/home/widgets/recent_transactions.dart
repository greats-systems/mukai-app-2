import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mukai/brick/models/transaction.model.dart';
import 'package:mukai/constants.dart';
import 'package:mukai/src/apps/home/widgets/transaction_item.dart';
import 'package:mukai/src/apps/transactions/controllers/transactions_controller.dart';
import 'package:mukai/src/routes/app_pages.dart';
import 'package:mukai/theme/theme.dart';

class RecentTransactionsWidget extends StatefulWidget {
  final String category;
  final String? userId;

  const RecentTransactionsWidget({super.key, required this.category, this.userId});

  @override
  State<RecentTransactionsWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<RecentTransactionsWidget> {
  final GetStorage _getStorage = GetStorage();
  TransactionController get transactionController =>
      Get.put(TransactionController());
  Stream<List<Transaction>>? _transactionsStream;
  late double height;
  late double width;
  String? userId;

  void _fetchUserId() async {
    final id = await _getStorage.read('userId');
    log(id);
    setState(() {
      userId = id;
    });
    log('RecentTransactionsWidget userId: $userId');
  }

  @override
  void initState() {
    _fetchUserId();
    log('Getting data for market ${widget.category}');
    if (userId != null) {
      _transactionsStream = supabase
          .from('transactions')
          .stream(primaryKey: ['id'])
          .eq('account_id', userId!)
          // .eq('category', widget.category)
          .order('created_at')
          .asyncMap((maps) async {
            // Process transactions asynchronously
            final transactions = await Future.wait(
              maps.map((map) async {
                Transaction market = Transaction.fromJson(map);
                return market;
              }).toList(),
            );

            return transactions;
          });
    } else {
      log('No user id provided: $userId');
    }

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
                Text('Recent Deposits', style: TextStyle(color: blackColor)),
                Text(
                  'View All',
                  style: TextStyle(color: blackColor),
                ),
              ],
            ),
          ),
          SizedBox(
            height: height * 0.3,
            width: width,
            child: _transactionsStream != null
                ? StreamBuilder<List<Transaction>>(
                    stream: _transactionsStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final transactions = snapshot.data!;
                        return Column(
                          children: [
                            Expanded(
                              child: [].isEmpty
                                  ? const Center(
                                      child: Text('No Transaction found)'),
                                    )
                                  : ListView.builder(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: fixPadding * 1.0,
                                          vertical: fixPadding),
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: [].length,
                                      itemBuilder: (context, index) {
                                        Transaction market =
                                            transactions[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              transactionController
                                                  .selectedTransaction
                                                  .value = market;
                                              Get.toNamed(
                                                  Routes.marketDetailScreen);
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
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: fixPadding),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  color: whiteColor
                                                      .withOpacity(0.1),
                                                ),
                                                child: TransactionItem(
                                                  transaction: market,
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
                    })
                : Center(child: Text('No transactions')),
          )
        ],
      ),
    );
  }
}
