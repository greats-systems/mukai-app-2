import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mukai/brick/models/profile.model.dart';
import 'package:mukai/src/bottom_bar.dart';
import 'package:mukai/src/controllers/profile_controller.dart';
import 'package:mukai/theme/theme.dart';

class AdminAppHeaderLogoWidget extends StatefulWidget {
  final String? title;
  final String? subtitile;
  final String? amount;
  final Widget? widgetButton;
  const AdminAppHeaderLogoWidget(
      {super.key, this.title, this.subtitile, this.amount, this.widgetButton});

  @override
  State<AdminAppHeaderLogoWidget> createState() =>
      _AdminAppHeaderLogoWidgetState();
}

class _AdminAppHeaderLogoWidgetState extends State<AdminAppHeaderLogoWidget> {
  ProfileController get profileController => Get.put(ProfileController());
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
  String? role;

  @override
  void initState() {
    pageController = PageController(initialPage: selectedTab);
    role = _getStorage.read('account_type');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;
    return Column(
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
      ],
    );
  }

  logoButton() {
    return GestureDetector(
      onTap: () {
        log('AdminAppHeaderLogoWidget role: $role');
        if (role == 'coop-manager') {
          Get.to(() => BottomBar(
                role: 'admin',
              ));
        }

        // Navigator.pushNamed(context, '/bottomBar');
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
                width: width * 0.5,
                child: AutoSizeText(
                  'Greats Coop',
                  style: regular12whiteF5,
                ),
              ),
              SizedBox(
                width: width * 0.3,
                child: AutoSizeText(
                  'Manager',
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
