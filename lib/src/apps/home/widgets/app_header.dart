import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ri.dart';
import 'package:mukai/brick/models/wallet.model.dart';
import 'package:mukai/src/controllers/profile_controller.dart';
// import 'package:mukai/src/apps/profile/controllers/profile_provider.dart';
import 'package:mukai/src/controllers/wallet.controller.dart';
import 'package:mukai/src/routes/app_pages.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/utils/utils.dart';
import 'package:mukai/widget/loading_shimmer.dart';

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
  Map<String, dynamic>? profile;
  late double height;
  late double width;
  late PageController pageController = PageController();
  final tabList = ["Account", "Wallets", "Assets", 'FinMarket'];
  int selectedTab = 0;
  List<Wallet>? wallet;
  Future? _fetchDataFuture;
  String? role;

  void showRatingDialog() {
    showDialog(
      context: context,
      builder: (context) {
        double rating = 0;
        TextEditingController feedbackController = TextEditingController();
        return AlertDialog(
          title: const Text('Send Feedback'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('How would you rate your experience?'),
              const SizedBox(height: 10),
              StatefulBuilder(
                builder: (context, setState) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () {
                          setState(() {
                            rating = index + 1.0;
                          });
                        },
                      );
                    }),
                  );
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: feedbackController,
                decoration: const InputDecoration(
                  labelText: 'Additional feedback',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // You can handle the feedback submission here
                Navigator.of(context).pop();
                Get.snackbar('Thank you!', 'Your feedback has been submitted.');
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _fetchData() async {
    try {
      final userId = await _getStorage.read('userId');
      if (!mounted) return;
      var _Role = await _getStorage.read('role');
      final profileJson = await profileController.getUserDetails(userId!);
      setState(() {
        role = _Role;
        profile = profileJson;
      });

      final walletData = await _walletController.getWalletsByProfileID(userId);
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
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          profileButton(),
          logoButton(),
          // feedbackButton(),
        ],
      ),
    );
  }

  logoButton() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/bottomBar');
      },
      child: Container(
        height: 70.0,
        alignment: Alignment.center,
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/images/logo-nobg.png',
                  height: 60.0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget profileButton() {
    return GestureDetector(
      onTap: () {
        // Get.to(() => const ProfileScreen());
      },
      child: Row(
        children: [
          const SizedBox(width: 15),
          // Circular profile avatar
          Container(
            height: 50.0,
            width: 50.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: profile?['avatar'] == null ? recColor : Colors.transparent,
            ),
            child: ClipOval(
              child: profile?['avatar'] == null
                  ? const Iconify(
                      Ri.account_circle_fill,
                      size: 50.0,
                      color: whiteColor,
                    )
                  : CachedNetworkImage(
                      imageUrl: profile?['avatar']!,
                      fit: BoxFit.cover,
                      width: 50.0,
                      height: 50.0,
                      placeholder: (context, url) =>
                          const LoadingShimmerWidget(),
                      errorWidget: (context, url, error) => const Iconify(
                        Ri.account_circle_fill,
                        size: 50.0,
                        color: whiteColor,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 15),
          // Name column with first and last name on separate lines
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: AutoSizeText(
                  Utils.trimp(profile?['first_name'] ?? 'No name'),
                  style: medium14Black,
                  maxLines: 1,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: AutoSizeText(
                  Utils.trimp(profile?['last_name'] ?? 'No name'),
                  style: medium14Black,
                  maxLines: 1,
                ),
              ),
              if (role != null && role!.isNotEmpty)
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: AutoSizeText(
                    Utils.trimp(role!),
                    style: medium14Black, // Consider using a smaller, grey style for role
                    maxLines: 1,
                  ),
                ),
            ],
          ),
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
