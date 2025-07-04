import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mukai/brick/models/coop.model.dart';
import 'package:mukai/brick/models/cooperative-member-approval.model.dart';
import 'package:mukai/brick/models/group.model.dart';

import 'package:mukai/constants.dart';

final accessToken = GetStorage().read('access_token');

class CooperativeMemberApprovalsController {
  final selectedCma = Rx<CooperativeMemberApproval?>(null);
  var selectedGroup = Rx<Group?>(null);
  final isLoading = Rx<bool>(false);
  final cma = CooperativeMemberApproval().obs;
  final coop = Cooperative().obs;
  final dio = Dio();
  // final consensusReached = bool().obs;

  Future<void> createPoll() async {
    // cma.value.consensusReached = false;
    try {
      // log(cma.value.toJson().toString());
      final response = await dio.post(
          '${EnvConstants.APP_API_ENDPOINT}/cooperative_member_approvals',
          data: cma.value.toJson());
      log(response.data.toString());
    } catch (e, s) {
      log('createPoll error: $e $s');
    }
  }

  Future<List<CooperativeMemberApproval>?> getCoopPolls(
      String coopId, String userId) async {
    var params = {
      'profile_id': userId,
    };
    try {
      final response = await dio.get(
          '${EnvConstants.APP_API_ENDPOINT}/cooperative_member_approvals/coop/$coopId',
          data: params);
      log('getCoopPolls data: ${response.data.toString()}');

      if (response.data == null) return null;

      final List<dynamic> jsonList =
          response.data is List ? response.data : [response.data];

      final polls = jsonList
          .map((json) {
            try {
              return CooperativeMemberApproval.fromJson(json);
            } catch (e, st) {
              log('Error parsing poll: $e $st');
              return null;
            }
          })
          .whereType<CooperativeMemberApproval>()
          .toList();

      log('Parsed ${polls.length} polls');
      return polls;
    } catch (error, st) {
      log('getCoopPolls error: $error $st');
      return null;
    }
  }

  Future<CooperativeMemberApproval?> viewPollDetails(String pollId) async {
    try {
      final response = await dio.get(
          '${EnvConstants.APP_API_ENDPOINT}/cooperative_member_approvals/$pollId',
          options: Options(headers: {
            'apikey': accessToken,
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          }));
      return response.data;
    } catch (error) {
      log('viewApprovalsDetails error: $error');
      return null;
    }
  }

  Future<Map<String, dynamic>?> updatePoll() async {
    try {
      var data = {
        'group_id': cma.value.groupId,
        'profile_id': cma.value.profileId,
        'additional_info': cma.value.additionalInfo,
        'poll_description': cma.value.pollDescription,
        'supporting_votes': cma.value.supportingVotes,
        'opposing_votes': cma.value.opposingVotes,
        'updated_at': DateTime.now().toIso8601String(),
        // 'consensus_reached': consensusReached,
      };
      // log(data.toString());
      final response = await dio.patch(
        '${EnvConstants.APP_API_ENDPOINT}/cooperative_member_approvals/${cma.value.id}',
        options: Options(headers: {
          'apikey': accessToken,
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        }),
        data: {
          'group_id': cma.value.groupId,
          'profile_id': cma.value.profileId,
          'additional_info': cma.value.additionalInfo,
          'poll_description': cma.value.pollDescription,
          'supporting_votes': cma.value.supportingVotes,
          'opposing_votes': cma.value.opposingVotes,
          'updated_at': DateTime.now().toIso8601String(),
          // 'consensus_reached': consensusReached,
        },
      );

      // log('Poll update response: ${response.data}');
      return response.data;
    } on DioException catch (error) {
      log('Error updating poll: ${error.response?.data}');
      return {
        'error': error.response?.data['message'] ?? 'Failed to update poll'
      };
    }
  }

  Future<Map<String, dynamic>> getPollDetails(String pollId) async {
    try {
      isLoading.value = true;
      final response = await dio.get(
          '${EnvConstants.APP_API_ENDPOINT}/cooperative_member_approvals/$pollId',
          options: Options(headers: {
            'apikey': accessToken,
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          }));
      return response.data;
    } on DioException catch (e) {
      log('Error getting poll details: ${e.response?.data}');
      throw Exception('Failed to load poll details');
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>?> castVote({
    required String groupId,
    required String profileId,
    required String pollId,
    required String pollDescription,
    required String memberId,
    required bool isSupporting,
    required dynamic additionalInfo,
    required bool consensusReahed,
    String? loanId,
    String? assetId,
  }) async {
    try {
      // First get current poll state
      final currentPoll = await dio.get(
          '${EnvConstants.APP_API_ENDPOINT}/cooperative_member_approvals/$pollId',
          options: Options(headers: {
            'apikey': accessToken,
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          }));

      List<dynamic> supportingVotes =
          currentPoll.data['supporting_votes'] ?? [];
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

      var data = {
        'profile_id': profileId,
        'group_id': groupId,
        'poll_description': pollDescription,
        'supporting_votes': supportingVotes,
        'opposing_votes': opposingVotes,
        'updated_at': DateTime.now().toIso8601String(),
        'consensus_reached': consensusReahed,
        'additional_info': additionalInfo,
        'loan_id': loanId,
      };
      // log(data.toString());

      // Update the poll
      final response = await dio.patch(
        '${EnvConstants.APP_API_ENDPOINT}/cooperative_member_approvals/$pollId',
        options: Options(headers: {
          'apikey': accessToken,
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        }),
        data: data,
      );
      return response.data;
    } on DioException catch (error) {
      log('Error casting vote: ${error.response?.data}');
      return {
        'error': error.response?.data['message'] ?? 'Failed to cast vote'
      };
    }
  }
}
