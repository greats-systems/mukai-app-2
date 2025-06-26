import 'dart:developer';

import 'package:dio/dio.dart';
// import 'package:mukai/brick/models/chat.model.dart';
import 'package:mukai/constants.dart';
import 'package:mukai/brick/models/cooperative-member-request.model.dart';
import 'package:mukai/src/apps/chats/schema/chat.dart';

class ChatController {
  final dio = Dio();
  Future<List<Chat>?> getPendingRequests() async {
    try {
      final response = await dio.get('${EnvConstants.APP_API_ENDPOINT}/chats');
      final json = response.data;
      return json.map((item) => Chat.fromJson(item)).toList();
    } catch (e) {
      log('getPendingRequestserror: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> getPendingRequestDetails(String memberId) async {
    try {
      final response =
          await dio.get('${EnvConstants.APP_API_ENDPOINT}/pendng/$memberId');
      /*
      final response = await supabase
          .from('cooperative_member_requests')
          .select('member_id, profiles(*)')
          .eq('member_id', memberId)
          .single();
          */
      return response.data;
    } catch (e) {
      log('getPendingRequestDetails error: $e');
      return {};
    }
  }

  Future<void> updateRequest(CooperativeMemberRequest request) async {
    request.status = 'approved';
    try {
      if (request.memberId == null) {
        throw Exception('Member ID is required');
      }
      final response = await dio.patch(
          '${EnvConstants.APP_API_ENDPOINT}/cooperative_member_requests/${request.memberId}');
      /*
      final response =
          await supabase.from('cooperative_member_requests').update({
        'status': request.status,
        'resolved_by': request.resolvedBy,
      }).eq('member_id', request.memberId!);
      */
      log('updateRequest data: ${response.data}');
    } catch (e) {
      log('updateRequest error: $e');
    }
  }
}
