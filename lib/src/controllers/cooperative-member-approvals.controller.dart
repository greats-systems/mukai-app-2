import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:mukai/brick/models/cooperative-member-approval.model.dart';
import 'package:mukai/brick/models/group.model.dart';
import 'package:mukai/core/config/dio_interceptor.dart';
import 'package:mukai/brick/models/cooperative-member-request.model.dart';
import 'package:mukai/constants.dart';

class CooperativeMemberApprovalsController {
  final selectedCma = Rx<CooperativeMemberApproval?>(null);
  var selectedGroup = Rx<Group?>(null);
  final isLoading = Rx<bool>(false);
  final cma = CooperativeMemberApproval().obs;
  final dio = DioClient().dio;

  Future<List<CooperativeMemberApproval>?> getCoopPolls(String coopId) async {
    log('${EnvConstants.APP_API_ENDPOINT}/cooperative_member_approvals/coop/$coopId');
    try {
      final response = await dio.get(
          '${EnvConstants.APP_API_ENDPOINT}/cooperative_member_approvals/coop/$coopId');
      final List<dynamic> json = response.data;
      final polls =
          json.map((item) => CooperativeMemberApproval.fromJson(item)).toList();
      log('getCoopPolls data: ${JsonEncoder.withIndent('').convert(polls)}');
      return polls;
    } catch (error) {
      log('getCoopPolls error: $error');
      return null;
    }
  }

  Future<CooperativeMemberApproval?> viewPollDetails(String pollId) async {
    try {
      final response = await dio.get(
          '${EnvConstants.APP_API_ENDPOINT}/cooperative_member_approvals/$pollId');
      return response.data;
    } catch (error) {
      log('viewApprovalsDetails error: $error');
      return null;
    }
  }

  Future<Map<String, dynamic>?> updatePoll() async {
    // var params = {'status': 'resolved'};
    try {
      final response = await dio.patch(
          '${EnvConstants.APP_API_ENDPOINT}/cooperative_member_approvals/${selectedCma.value?.id}',
          data: selectedCma.toJson());
      log(response.data);
      return {'data': 'poll updated successfully!'};
    } catch (error) {
      log('updatePoll error: $error');
      return null;
    }
  }
}
