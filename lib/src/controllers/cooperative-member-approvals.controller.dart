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
  try {
    final response = await dio.patch(
      '${EnvConstants.APP_API_ENDPOINT}/cooperative_member_approvals/${cma.value.id}',
      data: {
        'supporting_votes': cma.value.supportingVotes,
        'opposing_votes': cma.value.opposingVotes,
        'updated_at': DateTime.now().toIso8601String(),
      },
    );
    
    log('Poll update response: ${response.data}');
    return response.data;
  } on DioException catch (error) {
    log('Error updating poll: ${error.response?.data}');
    return {'error': error.response?.data['message'] ?? 'Failed to update poll'};
  }
}

Future<Map<String, dynamic>> getPollDetails(String pollId) async {
    try {
      isLoading.value = true;
      final response = await dio.get(
        '${EnvConstants.APP_API_ENDPOINT}/cooperative_member_approvals/$pollId'
      );
      return response.data;
    } on DioException catch (e) {
      log('Error getting poll details: ${e.response?.data}');
      throw Exception('Failed to load poll details');
    } finally {
      isLoading.value = false;
    }
  }

Future<Map<String, dynamic>?> castVote({
  required String pollId,
  required String memberId,
  required bool isSupporting,
}) async {
  try {
    // First get current poll state
    final currentPoll = await dio.get(
      '${EnvConstants.APP_API_ENDPOINT}/cooperative_member_approvals/$pollId'
    );

    List<dynamic> supportingVotes = currentPoll.data['supporting_votes'] ?? [];
    List<dynamic> opposingVotes = currentPoll.data['opposing_votes'] ?? [];

    // Remove from opposite array if exists
    if (isSupporting) {
      opposingVotes.remove(memberId);
    } else {
      supportingVotes.remove(memberId);
    }

    // Add to appropriate array if not already present
    if (isSupporting && !supportingVotes.contains(memberId)) {
      supportingVotes.add(memberId);
    } else if (!isSupporting && !opposingVotes.contains(memberId)) {
      opposingVotes.add(memberId);
    }

    // Update the poll
    final response = await dio.patch(
      '${EnvConstants.APP_API_ENDPOINT}/cooperative_member_approvals/$pollId',
      data: {
        'supporting_votes': supportingVotes,
        'opposing_votes': opposingVotes,
        'updated_at': DateTime.now().toIso8601String(),
      },
    );

    return response.data;
  } on DioException catch (error) {
    log('Error casting vote: ${error.response?.data}');
    return {'error': error.response?.data['message'] ?? 'Failed to cast vote'};
  }
}
}
