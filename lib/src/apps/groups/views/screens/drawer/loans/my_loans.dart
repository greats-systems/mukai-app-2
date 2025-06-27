import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mukai/brick/models/loan.model.dart';
import 'package:mukai/brick/models/wallet.model.dart';
import 'dart:developer';
import 'package:mukai/src/apps/groups/views/screens/drawer/loans/loan_detail.dart';
import 'package:mukai/src/apps/groups/views/widgets/loan_item.dart';
import 'package:mukai/src/controllers/loan.controller.dart';
import 'package:mukai/src/controllers/wallet.controller.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/widget/loading_shimmer.dart';

class MyLoansScreen extends StatefulWidget {
  const MyLoansScreen({super.key});

  @override
  State<MyLoansScreen> createState() => _LoansScreenState();
}

class _LoansScreenState extends State<MyLoansScreen> {
  final GetStorage _getStorage = GetStorage();
  final WalletController _walletController = WalletController();
  final LoanController _loanController = LoanController();
  List<Wallet>? wallets;
  List<Loan>? loans;
  String? userId;
  String? role;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
  }

  void fetchId() async {
    try {
      final id = await _getStorage.read('userId');
      if (!mounted) return;
      setState(() {
        _isLoading = true;
        userId = id;
      });
      final walletData = await _walletController.getWalletsByProfileID(userId!);
      if (!mounted) return;
      setState(() {
        wallets = walletData;
      });
      final loansData = await _loanController.getProfileLoans(userId!);
      if (!mounted) return;
      setState(() {
        loans = loansData;
      });
    } on Exception catch (e, s) {
      log('LoanLandingPage: $e $s');
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    fetchId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: LoadingShimmerWidget(),
          )
        : loans == null || loans!.isEmpty
            ? Center(
                child: Text('No loans yet'),
              )
            : ListView.builder(
                itemCount: loans!.length,
                itemBuilder: (context, index) {
                  Loan loan = loans![index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        // loanController.selectedLoan.value = loan;
                        Get.to(() => LoanDetailScreen(
                              // groupId: widget.group.id,
                              loan: loan,
                              // isActive: _showActiveMembers,
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
                          padding: const EdgeInsets.all(fixPadding * 1.5),
                          margin:
                              const EdgeInsets.symmetric(vertical: fixPadding),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: whiteColor.withOpacity(0.1),
                          ),
                          child: LoanItemWidget(loan: loan),
                        ),
                      ),
                    ),
                  );
                },
              );
  }
}
