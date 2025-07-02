import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mukai/brick/models/group.model.dart';
import 'package:mukai/brick/models/profile.model.dart';
import 'package:mukai/src/apps/home/widgets/metric_row.dart';
import 'package:mukai/src/controllers/profile_controller.dart';
import 'package:mukai/theme/theme.dart';

class PaySubTransDetail extends StatefulWidget {
  final Group? group;
  const PaySubTransDetail({super.key, required this.group});

  @override
  State<PaySubTransDetail> createState() => _PaySubTransDetailState();
}

class _PaySubTransDetailState extends State<PaySubTransDetail> {
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
  Map<String, dynamic>? zigWallet = {};
  Map<String, dynamic>? usdWallet = {};
  bool _isLoading = false;
  void fetchId() async {
    if (_isDisposed) return;

    setState(() {
      _isLoading = true;
      userId = _getStorage.read('userId');
      role = _getStorage.read('account_type');
    });

    final userjson = await profileController.getUserDetails(userId!);
    // final walletJson = await profileController.getWalletDetails(userId!);
    final profileWallets =
        await profileController.getProfileWallets(widget.group?.id ?? userId!);

    if (_isDisposed) return;
    setState(() {
      userProfile = userjson;
      if (profileWallets != null && profileWallets.isNotEmpty) {
        try {
          zigWallet = profileWallets.firstWhere(
            (element) => element['default_currency']?.toLowerCase() == 'zig',
            orElse: () => {'balance': '0.00', 'default_currency': 'ZIG'},
          );
          usdWallet = profileWallets.firstWhere(
            (element) => element['default_currency']?.toLowerCase() == 'usd',
            orElse: () => {'balance': '0.00', 'default_currency': 'USD'},
          );
        } catch (e) {
          log('Error finding wallets: $e');
          zigWallet = {'balance': '0.00', 'default_currency': 'ZIG'};
          usdWallet = {'balance': '0.00', 'default_currency': 'USD'};
        }
      } else {
        zigWallet = {'balance': '0.00', 'default_currency': 'ZIG'};
        usdWallet = {'balance': '0.00', 'default_currency': 'USD'};
      }
      _isLoading = false;
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
      padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
      child: Container(
        height: height * 0.25,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  Column(
                    children: [
                      Text(
                        'Cooperative Name',
                        style: TextStyle(
                          color: whiteColor.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '${widget.group?.name ?? 'No name'}',
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
              Container(
                color: whiteF5Color.withOpacity(0.5),
                width: width,
                height: 1.5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  Column(
                    children: [
                      Text(
                        'Cooperative Subscription Amount',
                        style: TextStyle(
                          color: whiteColor.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '${widget.group?.monthly_sub ?? '0.00'}',
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
              Container(
                color: whiteF5Color.withOpacity(0.5),
                width: width,
                height: 1.5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  Column(
                    children: [
                      Text(
                        'Cooperative Subscription Wallet ID',
                        style: TextStyle(
                          color: whiteColor.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '${widget.group?.wallet_id?.substring(0, 8)}...${widget.group?.wallet_id?.substring(28, 36) ?? 'No wallet id'}',
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
