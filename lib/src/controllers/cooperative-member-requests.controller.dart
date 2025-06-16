import 'dart:convert';
import 'dart:developer';

import 'package:mukai/brick/models/cooperative-member-request.model.dart';
import 'package:mukai/constants.dart';

class CooperativeMemberRequestController {
  Future<List<CooperativeMemberRequest>?> getUnresolvedRequests() async {
    try {
      final response = await supabase
          .from('cooperative_member_requests')
          .select()
          .not('member_id', 'is', null)
          .eq('status', 'unresolved');
      log(JsonEncoder.withIndent(' ').convert(response));
      final requests = response
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
      final response = await supabase
          .from('cooperative_member_requests')
          .select('*, profiles(*)')
          .eq('member_id', memberId)
          .single();
      return response;
    } catch (error) {
      log('viewRequestDetails error: $error');
      return null;
    }
  }

  Future<void> resolveRequest(String memberId) async {
    try {
      final response = await supabase
          .from('cooperative_member_requests')
          .update({'status': 'resolved'}).eq('member_id', memberId);
      log('resolveRequest response: $response');
    } catch (error) {
      log('resolveRequest error: $memberId');
    }
  }
}
