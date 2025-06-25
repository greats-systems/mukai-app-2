import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:mukai/brick/models/loan.model.dart';
import 'package:mukai/constants.dart';

class LoanController {
  final dio = Dio();

  Future<void> createLoan(Loan loan) async {
    try {
      final response = await dio.post('$APP_API_ENDPOINT/loans', data: loan);
      log('createLoan data: ${response.data}');
      return;
    } catch (e, s) {
      log('createLoan error: $e $s');
      return;
    }
  }

  Future<List<Loan>?> getProfileLoans(String profileId) async {
    List<Loan>? loans = [];
    try {
      final response =
          await dio.get('$APP_API_ENDPOINT/loans/profile/$profileId');
      final List<dynamic> json = response.data;
      log(json.toString());
      if (json.isNotEmpty) {
        loans = json.map((item) => Loan.fromMap(item)).toList();
        return loans;
      }
      return null;
    } catch (e, s) {
      log('getProfileLoan error: $e $s');
      return null;
    }
  }
}
