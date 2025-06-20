import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mukai/brick/models/profile.model.dart';
import 'package:mukai/src/bottom_bar.dart';
import 'package:mukai/src/controllers/profile_controller.dart';
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
  late double height;
  late double width;
  String? userId;
  String? role;
  Map<String, dynamic>? userProfile = {};
  bool _isLoading = false;
  
  void fetchProfile() async {
    if (_isDisposed) return;
    setState(() {
      _isLoading = true;
      userId = _getStorage.read('userId');
      role = _getStorage.read('account_type');
    });

    final userjson = await profileController.getUserDetails(userId!);

    if (_isDisposed) return;
    setState(() {
      userProfile = userjson;
      _isLoading = false;
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
