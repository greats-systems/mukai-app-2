import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ri.dart';
import 'package:mukai/brick/models/profile.model.dart';
import 'package:mukai/brick/models/wallet.model.dart';
import 'package:mukai/src/controllers/profile_controller.dart';
// import 'package:mukai/src/apps/profile/controllers/profile_provider.dart';
import 'package:mukai/src/controllers/wallet.controller.dart';
import 'package:mukai/src/routes/app_pages.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/utils/utils.dart';

class AppHeaderWidget extends StatefulWidget {
  final String? title;
  final String? subtitile;
  final String? amount;
  final Widget? widgetButton;
  const AppHeaderWidget(
      {super.key, this.title, this.subtitile, this.amount, this.widgetButton});

  @override
  State<AppHeaderWidget> createState() => _AppHeaderWidgetState();
}

class _AppHeaderWidgetState extends State<AppHeaderWidget> {
  ProfileController get profileController => Get.put(ProfileController());
  final WalletController _walletController = WalletController();
  var totalCartItems = 0;
  var cartTotalAmount = 0.0;
  String store_name = '';
  final GetStorage _getStorage = GetStorage();
  var profile = Profile(full_name: '', id: '');
  late double height;
  late double width;
  late PageController pageController = PageController();
  final tabList = ["Account", "Wallets", "Assets", 'FinMarket'];
  int selectedTab = 0;
  Wallet? wallet;
  Future? _fetchDataFuture;

  Future<void> _fetchData() async {
    try {
      final userId = await _getStorage.read('userId');
      if (!mounted) return;

      final walletData = await _walletController.getWallet(userId);
      if (!mounted) return;

      setState(() => wallet = walletData);
    } catch (e) {
      if (!mounted) return;
      log('Error fetching wallet data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: selectedTab);
    _fetchDataFuture = _fetchData();
  }

  @override
  void dispose() {
    _fetchDataFuture?.ignore();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              profileButton(),
              logoButton(),
            ],
          ),
        ),
        // heightBox(30),
        // Padding(
        //   padding: EdgeInsets.only(left: width * 0.3),
        //   child: Column(
        //     children: [
        //       SizedBox(
        //         width: width,
        //         child: AutoSizeText(
        //           'Your available balance',
        //           style: medium14Black,
        //         ),
        //       ),
        //       height5Space,
        //       Padding(
        //         padding: EdgeInsets.only(left: width * 0.06),
        //         child: SizedBox(
        //           width: width,
        //           child: AutoSizeText(
        //             '\$${(wallet?.balance ?? 0.0).toStringAsFixed(2)}',
        //             style: medium14Black,
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }

  logoButton() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/bottomBar');
      },
      child: Container(
        height: 50.0,
        alignment: Alignment.center,
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/images/logo-nobg.png',
                  height: 50.0,
                ),
              ],
            ),
          ],
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
          Container(
            height: 50.0,
            width: 50.0,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: recColor,
            ),
            alignment: Alignment.center,
            child: const Iconify(
              Ri.account_circle_fill,
              size: 50.0,
              color: whiteColor,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: width * 0.3,
                child: AutoSizeText(
                  '${Utils.trimp(profileController.profile.value.first_name! ?? 'No name')} ${Utils.trimp(profileController.profile.value.last_name!)}',
                  style: medium14Black,
                ),
              ),
              SizedBox(
                width: width * 0.3,
                child: AutoSizeText(
                  Utils.trimp(profileController.profile.value.account_type ??
                      'No account type'),
                  style: medium14Black,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget cartButton() {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.saleOrderDetail);
      },
      child: Stack(
        children: [
          Container(
            height: 40.0,
            width: 60.0,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: primaryColor,
            ),
            alignment: Alignment.bottomCenter,
            child: const Iconify(
              Ri.shopping_cart_line,
              size: 25.0,
              color: whiteColor,
            ),
          ),
          Positioned(
            right: 10,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(15.0),
              ),
              constraints: const BoxConstraints(
                minWidth: 10.0,
                minHeight: 20.0,
              ),
              child: Text(
                '$totalCartItems',
                style: semibold15White.copyWith(color: whiteColor),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
