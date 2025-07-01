import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mukai/brick/models/asset.model.dart';
import 'package:mukai/brick/models/group.model.dart';
import 'package:mukai/src/apps/groups/views/screens/assets/asset_detail.dart';
import 'package:mukai/src/apps/groups/views/screens/assets/asset_item.dart';
// import 'package:mukai/src/apps/home/widgets/transaction_item.dart';
import 'package:mukai/src/apps/transactions/controllers/transactions_controller.dart';
import 'package:mukai/src/controllers/asset.controller.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/widget/loading_shimmer.dart';

class CoopAssetsWidget extends StatefulWidget {
  final Group group;

  const CoopAssetsWidget({super.key, required this.group});

  @override
  State<CoopAssetsWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<CoopAssetsWidget> {
  TransactionController get transactionController =>
      Get.put(TransactionController());
  AssetController get assetController => Get.put(AssetController());
  late double height;
  late double width;
  String? loggedInUserId;
  String? role;
  List<Asset>? assets = [];
  bool _isLoading = true;

  void _fetchGroupMembers() async {
    setState(() => _isLoading = true);
    try {
      var assets_list =
          await assetController.getGroupAssets(widget.group.id ?? '');
      setState(() {
        assets = assets_list;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
      log('Error fetching members: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    loggedInUserId = GetStorage().read('userId');
    role = GetStorage().read('role');
    _fetchGroupMembers();
    log('CoopAssetsWidget role: $role');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;
    return _isLoading
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
                              group: widget.group,
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
                          margin:
                              const EdgeInsets.symmetric(vertical: fixPadding),
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
                  // MukandoMembersListTile(groupMember: member);
                },
              );
  }
}
