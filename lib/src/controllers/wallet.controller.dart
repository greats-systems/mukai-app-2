import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:mukai/brick/models/group.model.dart';
import 'package:mukai/brick/models/wallet.model.dart';
import 'package:mukai/constants.dart';

class WalletController {
  final dio = Dio();
  var selectedWallet = Wallet().obs;
  Future<List<Wallet>?> getWalletsByProfileID(String userId) async {
    try {
      final response = await dio.get('$APP_API_ENDPOINT/wallets/$userId');
      // log('getWalletsByProfileID data: ${JsonEncoder.withIndent(' ').convert(response.data)}');
      final List<dynamic> walletList = response.data['data'];
      return walletList.map((item) => Wallet.fromJson(item)).toList();
    } catch (e, s) {
      log('getWalletDetailsByID error: $e $s');
      return null;
    }
  }

  /*
  Future<Wallet?> getGroupWallet(String userId) async {
    log('getGroupWallet userId: $userId');
    try {
      final json = await dio.get('$APP_API_ENDPOINT/wallets/$userId');
      selectedWallet.value = Wallet.fromJson(json.data);
      log('selectedWallet: ${selectedWallet.value.address}');
      return Wallet.fromJson(json.data);
    } catch (e) {
      log('getWalletDetailsByID error: $e');
      return null;
    }
  }
  */

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
}
