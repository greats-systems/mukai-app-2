import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mukai/brick/models/group.model.dart';
import 'package:mukai/brick/models/loan.model.dart';
import 'package:mukai/brick/models/saving.model.dart';
import 'package:mukai/brick/models/wallet.model.dart';
import 'dart:developer';
import 'package:mukai/src/apps/home/apps/loans/loan_detail.dart';
import 'package:mukai/src/apps/groups/views/widgets/loan_item.dart';
import 'package:mukai/src/apps/home/apps/savings/saving_detail.dart';
import 'package:mukai/src/apps/home/apps/savings/saving_item.dart';
import 'package:mukai/src/apps/home/apps/savings/set_saving.dart';
import 'package:mukai/src/controllers/loan.controller.dart';
import 'package:mukai/src/controllers/wallet.controller.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/widget/loading_shimmer.dart';

class MySavingsScreen extends StatefulWidget {
  const MySavingsScreen({super.key});

  @override
  State<MySavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<MySavingsScreen> {
  final GetStorage _getStorage = GetStorage();
  final WalletController walletController = WalletController();
  List<Wallet>? wallets;
  List<Saving>? savings;
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

      final savingsData = await walletController.getProfilePortfolios(userId!);
      if (!mounted) return;
      setState(() {
        savings = savingsData;
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
    if (_isLoading) {
      return Center(child: LoadingShimmerWidget());
    }
    if (savings == null || savings!.isEmpty) {
      return Center(child: Text('No savings yet'));
    }
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: savings!.length,
            itemBuilder: (context, index) {
              Saving saving = savings![index];
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: GestureDetector(
                  onTap: () async {
                    // Await result from detail or set screen
                    var result = await Get.to(() => SavingDetailScreen(
                          saving: saving,
                        ));
                    if (result == true) {
                      fetchId(); // Refresh list if portfolio was updated/unlocked
                    }
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
                      margin: const EdgeInsets.symmetric(vertical: fixPadding),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: whiteColor.withOpacity(0.1),
                      ),
                      child: SavingItemWidget(saving: saving),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
