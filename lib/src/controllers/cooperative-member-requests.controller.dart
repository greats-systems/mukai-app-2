import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mukai/brick/models/cooperative-member-request.model.dart';
import 'package:mukai/constants.dart';

class CooperativeMemberRequestController {
  final accessToken = GetStorage().read('access_token');
  final dio = Dio();
  Future<List<CooperativeMemberRequest>?> getUnresolvedRequests() async {
    try {
      final response =
          await dio.get('${EnvConstants.APP_API_ENDPOINT}/unresolved');
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
          '${EnvConstants.APP_API_ENDPOINT}/cooperative_member_requests/$memberId',options: Options(headers: {
                'apikey': accessToken,
                'Authorization': 'Bearer $accessToken',
                'Content-Type': 'application/json',
              }));
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
          '${EnvConstants.APP_API_ENDPOINT}/cooperative_member_requests/$memberId',options: Options(headers: {
                'apikey': accessToken,
                'Authorization': 'Bearer $accessToken',
                'Content-Type': 'application/json',
              }),
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
