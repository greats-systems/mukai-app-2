import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mukai/brick/models/cooperative-member-approval.model.dart';
import 'package:mukai/brick/models/group.model.dart';
import 'package:mukai/brick/models/loan.model.dart';
import 'package:mukai/brick/models/profile.model.dart';
import 'package:mukai/brick/models/wallet.model.dart';
import 'package:mukai/constants.dart';
import 'package:mukai/src/controllers/group.controller.dart';

class LoanController extends GetxController {
  final sendingWallet = Wallet().obs;
  final receivingWallet = Wallet().obs;
  final selectedLoan = Loan().obs; // Initialize with empty Loan
  final selectedCoop = Group().obs;
  final selectedPoll = CooperativeMemberApproval().obs;
  final selectedProfile = Profile().obs;
  final isLoading = Rx<bool>(false);
  final isSupporting = Rx<bool>(false);
  final dio = Dio();
  final GroupController groupController = GroupController();
  final accessToken = GetStorage().read('accessToken');

  void calculateRepayAmount() async {
    final principal = selectedLoan.value.principalAmount ?? 0;
    final months = selectedLoan.value.loanTermMonths ?? 0;

    if (principal <= 0 || months <= 0) {
      selectedLoan.value.paymentAmount = 0;
      selectedLoan.refresh();
      return;
    }

    var monthlyRate = await fetchCoopInterestRate(
        selectedCoop.value.id!); // 2% monthly interest
    final repayAmount =
        principal + (principal * num.parse(monthlyRate!.toString()) * months);

    selectedLoan.update((loan) {
      loan?.paymentAmount = repayAmount;
    });
  }

  DateTime calculateDueDate(num months) {
    DateTime today = DateTime.now();

// Calculate next month's date
    DateTime dueDate = DateTime(
      today.year,
      today.month + int.parse(months.toString()), // Adds 1 to current month
      today.day,
    );
    return dueDate;
  }

  Future<double>? fetchCoopInterestRate(String groupId) async {
    try {
      final Group? groupJson = await groupController.getGroupById(groupId);
      return groupJson?.interest_rate ?? 0.0;
    } catch (e, s) {
      dev.log('fetchCoopInterestRate error: $e $s');
      return 0.0;
    }
  }

  Future<Map<String, dynamic>?> createLoan(String userId) async {
    try {
      DateTime today = DateTime.now();

// Calculate next month's date
      DateTime nextMonthDate = DateTime(
        today.year,
        today.month + 1, // Adds 1 to current month
        today.day,
      );
      isLoading.value = true;
      selectedLoan.value.status = 'pending';
      if (selectedLoan.value.loanTermMonths != null) {
        selectedLoan.value.dueDate =
            calculateDueDate(selectedLoan.value.loanTermMonths!)
                .toString()
                .substring(0, 10);
      }
      // selectedLoan.value.remainingBalance = selectedLoan.value.repay;
      // dev.log(JsonEncoder.withIndent(' ').convert(selectedLoan.toJson()));

      final response = await dio.post('${EnvConstants.APP_API_ENDPOINT}/loans',
          data: selectedLoan.toJson(),
          options: Options(headers: {
            'apikey': accessToken,
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          }));
      // dev.log('Loan created: ${response.data}');
      return response.data;
    } catch (e, s) {
      dev.log('Error creating loan: $e', stackTrace: s);
      Get.snackbar('Error', 'Failed to create loan');
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<Loan>?> getProfileLoans(String profileId) async {
    try {
      final response = await dio.get(
          '${EnvConstants.APP_API_ENDPOINT}/loans/profile/$profileId',
          options: Options(headers: {
            'apikey': accessToken,
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          }));
      for (var loan in response.data) {
        dev.log(loan['loan_term_months'].toString());
      }
      return (response.data as List).map((item) => Loan.fromMap(item)).toList();
    } catch (e, s) {
      dev.log('Error fetching loans: $e', stackTrace: s);
      return null;
    }
  }

  Future<List<Loan>?> getCoopLoans(String coopId, String profileId) async {
    var params = {
      'profile_id': profileId,
    };
    try {
      final response =
          await dio.get('${EnvConstants.APP_API_ENDPOINT}/loans/coop/$coopId',
              data: params,
              options: Options(headers: {
                'apikey': accessToken,
                'Authorization': 'Bearer $accessToken',
                'Content-Type': 'application/json',
              }));
      final List<dynamic> json = response.data;
      return json.map((item) => Loan.fromMap(item)).toList();
    } catch (error) {
      dev.log('getCoopLoans error: $error');
      return null;
    }
  }

  Future<Map<String, dynamic>?> updateLoan() async {
    try {
      final response = await dio.patch(
          '${EnvConstants.APP_API_ENDPOINT}/loans/${selectedLoan.value.id}',
          data: selectedLoan.value.toJson(),
          options: Options(headers: {
            'apikey': accessToken,
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          }));
      dev.log(response.data.toString());
      return response.data;
    } catch (error) {
      'updateLoan error: $error';
      return null;
    }
  }

  Future<Map<String, dynamic>?> updateCoopLoan() async {
    try {
      final response = await dio.patch(
          '${EnvConstants.APP_API_ENDPOINT}/loans/coop/${selectedCoop.value.id}',
          data: selectedLoan.value.toJson(),
          options: Options(headers: {
            'apikey': accessToken,
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          }));
      dev.log(response.data.toString());
      return response.data;
    } catch (error) {
      'updateLoan error: $error';
      return null;
    }
  }

  Future<Map<String, dynamic>?> updateLoanApproval() async {
    Map<String, dynamic> params = {};
    if (isSupporting.value) {
      params = {
        'group_id': selectedCoop.value.id,
        'supporting_votes': selectedProfile.value.id,
        'updated_at': DateTime.now().toIso8601String(),
        'loan_id': selectedLoan.value.id,
      };
    } else {
      params = {
        'group_id': selectedCoop.value.id,
        'opposing_votes': selectedProfile.value.id,
        'updated_at': DateTime.now().toIso8601String(),
        'loan_id': selectedLoan.value.id,
      };
    }
    try {
      dev.log(params.toString());
      final response = await dio.patch(
          '${EnvConstants.APP_API_ENDPOINT}/cooperative_member_approvals/coop/${selectedCoop.value.id}/loans',
          data: params,
          options: Options(headers: {
            'apikey': accessToken,
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          }));
      dev.log('updateLoanApproval response: ${response.data.toString()}');
      return response.data;
    } catch (error) {
      'updateLoan error: $error';
      return null;
    }
  }
}
