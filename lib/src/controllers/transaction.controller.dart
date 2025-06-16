import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:mukai/brick/models/transaction.model.dart';
import 'package:mukai/constants.dart';

class TransactionController {
  final dio = Dio();
  Future<Transaction?> getTransactionById(String userId) async {
    try {
      final json = await dio.get('$APP_API_ENDPOINT/transactions/$userId');
      return Transaction.fromJson(json.data);
    } catch (e) {
      log('getTransactionById error: $e');
      return null;
    }
  }
}
