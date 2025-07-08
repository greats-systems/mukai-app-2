import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mukai/brick/models/saving.model.dart';

import 'package:get/get.dart';
import 'package:mukai/brick/models/group.model.dart';
import 'package:mukai/brick/models/wallet.model.dart';
import 'package:mukai/constants.dart';
import 'package:mukai/main.dart';
import 'package:mukai/src/apps/home/apps/savings/savings_landing_page.dart';
import 'package:uuid/uuid.dart';

class WalletController {
  final dio = Dio();
  final setSaving = Saving().obs;
  var isLoading = false.obs;
  var unlockPortfolio = false.obs;
  var lockKey = ''.obs;
  var selectedWallet = Wallet().obs;
  final accessToken = GetStorage().read('accessToken');
  Future<List<Wallet>?> getWalletsByProfileID(String userId) async {
    try {
      final response =
          await dio.get('${EnvConstants.APP_API_ENDPOINT}/wallets/$userId',
              options: Options(headers: {
                'apikey': GetStorage().read('accessToken'),
                'Authorization': 'Bearer ${GetStorage().read('accessToken')}',
                'Content-Type': 'application/json',
              }));
      // log('getWalletsByProfileID data: ${JsonEncoder.withIndent(' ').convert(response.data)}');
      final List<dynamic> walletList = response.data['data'];
      return walletList.map((item) => Wallet.fromJson(item)).toList();
    } catch (e, s) {
      log('getWalletDetailsByID error: $e $s');
      return null;
    }
  }

  Future<List<Saving>?> getProfilePortfolios(String userId) async {
    try {
      var walletList = await supabase
          .from('savings_portfolios')
          .select('*')
          .eq('profile_id', userId);
      log('getProfilePortfolios data: $walletList');
      return walletList.map((item) => Saving.fromMap(item)).toList();
    } catch (e, s) {
      log('getProfilePortfolios error: $e $s');
      return null;
    }
  }

  Future<List<Wallet>?> getIndividualWallets(String userId) async {
    // log('--------- getIndividualWallets ${} ----------');
    try {
      final response = await dio.get(
          '${EnvConstants.APP_API_ENDPOINT}/wallets/member/$userId',
          options: Options(headers: {
            'apikey': {EnvConstants.SUPABASE_ROLE_KEY},
            'Authorization': 'Bearer ${EnvConstants.SUPABASE_ROLE_KEY}',
            'Content-Type': 'application/json',
          }));
      // log('getWalletsByProfileID data: ${JsonEncoder.withIndent(' ').convert(response.data)}');
      final List<dynamic> walletList = response.data['data'];
      return walletList.map((item) => Wallet.fromJson(item)).toList();
    } catch (e, s) {
      log('getIndividualWallets error: $e $s');
      return null;
    }
  }

  Future<Wallet?> getGroupWallet(String groupId) async {
    try {
      final response = await dio.get(
          '${EnvConstants.APP_API_ENDPOINT}/groups/$groupId/wallet',
          options: Options(headers: {
            'apikey': accessToken,
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          }));
      // log('getWalletsByProfileID data: ${JsonEncoder.withIndent(' ').convert(response.data)}');
      if (response.data != null) {
        // log(response.data['data']);
        return Wallet.fromJson(response.data);
      }
      log(response.data.toString());
      return null;
    } catch (e, s) {
      log('getGroupWallet error: $e $s');
      return null;
    }
  }

  Future<Wallet?> getWalletLikeID(String id) async {
    log('--------- getWalletLikeID $id ----------');
    try {
      final response =
          await dio.get('${EnvConstants.APP_API_ENDPOINT}/wallets/like/$id',
              options: Options(headers: {
                'apikey': accessToken,
                'Authorization': 'Bearer $accessToken',
                'Content-Type': 'application/json',
              }));
      final dynamic json = response.data;
      log(JsonEncoder.withIndent(' ').convert(json));
      final wallet = Wallet.fromJson(json);
      return wallet;
    } catch (e, s) {
      log('getWalletLikeID error: $e $s');
      return null;
    }
  }

  Future<void> createGroupWallet(String groupId, Group group) async {
    try {
      final json = await supabase
          .from('wallets')
          .insert({'profile_id': group.admin_id, 'is_group_wallet': true})
          .select()
          .single();
      log('createGroupWallet data: $json');
    } catch (e, s) {
      log('createGroupWallet error: $e $s');
    }
  }

  Future<void> unlockSavingPortfolio(
      String portfolioId, String unlockKey) async {
    try {
      isLoading.value = true;
      final json = await supabase
          .from('savings_portfolios')
          .update({'is_locked': false, 'unlock_key': unlockKey})
          .eq('id', portfolioId)
          .select()
          .single();
      log('unlockSavingPortfolio data: $json');
      isLoading.value = false;
      Get.snackbar('Success', 'Portfolio unlocked successfully',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2));
      Get.to(() => SavingsLandingPageScreen(
            group: Group(),
          ));
    } catch (e, s) {
      isLoading.value = false;
      log('unlockSavingPortfolio error: $e $s');
    }
  }

  Future<void> lockSavingPortfolio(String portfolioId) async {
    try {
      isLoading.value = true;
      final json = await supabase
          .from('savings_portfolios')
          .update({'is_locked': true})
          .eq('id', portfolioId)
          .select()
          .single();
      log('lockSavingPortfolio data: $json');
      isLoading.value = false;
      Get.snackbar('Success', 'Portfolio locked successfully',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2));
      Get.to(() => SavingsLandingPageScreen(
            group: Group(),
          ));
    } catch (e, s) {
      isLoading.value = false;
      log('lockSavingPortfolio error: $e $s');
    }
  }

  Future<void> setSavingPlan() async {
    try {
      isLoading.value = true;
      setSaving.value.id = Uuid().v4();
      setSaving.value.isLocked = true;
      setSaving.value.createdAt = DateTime.now().toIso8601String();
      setSaving.value.unlockKey = Uuid().v4().substring(20, 36);
      log('setSavingPlan data: ${setSaving.value.toJson()}');
      final json = await supabase
          .from('savings_portfolios')
          .insert(setSaving.value.toJson())
          .select()
          .single();
      log('setSavingPlan data: $json');
      isLoading.value = false;

      Get.to(() => SavingsLandingPageScreen(
            group: Group(),
          ));
    } catch (e, s) {
      isLoading.value = false;
      log('setSavingPlan error: $e $s');
    }
  }
}
