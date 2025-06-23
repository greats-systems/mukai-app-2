import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:mukai/brick/models/financial_report.model.dart';
import 'package:mukai/constants.dart';

class FinancialReportController {
  final dio = Dio();
  Future<List<FinancialReport>?> getFinancialReport(String walletId) async {
    try {
      final response = await dio
          .get('$APP_API_ENDPOINT/transactions/report/$walletId');
      // final response = await dio
      //     .get('$APP_API_ENDPOINT/transactions/report/individual/$walletId');
      final List<dynamic> json = response.data;
      final report =
          json.map((item) => FinancialReport.fromJson(item)).toList();
      return report;
    } catch (e, s) {
      log('getUserFinancialReport error: $e $s');
      return null;
    }
  }

  Future<List<FinancialReport>?> getCoopFinancialReport(String walletId) async {
    try {
      final response = await dio
          .get('$APP_API_ENDPOINT/transactions/report/$walletId');
      // final response =
      //     await dio.get('$APP_API_ENDPOINT/transactions/report/coop/$walletId');
      final List<dynamic> json = response.data;
      final report =
          json.map((item) => FinancialReport.fromJson(item)).toList();
      return report;
    } catch (e, s) {
      log('getUserFinancialReport error: $e $s');
      return null;
    }
  }
}
