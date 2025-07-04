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
import 'package:mukai/theme/theme.dart';
import 'package:mukai/utils/utils.dart';
import 'package:mukai/widget/loading_shimmer.dart';

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
  late double height;
  late double width;
  String? userId;
  String? firstName;
  String? lastName;
  String? phone;
  String? email;
  String? role;

  Future<void> fetchProfile() async {
    if (_isDisposed) return;
    var _Id = await _getStorage.read('userId');
    var _Role = await _getStorage.read('role');
    var _firstName = await _getStorage.read('first_name');
    var _lastName = await _getStorage.read('last_name');
    var _phone = await _getStorage.read('phone');
    var _email = await _getStorage.read('email');
    setState(() {
      userId = _Id;
      role = _Role;
      firstName = _firstName;
      lastName = _lastName;
      phone = _phone;
      email = _email;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
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
        height: 90.0,
        width: 90.0,
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
                  '${Utils.trimp(firstName ?? '')} ${Utils.trimp(lastName ?? '')}',
                  style: medium14Black,
                ),
              ),
              SizedBox(
                width: width * 0.3,
                child: AutoSizeText(
                  Utils.trimp(role ?? ''),
                  style: medium14Black,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
