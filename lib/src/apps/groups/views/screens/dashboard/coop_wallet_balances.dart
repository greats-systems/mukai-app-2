import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:mukai/core/config/dio_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mukai/brick/models/group.model.dart';
import 'package:mukai/brick/models/profile.model.dart';
import 'package:mukai/constants.dart';
import 'package:mukai/src/apps/home/widgets/metric_row.dart';
import 'package:mukai/src/controllers/profile_controller.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/widget/messages_shimmer.dart';

class CoopWalletBalancesWidget extends StatefulWidget {
  final Group? group;
  const CoopWalletBalancesWidget({super.key, required this.group});

  @override
  State<CoopWalletBalancesWidget> createState() =>
      _CoopWalletBalancesWidgetState();
}

class _CoopWalletBalancesWidgetState extends State<CoopWalletBalancesWidget> {
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
  Map<String, dynamic>? coopWallet = {};
  Map<String, dynamic>? zigWallet = {};
  Map<String, dynamic>? usdWallet = {};
  bool _isLoading = false;
  final dio = DioClient().dio;
  CancelToken _cancelToken = CancelToken(); // For canceling requests
  int numberOfMembers = 0;

  // Update your fetchId method
  void fetchId() async {
    if (_isDisposed) return;
    final response = await dio.get(
      '${EnvConstants.APP_API_ENDPOINT}/group_members/${widget.group!.id}/members',
      cancelToken: _cancelToken,
    );

    if (!mounted) return;

    setState(() {
      numberOfMembers = response.data.length;
    });
    log('Number of group members: $numberOfMembers');

    try {
      setState(() {
        _isLoading = true;
        userId = _getStorage.read('userId');
        role = _getStorage.read('account_type');
      });

      final response = await dio.get(
          '${EnvConstants.APP_API_ENDPOINT}/wallets/coop/${widget.group?.id ?? 'No wallet ID'}');

      log('Wallet Data: ${response.data}');

      if (response.data['data'] != 'No wallet found') {
        if (response.data != null && response.data['data'] != null) {
          final walletData = response.data['data'];
          setState(() {
            // Create wallet maps based on the currency
            if (walletData['default_currency']?.toLowerCase() == 'usd') {
              usdWallet = {
                'balance': walletData['balance']?.toStringAsFixed(2) ?? '0.00',
                'default_currency': 'USD'
              };
              zigWallet = {'balance': '0.00', 'default_currency': 'ZIG'};
            } else if (walletData['default_currency']?.toLowerCase() == 'zig') {
              zigWallet = {
                'balance': walletData['balance']?.toStringAsFixed(2) ?? '0.00',
                'default_currency': 'ZIG'
              };
              usdWallet = {'balance': '0.00', 'default_currency': 'USD'};
            }

            log('USD Wallet: $usdWallet');
            log('ZIG Wallet: $zigWallet');
          });
        }
      } else {
        log('No wallet');
      }
    } catch (e, s) {
      log('Error fetching wallet data: $e $s');
      setState(() {
        zigWallet = {'balance': '0.00', 'default_currency': 'ZIG'};
        usdWallet = {'balance': '0.00', 'default_currency': 'USD'};
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
    return _isLoading ? LoadingMessagesShimmerWidget() : body();
  }

  Widget body() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
      child: Container(
        height: height * 0.32,
        width: width * 0.9,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Members',
                      style: TextStyle(
                        color: whiteColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$numberOfMembers',
                      style: TextStyle(
                        color: whiteColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              MetricRow(
                icon: "assets/icons/Vector.png",
                title: 'Wallet balances',
                zigValue: '${zigWallet?['balance'] ?? '0.00'}',
                usdValue: '\$${usdWallet?['balance'] ?? '0.00'}',
              ),
              Container(
                color: whiteF5Color.withOpacity(0.5),
                width: width,
                height: 1.5,
              ),
              MetricRow(
                icon: "assets/icons/mdi_account-payment-outline.png",
                title: 'Contributions and Profits Earned',
                zigValue: '${zigWallet?['contributions'] ?? '0.00'}',
                usdValue: '\$${usdWallet?['contributions'] ?? '0.00'}',
              ),
              Container(
                color: whiteF5Color.withOpacity(0.5),
                width: width,
                height: 1.5,
              ),
              MetricRow(
                icon: "assets/icons/mdi_account-payment-outline.png",
                title: 'Withdrawals and Payments',
                zigValue: '${0.0 ?? '0.00'}',
                usdValue: '\$${0.0 ?? '0.00'}',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
