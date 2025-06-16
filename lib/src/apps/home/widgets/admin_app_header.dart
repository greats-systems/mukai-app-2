import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ri.dart';
import 'package:mukai/brick/models/profile.model.dart';
import 'package:mukai/src/bottom_bar.dart';
import 'package:mukai/src/controllers/profile_controller.dart';
import 'package:mukai/src/apps/profile/controllers/profile_provider.dart';
import 'package:mukai/src/routes/app_pages.dart';
import 'package:mukai/theme/theme.dart';

class AdminAppHeaderWidget extends StatefulWidget {
  final String? title;
  final String? subtitile;
  final String? amount;
  final Widget? widgetButton;
  const AdminAppHeaderWidget(
      {super.key, this.title, this.subtitile, this.amount, this.widgetButton});

  @override
  State<AdminAppHeaderWidget> createState() => _AdminAppHeaderWidgetState();
}

class _AdminAppHeaderWidgetState extends State<AdminAppHeaderWidget> {
  ProfileController get profileController => Get.put(ProfileController());
  final GetStorage _getStorage = GetStorage();
  var totalCartItems = 0;
  var cartTotalAmount = 0.0;
  String store_name = '';
  var profile = Profile(full_name: '', id: '');
  late double height;
  late double width;
  late PageController pageController = PageController();
  final tabList = ["Account", "Wallets", "Assets", 'FinMarket'];
  int selectedTab = 0;
  String? userId;
  String? role;
  Map<String, dynamic>? userProfile = {};
  Map<String, dynamic>? walletProfile = {};
  bool _isLoading = false;

  /*
  void fetchId() async {
    setState(() {
      userId = _getStorage.read('userId');
    });
    log('AdminAppHeaderWidget userId: $userId');
    final userjson = await profileController.getUserDetails(userId!);
    final walletJson = await profileController.getWalletDetails(userId!);
    setState(() {
      userProfile = userjson;
      walletProfile = walletJson;
    });
    log('AdminAppHeaderWidget userProfile: ${userProfile.toString()}\nwalletProfile: ${walletProfile.toString()}');
  }
  */

  void fetchId() async {
    if (_isDisposed) return;

    setState(() {
      _isLoading = true;
      userId = _getStorage.read('userId');
      role = _getStorage.read('account_type');
    });

    final userjson = await profileController.getUserDetails(userId!);
    final walletJson = await profileController.getWalletDetails(userId!);

    if (_isDisposed) return;

    setState(() {
      userProfile = userjson;
      walletProfile = walletJson;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: selectedTab);
    fetchId();
  }

  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    pageController.dispose(); // Don't forget to dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    profileButton(),
                    logoButton(),
                  ],
                ),
              ),
              heightBox(10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            width: width * 0.4,
                            child: AutoSizeText(
                              'Your balances',
                              style: semibold18WhiteF5,
                            ),
                          ),
                          height5Space,
                          Column(
                            children: [
                              SizedBox(
                                width: width * 0.25,
                                child: Row(
                                  spacing: 2,
                                  children: [
                                    AutoSizeText(
                                      '\$${walletProfile?['balance'] ?? '0.00'}',
                                      style: semibold18WhiteF5,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    AutoSizeText(
                                      'USD',
                                      style: regular12whiteF5,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: width * 0.25,
                                child: Row(
                                  spacing: 2,
                                  children: [
                                    AutoSizeText(
                                      '\$${(walletProfile?['balance'] ?? 0) * 36}',
                                      style: semibold18WhiteF5,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    AutoSizeText(
                                      'ZiG',
                                      style: regular12whiteF5,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        color: whiteF5Color,
                        width: 1.5,
                        height: 75,
                      ),
                      widthBox(20),
                      Column(
                        children: [
                          SizedBox(
                            width: width * 0.4,
                            child: AutoSizeText(
                              'Total Expenses',
                              style: semibold18WhiteF5,
                            ),
                          ),
                          height5Space,
                          SizedBox(
                            width: width * 0.4,
                            child: Row(
                              spacing: 2,
                              children: [
                                AutoSizeText(
                                  '\$10 164.75',
                                  style: semibold18WhiteF5,
                                ),
                                AutoSizeText(
                                  'USD',
                                  style: regular12whiteF5,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: width * 0.4,
                            child: Row(
                              spacing: 2,
                              children: [
                                AutoSizeText(
                                  '\$365 931.00',
                                  style: semibold18WhiteF5,
                                ),
                                AutoSizeText(
                                  'ZiG',
                                  style: regular12whiteF5,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  heightBox(20),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 50.0, left: 30, bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LinearProgressIndicator(
                                value: 0.95,
                                minHeight: 10,
                                borderRadius: BorderRadius.circular(5),
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(primaryColor),
                                backgroundColor: Colors.grey[200],
                              ),
                            ],
                          ),
                        ),
                        heightBox(5),
                        Center(
                          child: Text(
                            '95% Of Paid Subscriptions, Looks Good.',
                            style: regular12whiteF5,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          );
  }

  logoButton() {
    return GestureDetector(
      onTap: () {
        log('AdminAppHeaderWidget\nuserId: $userId\nrole: $role');
        if (role == 'coop-manager') {
          Get.to(() => BottomBar(role: 'admin'));
        } else {
          Get.to(() => BottomBar(
                role: 'member',
              ));
        }
      },
      child: Container(
        height: 55.0,
        width: 55.0,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: whiteF5Color,
              blurRadius: 10.0,
              offset: const Offset(0, 0),
            )
          ],
          shape: BoxShape.circle,
          color: whiteF5Color.withOpacity(0),
        ),
        // alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Image.asset(
            'assets/images/logo-nobg.png',
          ),
        ),
      ),
    );
  }

  profileButton() {
    return GestureDetector(
      onTap: () {
        // Get.to(() => const ProfileScreen());
      },
      child: Row(
        spacing: 15,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: width * 0.3,
                child: AutoSizeText(
                  'Hi, ${userProfile?['first_name'] ?? 'No name'}',
                  style: semibold18WhiteF5,
                ),
              ),
              SizedBox(
                width: width * 0.5,
                child: AutoSizeText(
                  'Greats Coop',
                  style: regular12whiteF5,
                ),
              ),
              SizedBox(
                width: width * 0.3,
                child: AutoSizeText(
                  '${userProfile?['account_type'] ?? 'No name'}',
                  style: regular12whiteF5,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
