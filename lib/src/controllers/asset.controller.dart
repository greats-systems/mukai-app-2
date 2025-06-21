import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:mukai/brick/models/asset.model.dart';
import 'package:mukai/brick/models/group.model.dart';
import 'package:mukai/constants.dart';
import 'package:mukai/utils/helper/helper_controller.dart';

class AssetController {
  final selectedAsset = Rx<Asset?>(null);
  var selectedGroup = Rx<Group?>(null);
  final isLoading = Rx<bool>(false);
  final asset = Asset().obs;
  final dio = Dio();

  Future<List<Asset>?> getGroupAssets(String groupId) async {
    List<Asset> assets = [];

    try {
      isLoading.value = true;
      log('getGroupAssets: $groupId');
      final response = await dio.get('$APP_API_ENDPOINT/assets/group/$groupId');
      if (response.statusCode == 200) {
        isLoading.value = false;
        var data = response.data['data'];
        log('getGroupAssets response: $data');
        if (data.isNotEmpty) {
          var assets_list = await Future.value(
              List<Asset>.from(data.map((e) => Asset.fromJson(e))));
          log('getGroupAssets assets: $assets_list');
          assets = assets_list;
          return assets;
        } else {
          isLoading.value = false;
          return assets;
        }
      } else {
        isLoading.value = false;
        await Helper.errorSnackBar(
            title: 'Asset Fetch Failed',
            message: response.data['message'],
            duration: 5);
        return assets;
      }
    } catch (e) {
      log('getGroupAssets error: $e');
      isLoading.value = false;
      await Helper.errorSnackBar(
          title: 'Asset Fetch Failed', message: e.toString(), duration: 5);
      return assets;
    }
  }

  Future<List<Asset>?> getMemberAssets(String profileId) async {
    List<Asset> assets = [];

    try {
      isLoading.value = true;
      log('getMemberAssets: $profileId');
      final response =
          await dio.get('$APP_API_ENDPOINT/assets/profile/$profileId');
      if (response.statusCode == 200) {
        isLoading.value = false;
        var data = response.data['data'];
        log('getGroupAssets response: $data');
        if (data.isNotEmpty) {
          var assets_list = await Future.value(
              List<Asset>.from(data.map((e) => Asset.fromJson(e))));
          log('getGroupAssets assets: $assets_list');
          assets = assets_list;
          return assets;
        } else {
          isLoading.value = false;
          return assets;
        }
      } else {
        isLoading.value = false;
        await Helper.errorSnackBar(
            title: 'Asset Fetch Failed',
            message: response.data['message'],
            duration: 5);
        return assets;
      }
    } catch (e) {
      log('getGroupAssets error: $e');
      isLoading.value = false;
      await Helper.errorSnackBar(
          title: 'Asset Fetch Failed', message: e.toString(), duration: 5);
      return assets;
    }
  }

  Future<List<Asset>?> getAssetByID(String assetId) async {
    List<Asset> assets = [];

    try {
      isLoading.value = true;
      log('getAssetByID: $assetId');
      final response = await dio.get('$APP_API_ENDPOINT/assets/$assetId');
      if (response.statusCode == 200) {
        isLoading.value = false;
        var data = response.data['data'];
        log('getAssetByID response: $data');
        if (data.isNotEmpty) {
          var assets_list = await Future.value(
              List<Asset>.from(data.map((e) => Asset.fromJson(e))));
          log('getAssetByID assets: $assets_list');
          assets = assets_list;
          return assets;
        } else {
          isLoading.value = false;
          return assets;
        }
      } else {
        isLoading.value = false;
        await Helper.errorSnackBar(
            title: 'Asset Fetch Failed',
            message: response.data['message'],
            duration: 5);
        return assets;
      }
    } catch (e) {
      log('getGroupAssets error: $e');
      isLoading.value = false;
      await Helper.errorSnackBar(
          title: 'Asset Fetch Failed', message: e.toString(), duration: 5);
      return assets;
    }
  }

  Future<void> updateAsset(String assetId) async {
    log('deleteAsset: $assetId');

    try {
      final response =
          await dio.put('$APP_API_ENDPOINT/assets/$assetId', data: {
        "asset_descriptive_name": asset.value?.assetDescriptiveName ?? '',
        "asset_description": asset.value?.assetDescription ?? '',
        "status": "active",
        "valuation_currency": asset.value?.valuationCurrency ?? 'USD',
        "fiat_value": double.parse(asset.value?.fiatValue.toString() ?? '0'),
        "token_value": double.parse(asset.value?.tokenValue.toString() ?? '0'),
      });
      if (response.statusCode == 200) {
        await Helper.successSnackBar(
            title: 'Asset Updated',
            message: response.data['message'],
            duration: 5);
        Get.back();
      }
    } catch (e) {
      log('updateAsset error: $e');
      await Helper.errorSnackBar(
          title: 'Asset Update Failed', message: e.toString(), duration: 5);
    }
  }

  Future<void> deleteAsset(String assetId) async {
    log('deleteAsset: $assetId');
    try {
      final response = await dio.delete('$APP_API_ENDPOINT/assets/$assetId');
      if (response.statusCode == 200) {
        await Helper.successSnackBar(
            title: 'Asset Deleted',
            message: response.data['message'],
            duration: 5);
        Get.back();
      }
    } catch (e) {
      log('deleteAsset error: $e');
      await Helper.errorSnackBar(
          title: 'Asset Deletion Failed', message: e.toString(), duration: 5);
    }
  }

  Future<void> createAsset(
      String? groupId, String? profileId, String ownershipType) async {
    // final groupJson = await supabase.from('cooperatives').select('id').eq('name', value)
    try {
      var assetData = {
        "asset_descriptive_name": asset.value.assetDescriptiveName,
        "asset_description": asset.value.assetDescription,
        "status": "active",
        "valuation_currency": asset.value.valuationCurrency ?? 'USD',
        "fiat_value": double.parse(asset.value.fiatValue.toString() ?? '0'),
        "token_value": double.parse(asset.value.fiatValue.toString() ?? '0'),
        "asset_images": null,
        "last_transaction_timestamp": null,
        "verifiable_certificate_issuer_id": null,
        "governing_board": null,
        "holding_account": null,
        "legal_documents": null,
        "has_verifiable_certificate": false,
        "is_valuated": false,
        "is_minted": false,
        "is_shared": false,
        "is_active": false,
        "has_documents": false,
        "profile_id": ownershipType == 'group' ? null : profileId,
        'group_id': ownershipType == 'group' ? groupId : null,
        "has_received_vote":false,
      };
      log('assetData: $assetData');
      final response =
          await dio.post('$APP_API_ENDPOINT/assets', data: assetData);
      if (response.statusCode == 201) {
        await Helper.successSnackBar(
            title: 'Asset Created',
            message: response.data['message'],
            duration: 5);        
      }
    } catch (e) {
      log('getTransactionById error: $e');
      await Helper.errorSnackBar(
          title: 'Asset Creation Failed', message: e.toString(), duration: 5);
    }
  }
}
