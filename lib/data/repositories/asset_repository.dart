import 'dart:developer';

import 'package:brick_core/core.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mukai/brick/models/asset.model.dart';
import 'package:mukai/brick/repository.dart';
import 'package:mukai/constants.dart';
import 'package:mukai/utils/helper/helper_controller.dart';

class AssetRepository {
  final MyRepository _repository;
  final Dio _dio;

  AssetRepository(this._repository, this._dio);

  Future<List<Asset>> getGroupAssets(String groupId) async {
    try {
      // 1. First try to get from local storage
      final localAssets = await _repository.get<Asset>(
        query: Query.where('groupId', groupId),
      );

      if (localAssets.isNotEmpty) {
        // Return cached data immediately while fetching fresh data
        _fetchAndUpdateGroupAssets(groupId);
        return localAssets;
      }

      // 2. If no local data, fetch from network
      return await _fetchAndUpdateGroupAssets(groupId);
    } catch (e, s) {
      log('getGroupAssets error: $e $s');
      return [];
    }
  }

  Future<List<Asset>> _fetchAndUpdateGroupAssets(String groupId) async {
    try {
      final response = await _dio.get(
        '${EnvConstants.APP_API_ENDPOINT}/assets/group/$groupId',
        options: Options(
          headers: getHeaders(),
          sendTimeout: const Duration(seconds: 15),
        ),
      );

      final apiAssets =
          List<Asset>.from(response.data['data'].map((e) => Asset.fromJson(e)));

      // Update local storage
      for (var asset in apiAssets) {
        log('upsert asset: ${asset.id}');
        await _repository.upsert<Asset>(asset);
      }

      return apiAssets;
    } catch (e, s) {
      log('_fetchAndUpdateGroupAssets error: $e $s');
      rethrow;
    }
  }

  Future<void> createAsset(Asset asset) async {
    try {
      // 1. First save to local storage
      await _repository.upsert<Asset>(asset);

      // 2. Try to sync with server
      // await _dio.post(
      //   '${EnvConstants.APP_API_ENDPOINT}/assets',
      //   data: asset.toJson(),
      //   options: Options(headers: getHeaders()),
      // );
    } catch (e, s) {
      log('createAsset error: $e $s');
      // The asset remains in local storage and can be synced later
      throw Exception('Failed to create asset. Changes saved locally.');
    }
  }

  Future<void> createIndividualAsset(Asset asset) async {
    try {
      // 1. First save to local storage
      log('Asset to create: ${asset.toJson().toString()}');
      await _repository.upsert<Asset>(asset);

      // 2. Try to sync with server if uploaded to local storage
      // await _dio.post(
      //   '${EnvConstants.APP_API_ENDPOINT}/assets/individual',
      //   data: asset.toJson(),
      //   options: Options(headers: getHeaders()),
      // );
    } catch (e, s) {
      log('createIndividualAsset error: $e $s');
      // The asset remains in local storage and can be synced later
      throw Exception('Failed to create asset. Changes saved locally.');
    }
  }

  Future<List<Asset>> getAssetsByProfile(String profileId) async {
    try {
      log('fetching from local storage for profile: $profileId');
      // 1. First try to get from local storage
      final localAssets = await _repository.get<Asset>(
        query: Query.where('profileId', profileId),
      );
      log('local assets count: ${localAssets.length}');

      if (localAssets.isNotEmpty) {
        log('found local assets for profile: $profileId');
        return localAssets;
      }

      // 2. If no local data, fetch from network
      log('no local assets found, fetching from network for profile: $profileId');
      return await _fetchAndUpdateIndividualAssets(profileId);
    } catch (e, s) {
      log('getIndividualAssets error: $e $s');
      return [];
    }
  }

  Future<List<Asset>> _fetchAndUpdateIndividualAssets(String profileId) async {
    try {
      final response = await _dio.get(
        '${EnvConstants.APP_API_ENDPOINT}/assets/profile/$profileId',
        options: Options(
          headers: getHeaders(),
          sendTimeout: const Duration(seconds: 30),
        ),
      );

      final apiAssets =
          List<Asset>.from(response.data['data'].map((e) => Asset.fromJson(e)));

      // Update local storage
      for (var asset in apiAssets) {
        log('upsert asset: ${asset.id}');
        await _repository.upsert<Asset>(asset);
      }

      return apiAssets;
    } catch (e, s) {
      log('_fetchAndUpdateIndividualAssets error: $e $s');
      rethrow;
    }
  }

  Future<Asset?> getAssetById(String id) async {
    try {
      log('Fetcching asset $id from local storage');
      // 1. First try to get from local storage
      final localAssets = await _repository.get<Asset>(
        query: Query.where('id', id),
      );

      if (localAssets.isNotEmpty) {
        // Return cached data immediately while fetching fresh data
        log('Found local asset: ${localAssets.first.id}');
        // _fetchAndUpdateAsset(id);
        return localAssets.first;
      }

      // 2. If no local data, fetch from network
      return await _fetchAndUpdateAsset(id);
    } catch (e, s) {
      log('getIndividualAssets error: $e $s');
      return null;
    }
  }

  Future<Asset>? _fetchAndUpdateAsset(String id) async {
    try {
      final response = await _dio.get(
        '${EnvConstants.APP_API_ENDPOINT}/assets/$id',
        options: Options(
          headers: getHeaders(),
          sendTimeout: const Duration(seconds: 15),
        ),
      );

      final apiAsset = Asset.fromJson(response.data['data']);

      // Update local storage
      log('upsert asset: ${apiAsset.id}');
      await _repository.upsert<Asset>(apiAsset);

      return apiAsset;
    } catch (e, s) {
      log('_fetchAndUpdateAsset error: $e $s');
      rethrow;
    }
  }

  Future<void> saveAsset(Asset asset) async {
    await _repository.upsert<Asset>(asset);
  }

  Future<void> updateAsset(Asset asset) async {
    try {
      final response = await _dio.patch(
          '${EnvConstants.APP_API_ENDPOINT}/assets/${asset.id}',
          options: Options(headers: getHeaders()));
      if (response.statusCode == 200) {
        await Helper.successSnackBar(
            title: 'Asset Updated',
            message: response.data['message'],
            duration: 5);
        Get.back();
      }
    } catch (e, s) {
      log('updateAsset error, $e $s');
      await _repository.upsert<Asset>(asset);
    }
  }

  Future<void> deleteAsset(Asset asset) async {
    try {
      final response = await _dio.delete(
          '${EnvConstants.APP_API_ENDPOINT}/assets/${asset.id}',
          options: Options(headers: getHeaders()));
      if (response.statusCode == 200) {
        await Helper.successSnackBar(
            title: 'Asset Deleted',
            message: response.data['message'],
            duration: 5);
        Get.back();
      }
    } catch (e, s) {
      log('deleteAsset error, $e $s');
      await _repository.delete<Asset>(asset);
    }
  }
}
