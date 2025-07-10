import 'dart:convert';
import 'dart:developer';


import 'package:get/get.dart';
import 'package:mukai/brick/models/asset.model.dart';
import 'package:mukai/brick/models/group.model.dart';
import 'package:mukai/data/repositories/asset_repository.dart';
import 'package:mukai/utils/helper/helper_controller.dart';

class AssetController extends GetxController {
  final AssetRepository _assetRepo;
  final selectedAsset = Rx<Asset?>(null);
  var selectedGroup = Rx<Group?>(null);
  final isLoading = Rx<bool>(false);
  final asset = Asset().obs;
  final assets = <Asset>[].obs;
  /*
  final dio = Dio();
  final accessToken = GetStorage().read('accessToken');
  */

  AssetController(this._assetRepo);

  Future<List<Asset>?> getGroupAssets(String groupId) async {
    try {
      isLoading(true);
      final result = await _assetRepo.getGroupAssets(groupId);
      assets.assignAll(result as Iterable<Asset>);
      return result;
    } catch (e, s) {
      log('fetchGroupAssets error: $e $s');
      return null;
      // Helper.errorSnackBar(
      //     title: 'fetchGroupAssets Error', message: e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> createAsset() async {
    try {
      var assetData = {
        "asset_descriptive_name": asset.value.assetDescriptiveName,
        "asset_description": asset.value.assetDescription,
        "status": "active",
        "valuation_currency": asset.value.valuationCurrency ?? 'USD',
        "fiat_value": double.parse(asset.value.fiatValue.toString()),
        "token_value": double.parse(asset.value.fiatValue.toString()),
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
        "profile_id":
            asset.value.ownershipType == 'group' ? null : asset.value.profileId,
        'group_id':
            asset.value.ownershipType == 'group' ? asset.value.groupId : null,
        "has_received_vote": false,
      };

      final newAsset = Asset.fromJson(assetData);
      isLoading(true);
      await _assetRepo.createAsset(newAsset);
      assets.add(newAsset);
      // Get.back();
      // Helper.successSnackBar(
      //     title: 'Success', message: 'Asset saved successfully!', duration: 5);
    } catch (e, s) {
      log('addAsset error: $e $s');
      // Helper.errorSnackBar(
      //     title: 'addAsset Error', message: e.toString(), duration: 5);
    } finally {
      isLoading(false);
    }
  }

  /*
  Future<List<Asset>?> getGroupAssets(String groupId) async {
    List<Asset> assets = [];

    try {
      isLoading.value = true;
      log('getGroupAssets: $groupId');
      final response = await dio.get(
          '${EnvConstants.APP_API_ENDPOINT}/assets/group/$groupId',
          options: Options(headers: {
            'apikey': accessToken,
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          }));
      if (response.statusCode == 200) {
        isLoading.value = false;
        var data = response.data['data'];
        log('getGroupAssets response: $data');
        if (data.isNotEmpty) {
          var assets_list = await Future.value(
              List<Asset>.from(data.map((e) => Asset.fromJson(e))));
          log('getGroupAssets assets: $assets_list');
          assets = assets_list;
          MkandoWalletSecureStorage().setGroupAssets(groupId, assets_list);r
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
  */
  Future<List<Asset>?> getMemberAssets(String profileId) async {
    try {
      isLoading(true);
      final result = await _assetRepo.getAssetsByProfile(profileId);
      log('getMemberAssets result: $result');
      if (result.isNotEmpty) {
        assets.assign(result.first);
        return result;
      }
      return null;
    } catch (e, s) {
      log('getMemberAssets error: $e $s');
      return null;
      // Helper.errorSnackBar(
      //     title: 'getMemberAssets Error', message: e.toString(), duration: 5);
    } finally {
      isLoading(false);
    }
  }
  /*
  Future<List<Asset>?> getMemberAssets(String profileId) async {
    List<Asset> assets = [];

    try {
      isLoading.value = true;
      log('getMemberAssets: $profileId');
      final response = await dio.get(
          '${EnvConstants.APP_API_ENDPOINT}/assets/profile/$profileId',
          options: Options(headers: {
            'apikey': accessToken,
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          }));
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
  */

  Future<void> getAssetsByID(String assetId) async {
    try {
      isLoading(true);
      final result = await _assetRepo.getAssetById(assetId);
      if (result != null) {
        assets.assign(result);
      }
    } catch (e, s) {
      log('getAssetsByID error: $e $s');
      // Helper.errorSnackBar(
      //     title: 'getAssetsByID Error', message: e.toString(), duration: 5);
    } finally {
      isLoading(false);
    }
  }

  /*
  Future<List<Asset>?> getAssetByID(String assetId) async {
    List<Asset> assets = [];

    try {
      isLoading.value = true;
      log('getAssetByID: $assetId');
      final response =
          await dio.get('${EnvConstants.APP_API_ENDPOINT}/assets/$assetId',
              options: Options(headers: {
                'apikey': accessToken,
                'Authorization': 'Bearer $accessToken',
                'Content-Type': 'application/json',
              }));
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
    log('updateAsset: $assetId');

    try {
      final response =
          await dio.patch('${EnvConstants.APP_API_ENDPOINT}/assets/$assetId',
              options: Options(headers: {
                'apikey': accessToken,
                'Authorization': 'Bearer $accessToken',
                'Content-Type': 'application/json',
              }),
              data: {
            "asset_descriptive_name": asset.value.assetDescriptiveName ?? '',
            "asset_description": asset.value.assetDescription ?? '',
            "status": "active",
            "valuation_currency": asset.value.valuationCurrency ?? 'USD',
            "fiat_value": double.parse(asset.value.fiatValue.toString()),
            "token_value": double.parse(asset.value.tokenValue.toString()),
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
      final response =
          await dio.delete('${EnvConstants.APP_API_ENDPOINT}/assets/$assetId',
              options: Options(headers: {
                'apikey': accessToken,
                'Authorization': 'Bearer $accessToken',
                'Content-Type': 'application/json',
              }));
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
  */

  Future<void> updateAsset(Asset asset) async {
    try {
      isLoading(true);
      await _assetRepo.updateAsset(asset);
      // Get.back();
    } catch (e, s) {
      log('updateAsset error: $e $s');
    } finally {
      isLoading(false);
    }
  }

  Future<void> createIndividualAsset() async {
    try {
      log('Creating individual asset ${JsonEncoder.withIndent(' ').convert(asset.value.toJson())}');
      isLoading(true);
      // asset.value.id = Uuid().v4(); // Ensure a new ID is generated
      // asset.value.fiatValue = 111;
      asset.value.valuationCurrency ??= 'USD';
      asset.value.createdAt = DateTime.now().toIso8601String();
      await _assetRepo.createIndividualAsset(asset.value);
      // assets.add(asset.value);
      // Get.back();
      // Helper.successSnackBar(
      //     title: 'Success', message: 'Asset saved successfully!', duration: 5);
    } catch (e, s) {
      log('addAsset error: $e $s');
      // Helper.errorSnackBar(
      //     title: 'addAsset Error', message: e.toString(), duration: 5);
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteAsset(Asset asset) async {
    try {
      isLoading(true);
      await _assetRepo.deleteAsset(asset);
      assets.remove(asset);
      Get.back();
      Helper.successSnackBar(
          title: 'Success',
          message: 'Asset deleted successfully!',
          duration: 5);
    } catch (e, s) {
      log('addAsset error: $e $s');
      Helper.errorSnackBar(
          title: 'deleteAsset Error', message: e.toString(), duration: 5);
    } finally {
      isLoading(false);
    }
  }

  /*
  Future<void> createIndividualAsset(String? profileId) async {
    // final groupJson = await supabase.from('cooperatives').select('id').eq('name', value)
    try {
      var assetData = {
        "asset_descriptive_name": asset.value.assetDescriptiveName,
        "asset_description": asset.value.assetDescription,
        "status": "active",
        "valuation_currency": asset.value.valuationCurrency ?? 'USD',
        "fiat_value": double.parse(asset.value.fiatValue.toString()),
        "token_value": double.parse(asset.value.fiatValue.toString()),
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
        "profile_id": profileId,
        "has_received_vote": false,
      };
      log('assetData: $assetData');
      final response =
          await dio.post('${EnvConstants.APP_API_ENDPOINT}/assets/individual',
              data: assetData,
              options: Options(headers: {
                'apikey': accessToken,
                'Authorization': 'Bearer $accessToken',
                'Content-Type': 'application/json',
              }));
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
  

  Future<void> createAsset(
      String? groupId, String? profileId, String ownershipType) async {
    // final groupJson = await supabase.from('cooperatives').select('id').eq('name', value)
    try {
      var assetData = {
        "asset_descriptive_name": asset.value.assetDescriptiveName,
        "asset_description": asset.value.assetDescription,
        "status": "active",
        "valuation_currency": asset.value.valuationCurrency ?? 'USD',
        "fiat_value": double.parse(asset.value.fiatValue.toString()),
        "token_value": double.parse(asset.value.fiatValue.toString()),
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
        "has_received_vote": false,
      };
      log('assetData: $assetData');
      final response = await dio.post('${EnvConstants.APP_API_ENDPOINT}/assets',
          data: assetData,
          options: Options(headers: {
            'apikey': accessToken,
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          }));
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
  */
}
