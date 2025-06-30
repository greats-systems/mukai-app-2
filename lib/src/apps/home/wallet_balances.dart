import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mukai/brick/models/group.model.dart';
import 'package:mukai/brick/models/profile.model.dart';
import 'package:mukai/src/apps/home/apps/savings/set_saving.dart';
import 'package:mukai/src/apps/home/widgets/metric_row.dart';
import 'package:mukai/src/controllers/profile_controller.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/widget/loading_shimmer.dart';

class WalletBalancesWidget extends StatefulWidget {
  const WalletBalancesWidget({super.key});

  @override
  State<WalletBalancesWidget> createState() => _WalletBalancesWidgetState();
}

class _WalletBalancesWidgetState extends State<WalletBalancesWidget> {
  ProfileController get profileController => Get.put(ProfileController());
  final GetStorage _getStorage = GetStorage();
  var totalCartItems = 0;
  var cartTotalAmount = 0.0;
  String store_name = '';
  var profile = Profile(full_name: '', id: '');
  late double height;
  late double width;
  int selectedTab = 0;
  String? userId;
  String? role;
  Map<String, dynamic>? userProfile = {};
  Map<String, dynamic>? walletProfile = {};
  List<Map<String, dynamic>>? profileWallets = [];
  List<dynamic>? profileSavingsPortfolios = [];
  Map<String, dynamic>? zigWallet = {};
  Map<String, dynamic>? usdWallet = {};
  double totalSavings = 0.0;
  bool isLoading = false;
  void fetchId() async {
    if (_isDisposed) return;

    setState(() {
      isLoading = true;
      userId = _getStorage.read('userId');
      role = _getStorage.read('account_type');
    });

    final userjson = await profileController.getUserDetails(userId!);
    // final walletJson = await profileController.getWalletDetails(userId!);
    final profileWallets = await profileController.getProfileWallets(userId!);
    final savingsPortfolios =
        await profileController.getProfileSavingsPortfolios(userId!);

    if (_isDisposed) return;
    log('profileWallets: $profileWallets');
    log('savingsPortfolios: $savingsPortfolios');
    // Get sum of current_balance of all savingsPortfolios
    if (savingsPortfolios != null && savingsPortfolios.isNotEmpty) {
      setState(() {
        profileSavingsPortfolios = savingsPortfolios;
      });
      double total = 0.0;
      for (var portfolio in savingsPortfolios) {
        if (portfolio != null && portfolio['current_balance'] != null) {
          try {
            total +=
                double.tryParse(portfolio['current_balance'].toString()) ?? 0.0;
          } catch (e) {
            log('Error parsing current_balance: $e');
          }
        }
      }
      log('Total Savings: $total');
      setState(() {
        totalSavings = total;
      });
    }

    setState(() {
      userProfile = userjson;
      if (profileWallets != null && profileWallets.isNotEmpty) {
        _getStorage.write('profile_wallet_id', profileWallets[0]['id']);
        _getStorage.write(
            'profile_wallet_balance', profileWallets[0]['balance'].toString());
        try {
          zigWallet = profileWallets.firstWhere(
            (element) => element['default_currency']?.toLowerCase() == 'zig',
            orElse: () => {'balance': '0.00', 'default_currency': 'ZIG'},
          );
          usdWallet = profileWallets.firstWhere(
            (element) => element['default_currency']?.toLowerCase() == 'usd',
            orElse: () => {'balance': '0.00', 'default_currency': 'USD'},
          );
          log('zigWallet: $zigWallet');
          log('usdWallet: $usdWallet');
        } catch (e) {
          log('Error finding wallets: $e');
          zigWallet = {'balance': '0.00', 'default_currency': 'ZIG'};
          usdWallet = {'balance': '0.00', 'default_currency': 'USD'};
        }
      } else {
        zigWallet = {'balance': '0.00', 'default_currency': 'ZIG'};
        usdWallet = {'balance': '0.00', 'default_currency': 'USD'};
      }
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchId();
  }

  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 0.0, left: 20, right: 20),
      child: isLoading == true
          ? Container(
              height: height * 0.3,
              width: width * 0.9,
              padding: EdgeInsets.all(16),
              child: LoadingShimmerWidget())
          : Container(
              height: height * 0.3,
              width: width * 0.9,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MetricRow(
                      icon: "assets/icons/Vector.png",
                      title: 'Your Wallet balances',
                      zigValue: '${zigWallet?['balance'] ?? '0.00'}',
                      usdValue: '\$${usdWallet?['balance'] ?? '0.00'}',
                    ),
                    SizedBox(height: 10),
                    Container(
                      color: whiteF5Color.withOpacity(0.5),
                      width: width * 0.5,
                      height: 1.5,
                    ),
                    SizedBox(height: 10),
                    MetricRow(
                      icon: "assets/icons/mdi_account-payment-outline.png",
                      title: 'Total Wallet CashOut',
                      zigValue: '${zigWallet?['balance'] ?? '0.00'}',
                      usdValue: '\$${usdWallet?['balance'] ?? '0.00'}',
                    ),
                    heightBox(20),
                    if (profileSavingsPortfolios != null &&
                        profileSavingsPortfolios!.isNotEmpty)
                      Column(
                        spacing: 5,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: LinearProgressIndicator(
                              value: 0.95,
                              minHeight: 10,
                              borderRadius: BorderRadius.circular(5),
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(tertiaryColor),
                              backgroundColor: Colors.grey[200],
                            ),
                          ),
                          Center(
                            child: Text(
                              '\$${totalSavings} in Savings Portfolio',
                              style: TextStyle(
                                color: whiteColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      Center(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'You have no Savings Portfolio',
                                  style: TextStyle(
                                    color: whiteColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  Icons.warning_amber_outlined,
                                  color: Colors.yellow,
                                  size: 20,
                                ),
                              ],
                            ),
                            SizedBox(width: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: tertiaryColor,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                textStyle: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                Get.to(
                                  () => SetSavingsScreen(group: Group()),
                                );
                              },
                              child: Text('Create Portfolio'),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
