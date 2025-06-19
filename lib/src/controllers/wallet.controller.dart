import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:mukai/brick/models/group.model.dart';
import 'package:mukai/brick/models/wallet.model.dart';
import 'package:mukai/constants.dart';

class WalletController {
  final dio = Dio();
  var selectedWallet = Wallet().obs;
  Future<Wallet?> getWallet(String userId) async {
    log('getWallet userId: $userId');
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
