import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mukai/brick/models/financial_report.model.dart';
import 'package:mukai/constants.dart';

class FinancialReportController {
  final accessToken = GetStorage().read('access_token');
  final dio = Dio();
  Future<List<FinancialReport>?> getFinancialReport(String walletId) async {
    try {
      final response = await dio.get(
          '${EnvConstants.APP_API_ENDPOINT}/transactions/report/$walletId',
          options: Options(headers: {
            'apikey': accessToken,
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          }));
      // final response = await dio
      //     .get('${EnvConstants.APP_API_ENDPOINT}/transactions/report/individual/$walletId');
      final List<dynamic> json = response.data;
      final report =
          json.map((item) => FinancialReport.fromJson(item)).toList();
      return report;
    } catch (e, s) {
      log('getUserFinancialReport error: $e $s');
      return null;
    }
  }

  Future<List<FinancialReport>?> getUSDFinancialReport(String walletId) async {
    try {
      final List<dynamic> usdComponent;
      final response = await dio.get(
          '${EnvConstants.APP_API_ENDPOINT}/transactions/report/$walletId',options: Options(headers: {
                'apikey': accessToken,
                'Authorization': 'Bearer $accessToken',
                'Content-Type': 'application/json',
              }));
      // final response =
      //     await dio.get('${EnvConstants.APP_API_ENDPOINT}/transactions/report/coop/$walletId');
      final List<dynamic> json = response.data;
      final report =
          json.map((item) => FinancialReport.fromJson(item)).toList();
      return report;
    } catch (e, s) {
      log('getUserFinancialReport error: $e $s');
      return null;
    }
  }

  Future<List<FinancialReport>?> getZIGFinancialReport(String walletId) async {
    try {
      final response = await dio.get(
          '${EnvConstants.APP_API_ENDPOINT}/transactions/report/$walletId',options: Options(headers: {
                'apikey': accessToken,
                'Authorization': 'Bearer $accessToken',
                'Content-Type': 'application/json',
              }));
      // final response =
      //     await dio.get('${EnvConstants.APP_API_ENDPOINT}/transactions/report/coop/$walletId');
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
