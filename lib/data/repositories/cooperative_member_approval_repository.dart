import 'dart:developer';

import 'package:brick_core/core.dart';
import 'package:dio/dio.dart';
import 'package:mukai/brick/models/cooperative-member-approval.model.dart';
import 'package:mukai/brick/repository.dart';
import 'package:mukai/constants.dart';

class CooperativeMemberApprovalRepository {
  final MyRepository _repository;
  final Dio _dio;

  CooperativeMemberApprovalRepository(this._repository, this._dio);

  Future<void> createPoll(CooperativeMemberApproval cma) async {
    try {
      await _repository.upsert<CooperativeMemberApproval>(cma);
    } on Exception catch (e, s) {
      // TODO
      log('createPoll error: $e $s');
    }
  }

  Future<List<CooperativeMemberApproval>?> getCoopPolls(
      CooperativeMemberApproval cma) async {
    try {
      log('Fetching polls from local storage for coopId: ${cma.groupId}');
      final localPolls = await _repository.get<CooperativeMemberApproval>(
        query: Query.where('coopId', cma.groupId),
      );
      if (localPolls.isNotEmpty) {
        log('Found ${localPolls.length} local polls for coopId: ${cma.groupId}');
        return localPolls;
      }
      log('Fetching polls from API for coopId: ${cma.groupId}');
      final apiPolls = await _fetchAndUpdateCoopPolls(cma.groupId!);
      if (apiPolls.isNotEmpty) {
        log('Fetched ${apiPolls.length} polls from API for coopId: ${cma.groupId}');
        // Return the fetched polls
        return apiPolls;
      }
      return null;
    } catch (e, s) {
      log('getCoopPolls error: $e $s');
      return null;
    }
  }

  Future<CooperativeMemberApproval?> viewPollDetails(String pollId) async {
    try {
      log('viewing poll from local storage with id: $pollId');
      final poll = await _repository.get<CooperativeMemberApproval>(
        query: Query.where('id', pollId),
      );
      if (poll.isNotEmpty) {
        log('Found poll in local storage with id: $pollId');
        return poll.first;
      }
      log('viewing poll from API with id: $pollId');
      return await _fetchAndUpdatePoll(pollId);
    } catch (e, s) {
      log('viewPollDetails error: $e $s');
      return null;
    }
  }

  Future<Map<String, dynamic>?> updatePoll(
      CooperativeMemberApproval cma) async {
    try {
      log('Updating poll with id: ${cma.id}');
      final response = await _dio.put(
        '${EnvConstants.APP_API_ENDPOINT}/cooperative_member_approvals/${cma.id}',
        data: cma.toJson(),
        options: Options(
          headers: getHeaders(),
          sendTimeout: const Duration(seconds: 30),
        ),
      );
      log('Poll updated successfully: ${response.data}');
      return response.data;
    } catch (e, s) {
      log('updatePoll error: $e $s');
      return null;
    }
  }

  Future<List<CooperativeMemberApproval>> _fetchAndUpdateCoopPolls(
      String groupId) async {
    try {
      final response = await _dio.get(
        '${EnvConstants.APP_API_ENDPOINT}/cooperative_member_approvals/coop/$groupId',
        options: Options(
          headers: getHeaders(),
          sendTimeout: const Duration(seconds: 30),
        ),
      );

      final apiPolls =
          List<CooperativeMemberApproval>.from(response.data['data']
              .map((json) {
                try {
                  return CooperativeMemberApproval.fromJson(json);
                } catch (e, st) {
                  log('Error parsing poll: $e $st');
                  return null;
                }
              })
              .whereType<CooperativeMemberApproval>()
              .toList());

      // Update local storage
      for (var poll in apiPolls) {
        log('upsert poll: ${poll.id}');
        await _repository.upsert<CooperativeMemberApproval>(poll);
      }

      return apiPolls;
    } catch (e, s) {
      log('_fetchAndUpdateIndividualAssets error: $e $s');
      rethrow;
    }
  }

  Future<CooperativeMemberApproval?> _fetchAndUpdatePoll(String pollId) async {
    try {
      final response = await _dio.get(
        '${EnvConstants.APP_API_ENDPOINT}/cooperative_member_approvals/$pollId',
        options: Options(
          headers: getHeaders(),
          sendTimeout: const Duration(seconds: 30),
        ),
      );

      final poll = CooperativeMemberApproval.fromJson(response.data);
      log('upsert poll: ${poll.id}');
      await _repository.upsert<CooperativeMemberApproval>(poll);
      return poll;
    } catch (e, s) {
      log('_fetchAndUpdatePoll error: $e $s');
      rethrow;
    }
  }

}
