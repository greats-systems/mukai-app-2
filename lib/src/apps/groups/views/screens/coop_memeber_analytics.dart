import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mukai/brick/models/group.model.dart';
import 'package:mukai/brick/models/profile.model.dart';
import 'package:mukai/constants.dart';
import 'package:mukai/src/controllers/profile_controller.dart';
import 'package:mukai/theme/theme.dart';

class CoopMemeberAnalytics extends StatefulWidget {
  final Group? group;
  const CoopMemeberAnalytics({super.key, required this.group});

  @override
  State<CoopMemeberAnalytics> createState() => _CoopMemeberAnalyticsState();
}

class _CoopMemeberAnalyticsState extends State<CoopMemeberAnalytics> {
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
  int numberOfMembers = -10;
  late Dio dio;
  CancelToken _cancelToken = CancelToken(); // For canceling requests

  @override
  void initState() {
    super.initState();
    dio = Dio();
    _fetchData();
  }

  @override
  void dispose() {
    _cancelToken.cancel('Widget disposed'); // Cancel ongoing requests
    super.dispose();
  }

  void _fetchData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      userId = _getStorage.read('userId');
      role = _getStorage.read('account_type');
    });

    try {
      final response = await dio.get(
        '$APP_API_ENDPOINT/group_members/${widget.group!.id}/members',
        cancelToken: _cancelToken,
      );

      if (!mounted) return;

      setState(() {
        numberOfMembers = response.data.length;
      });
      log('Number of group members: $numberOfMembers');

      final userjson = await profileController.getUserDetails(userId!);
      final profileWallets = await profileController.getProfileWallets(
        widget.group?.id ?? userId!,
      );

      if (!mounted) return;

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
    } catch (e) {
      if (e is DioException && e.type == DioExceptionType.cancel) {
        log('Request canceled: ${e.message}');
      } else {
        log('Error fetching data: $e');
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
            child: Container(
              height: height * 0.1,
              width: width * 0.9,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
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
                        value: 2 / 5,
                        minHeight: 10,
                        borderRadius: BorderRadius.circular(5),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(tertiaryColor),
                        backgroundColor: Colors.grey[200],
                      ),
                    ),
                    Center(
                      child: Text(
                        '67% Of $numberOfMembers members paid their subscriptions',
                        style: TextStyle(
                          color: whiteColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
