import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mukai/brick/models/loan.model.dart';
import 'package:mukai/brick/models/loan.model.dart';
import 'package:mukai/constants.dart';
import 'package:mukai/main.dart';
import 'package:mukai/src/apps/groups/views/screens/members/member_detail.dart';
import 'package:mukai/src/apps/groups/views/widgets/loan_item.dart';
import 'package:mukai/src/apps/groups/views/widgets/member_item.dart';
import 'package:mukai/src/apps/transactions/controllers/transactions_controller.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/widget/loading_shimmer.dart';

class LoansList extends StatefulWidget {
  final String groupId;
  String? category;

  LoansList({super.key, required this.groupId, this.category});

  @override
  State<LoansList> createState() => _LoansListState();
}

class _LoansListState extends State<LoansList> {
  int? selectedCategory;
  // String category = '1 day';
  late double height;
  late double width;

  TransactionController get transactionController =>
      Get.put(TransactionController());
  // LoanController get loanController => Get.put(LoanController());
  late final Stream<List<Loan>> _loansStream;
  String? userId;
  final GetStorage _getStorage = GetStorage();

  @override
  void initState() {
    _fetchId();
    _initializeStream();
    super.initState();
  }

  void _fetchId() async {
    final id = await _getStorage.read('userId');
    setState(() {
      userId = id;
    });
  }

  void _initializeStream() {
    log('Getting loans for user $userId');
    _loansStream = supabase
        .from('loans')
        .stream(primaryKey: ['id'])
        .eq('id', widget.groupId)
        .order('created_at')
        .asyncMap((maps) async {
          List<Loan> loans = [];
          try {
            loans = await Future.wait(
              maps.map((map) async {
                Loan loan = Loan.fromMap(map);
                log('loan ${loan.toJson()}');
                return loan;
              }).toList(),
            );
            return loans;
          } catch (error) {
            log(' loans  error ${error}');
            return loans;
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;
    return body();
  }

  Widget body() {
    return Column(
      children: [
        StreamBuilder<List<Loan>>(
            stream: _loansStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: LoadingShimmerWidget(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              if (snapshot.hasData) {
                final loans = snapshot.data!;
                return loans.isEmpty
                    ? const Center(
                        child: Text('No Loans yet'),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        // physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: loans.length,
                        itemBuilder: (context, index) {
                          Loan loan = loans[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                log('Tapped');
                                /*
                                loanController.selectedLoan.value =
                                    loan;
                                Get.to(() => MemberDetailScreen(
                                      groupId: widget.groupId,
                                      loan: loan,
                                    ));
                                    */
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
                                  padding:
                                      const EdgeInsets.all(fixPadding * 1.5),
                                  margin: const EdgeInsets.symmetric(
                                      vertical: fixPadding),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: whiteColor.withOpacity(0.1),
                                  ),
                                  child: LoanItemWidget(
                                    loan: loan,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
              }
              return preloader;
            }),
      ],
    );
  }
}
