import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:mukai/brick/models/saving.model.dart';
import 'package:mukai/core/config/dio_interceptor.dart';
import 'package:get/get.dart';
import 'package:mukai/brick/models/group.model.dart';
import 'package:mukai/brick/models/wallet.model.dart';
import 'package:mukai/constants.dart';

class WalletController {
  final dio = DioClient().dio;
  final setSaving = Saving().obs;
  var isLoading = false.obs;
  var selectedWallet = Wallet().obs;
  Future<List<Wallet>?> getWalletsByProfileID(String userId) async {
    try {
      final response =
          await dio.get('${EnvConstants.APP_API_ENDPOINT}/wallets/$userId');
      // log('getWalletsByProfileID data: ${JsonEncoder.withIndent(' ').convert(response.data)}');
      final List<dynamic> walletList = response.data['data'];
      return walletList.map((item) => Wallet.fromJson(item)).toList();
    } catch (e, s) {
      log('getWalletDetailsByID error: $e $s');
      return null;
    }
  }

  Future<List<Wallet>?> getIndividualWallets(String userId) async {
    try {
      final response = await dio
          .get('${EnvConstants.APP_API_ENDPOINT}/wallets/member/$userId');
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
      final response = await dio
          .get('${EnvConstants.APP_API_ENDPOINT}/groups/$groupId/wallet');
      // log('getWalletsByProfileID data: ${JsonEncoder.withIndent(' ').convert(response.data)}');
      if (response.data != null) {
        // log(response.data['data']);
        return Wallet.fromJson(response.data);
      }
      log(response.data.toString());
      return null;
    } catch (e, s) {
      log('getIndividualWallets error: $e $s');
      return null;
    }
  }

  Future<Wallet?> getWalletLikeID(String id) async {
    log('--------- getWalletLikeID $id ----------');
    try {
      final response =
          await dio.get('${EnvConstants.APP_API_ENDPOINT}/wallet/like/$id');
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

  Future<void> setSavingPlan() async {
    try {
      log('setSavingPlan data: ${setSaving.value.toJson()}');
      final json = await supabase
          .from('savings_plans')
          .insert(setSaving.value.toJson())
          .select()
          .single();
      log('setSavingPlan data: $json');
    } catch (e, s) {
      log('setSavingPlan error: $e $s');
    }
  }
}
