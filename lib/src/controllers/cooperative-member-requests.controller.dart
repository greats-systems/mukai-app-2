import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:mukai/core/config/dio_interceptor.dart';
import 'package:mukai/brick/models/cooperative-member-request.model.dart';
import 'package:mukai/constants.dart';

class CooperativeMemberRequestController {
  final dio = DioClient().dio;
  Future<List<CooperativeMemberRequest>?> getUnresolvedRequests() async {
    try {
      final response =
          await dio.get('${EnvConstants.APP_API_ENDPOINT}/unresolved');
      /*
      final response = await supabase
          .from('cooperative_member_requests')
          .select()
          .not('member_id', 'is', null)
          .eq('status', 'unresolved');
      log(JsonEncoder.withIndent(' ').convert(response));
      */
      final requests = response.data
          .map((item) => CooperativeMemberRequest.fromJson(item))
          .toList();
      return requests;
    } catch (error) {
      log('getPendingRequests error: $error');
      return null;
    }
  }

  Future<Map<String, dynamic>?> viewRequestDetails(String memberId) async {
    try {
      final response = await dio.get(
          '${EnvConstants.APP_API_ENDPOINT}/cooperative_member_requests/$memberId');
      /*
      final response = await supabase
          .from('cooperative_member_requests')
          .select('*, profiles(*)')
          .eq('member_id', memberId)
          .single();
          */
      return response.data;
    } catch (error) {
      log('viewRequestDetails error: $error');
      return null;
    }
  }

  Future<void> resolveRequest(String memberId) async {
    var params = {'status': 'resolved'};
    try {
      final response = await dio.patch(
          '${EnvConstants.APP_API_ENDPOINT}/cooperative_member_requests/$memberId',
          data: params);
      log(response.data);

      /*
      final response = await supabase
          .from('cooperative_member_requests')
          .update({'status': 'resolved'}).eq('member_id', memberId);
      log('resolveRequest response: $response');
      */
    } catch (error) {
      log('resolveRequest error: $memberId');
    }
  }
}
