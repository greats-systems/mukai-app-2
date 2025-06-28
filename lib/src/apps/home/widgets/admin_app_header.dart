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
  String? role;
  Map<String, dynamic>? userProfile = {};
  bool _isLoading = false;

  Future<void> fetchProfile() async {
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
    log('AdminAppHeaderWidget userProfile: $userProfile');
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
            child: LoadingShimmerWidget(),
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
        height: 90.0,
        width: 90.0,
        // decoration: BoxDecoration(
        //   boxShadow: [
        //     BoxShadow(
        //       color: whiteF5Color,
        //       blurRadius: 10.0,
        //       offset: const Offset(0, 0),
        //     )
        //   ],
        //   shape: BoxShape.circle,
        //   color: whiteF5Color.withOpacity(0),
        // ),
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
                  '${Utils.trimp(profileController.profile.value.first_name ?? 'No name')} ${Utils.trimp(profileController.profile.value.last_name ?? 'No name')}',
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
}
