import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mukai/brick/models/asset.model.dart';
import 'package:mukai/src/apps/groups/views/screens/assets/asset_detail.dart';
import 'package:mukai/src/apps/groups/views/screens/assets/asset_item.dart';
// import 'package:mukai/src/apps/home/widgets/transaction_item.dart';
import 'package:mukai/src/apps/transactions/controllers/transactions_controller.dart';
import 'package:mukai/src/controllers/asset.controller.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/widget/loading_shimmer.dart';

class MemberAssetsList extends StatefulWidget {
  const MemberAssetsList({
    super.key,
  });

  @override
  State<MemberAssetsList> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MemberAssetsList> {
  TransactionController get transactionController =>
      Get.put(TransactionController());
  AssetController get assetController => Get.put(AssetController());
  late double height;
  late double width;
  String? loggedInUserId;
  List<Asset>? assets = [];
  bool _isLoading = true;

  void _fetchGroupMembers() async {
    setState(() => _isLoading = true);
    try {
      GetStorage _getStorage = GetStorage();
      final userId = await _getStorage.read('userId');
      var assets_list = await assetController.getMemberAssets(userId);
      setState(() {
        assets = assets_list;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      log('Error fetching members: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    loggedInUserId = GetStorage().read('userId');
    _fetchGroupMembers();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20.0), // Adjust the radius as needed
            ),
          ),
          elevation: 0,
          backgroundColor: primaryColor,
          titleSpacing: 0.0,
          centerTitle: false,
          title: Text(
            "My Account Assets",
            style: semibold18WhiteF5,
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: whiteF5Color,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.toNamed('/asset/create');
          },
          backgroundColor: primaryColor,
          child: const Icon(Icons.add, color: whiteF5Color),
        ),
        body: _isLoading
            ? const Center(child: LoadingShimmerWidget())
            : assets!.isEmpty
                ? const Center(child: Text('No assets found'))
                : ListView.builder(
                    itemCount: assets!.length,
                    itemBuilder: (context, index) {
                      Asset asset = assets![index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            assetController.selectedAsset.value = asset;
                            log('Profile ID: ${asset.id}');
                            Get.to(() => AssetDetailScreen(
                                  asset: asset,
                                ));
                          },
                          child: Container(
                            width: double.maxFinite,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: recShadow,
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(fixPadding * 1.5),
                              margin: const EdgeInsets.symmetric(
                                  vertical: fixPadding),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: whiteColor.withOpacity(0.1),
                              ),
                              child: AssetItemWidget(
                                asset: asset,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ));
  }
}
