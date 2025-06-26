import 'dart:async';
import 'dart:convert';
import 'dart:developer';
// import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:mukai/brick/models/group.model.dart';
import 'package:mukai/brick/models/profile.model.dart';
import 'package:mukai/brick/models/wallet.model.dart';
import 'package:mukai/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GroupController {
  final dio = Dio();
  Future<Map<String, dynamic>> createGroup(Group group) async {
    // log(group.toJson().toString());
    // List<String?> walletIDs = [];
    try {
      final response = await dio
          .patch('${EnvConstants.APP_API_ENDPOINT}/cooperatives', data: group);
      final groupCreated = Group.fromMap(response.data);
      log(groupCreated.toString());
      return {'statusCode': 200, 'message': 'Group created'};
      /*
      final createGroupResponse = await supabase
          .from('group')
          .insert({
            'name': group.name,
            'city': group.city,
            'country': group.country,
            'monthly_sub': group.monthly_sub,
            'members': group.members?.map((m) => m.toMap()).toList(),
            'admin_id': group.admin_id
          })
          .select()
          .single();
      log('createGroupResponse: $createGroupResponse');
      
      for (int i = 0; i < group.members!.length; i++) {
        final groupMemberWalletsJson = await supabase
            .from('wallets')
            .select('id')
            .eq('profile_id', group.members?[i].id ?? '')
            .single();
        walletIDs.add(groupMemberWalletsJson['id']);
      }

      final walletResponse = await supabase
          .from('wallets')
          .insert({
            'profile_id': group.admin_id,
            'balance': 100,
            'default_currency': 'usd',
            'is_group_wallet': true,
            'children_wallets': walletIDs
          })
          .select()
          .single();
      log('walletResponse: $walletResponse');

      for (int i = 0; i < group.members!.length; i++) {
        final updateMemberResponse = await supabase
            .from('cooperative_member_requests')
            .update(
                {'status': 'in a group', 'group_id': createGroupResponse['id']})
            .eq('member_id', group.members?[i].id ?? '')
            .select()
            .single();
        log(updateMemberResponse.toString());
      }
      */
    } catch (e, s) {
      log('createGroup error $e $s');
      return {'error': e};
    }
  }

  Future<List<Group>> getGroups() async {
    try {
      final response = await dio.get('${EnvConstants.APP_API_ENDPOINT}/groups');
      /*
      final response = await supabase
          .from('group')
          .select()
          .order('created_at', ascending: false);
          */

      return response.data.map((data) => Group.fromMap(data)).toList();
    } catch (e, s) {
      log('Error fetching groups: $e\n$s');
      rethrow;
    }
  }

  Future<List<Profile>?> getMukandoGroupMembers(String groupId) async {
    try {
      log('Fetching members for group: $groupId');

      // Make the API request
      final response = await dio.get(
        '${EnvConstants.APP_API_ENDPOINT}/cooperatives/$groupId/members',
        options: Options(
          validateStatus: (status) => status! < 500, // Accept <500 status codes
        ),
      );

      log('Response data: ${response.data}');

      // Handle different response formats
      if (response.data == null) {
        log('No data received in response');
        return null;
      }

      // Process the response data
      if (response.data is List) {
        // Handle array response
        final members = (response.data as List)
            .where((item) => item != null)
            .map((item) => Profile.fromMap(item))
            .toList();
        log('Successfully parsed ${members.length} members');
        return members;
      } else if (response.data is Map) {
        // Handle single object response
        log('Parsing single member response');
        return [Profile.fromMap(response.data)];
      } else {
        log('Unexpected response format: ${response.data.runtimeType}');
        return null;
      }
    } on DioException catch (e) {
      log('Dio error fetching group members: ${e.message}');
      if (e.response != null) {
        log('Status code: ${e.response!.statusCode}');
        log('Response data: ${e.response!.data}');
      }
      return null;
    } on FormatException catch (e) {
      log('Data format error: ${e.message}');
      return null;
    } catch (e, s) {
      log('Unexpected error', error: e, stackTrace: s);
      return null;
    }
  }

  Future<List<Profile>?> getPendingMukandoGroupMembers(String groupId) async {
    try {
      final response = await dio.get(
          '${EnvConstants.APP_API_ENDPOINT}/cooperative_member_requests/$groupId/unresolved');

      log('Pending members raw response: ${response.data}');

      // 1. Check if response data exists
      if (response.data == null || response.data['data'] == null) {
        log('No pending members found for group $groupId');
        return [];
      }

      final responseData = response.data['data'] as List;
      log('Found ${responseData.length} pending member records');

      // 2. Process all members consistently
      final profiles = <Profile>[];

      for (final item in responseData) {
        try {
          if (item['profiles'] != null) {
            final profile = Profile.fromMap(item['profiles']);
            if (profile.id != null) {
              profiles.add(profile);
            }
          }
        } catch (e, s) {
          log('Error processing member record: $item', error: e, stackTrace: s);
        }
      }

      log('Successfully parsed ${profiles.length} pending members');
      return profiles;
    } on DioException catch (e) {
      log('API error fetching pending members: ${e.message}', error: e);
      return null;
    } catch (e, s) {
      log('Unexpected error fetching pending members', error: e, stackTrace: s);
      return null;
    }
  }

  Future<Wallet?> getGroupWallet(String groupId) async {
    try {
      final response =
          await dio.get('${EnvConstants.APP_API_ENDPOINT}/groups/$groupId');
      /*
      final response = await supabase
          .from('wallets')
          .select()
          .eq('profile_id', profileId)
          .eq('is_group_wallet', true)
          .single();
          */
      final walletJson = Wallet.fromJson(response.data);
      // log('getGroupWallet ${JsonEncoder.withIndent(' ').convert(walletJson)}');
      // log(walletJson.id ?? 'No wallet id');
      return walletJson;
    } catch (e, s) {
      log('getGroupWallet error: $e $s');
      return null;
    }
  }

  Future<List<Wallet>?> getChildrenWallets(String walletId) async {
    try {
      final response =
          await dio.get('${EnvConstants.APP_API_ENDPOINT}/wallets/$walletId');
      return response.data.map((wallet) => Wallet.fromJson(wallet)).toList();
      /*
      final walletsIds = await supabase
          .from('wallets')
          .select('children_wallets')
          .eq('profile_id', parentWalletId)
          .single();
      // return Wallet.fromJson(response);
      log('getChildrenWallets data: $walletsIds');
      */
    } catch (e, s) {
      log('getChildrenWallets error: $e $s');
      return null;
    }
  }

  Future<Group?> getGroupById(String groupId) async {
    try {
      /*
      final response =
          await supabase.from('group').select().eq('id', id).single();
      */
      final response =
          await dio.get('${EnvConstants.APP_API_ENDPOINT}/groups/$groupId');
      if (response.data.isNotEmpty) {
        return Group.fromMap(response.data);
      }
      return null;
    } catch (e, s) {
      log('Error fetching group: $e\n$s');
      rethrow;
    }
  }

  Future<void> updateGroup(Group group) async {
    try {
      final response = await dio.patch(
          '${EnvConstants.APP_API_ENDPOINT}/groups/${group.id}',
          data: group);
      log(response.data);
    } catch (e, s) {
      log('updateGroup error: $e $s');
    }
  }

  Future<void> deleteGroup(Group group) async {
    try {
      final response = await dio
          .delete('${EnvConstants.APP_API_ENDPOINT}/groups/${group.id}');
      log(response.data);
    } catch (e, s) {
      log('updateGroup error: $e $s');
    }
  }

  Future<List<Map<String, dynamic>>?> getAcceptedUsers() async {
    // List<Profile> profiles = [];
    try {
      final response = await supabase
          .from('cooperative_member_requests')
          .select()
          .eq('status', 'unresolved');
      log('getAcceptedUsers response: $response');
      // log(JsonEncoder.withIndent(' ').convert(response));
      return response;
    } catch (e) {
      log('getAcceptedUsers error: $e');
      return null;
    }
  }

  // Get eligible members for a group (members who are not already in any group)
  /*
  Future<List<Profile>> getEligibleMembers() async {
    try {
      final response = await supabase
          .from('profile')
          .select()
          .not('id', 'in', supabase.from('group_member').select('member_id'))
          .order('created_at', ascending: false);

      return response.map((data) => Profile.fromMap(data)).toList();
    } catch (e, s) {
      log('Error fetching eligible members: $e\n$s');
      rethrow;
    }
  }
  */

  // Add a member to a group
  /*
  Future<void> addMemberToGroup(String groupId, String memberId) async {
    try {
      final Group group;
      group
      final response = await dio.patch('${EnvConstants.APP_API_ENDPOINT}/groups/$groupId');
      /*
      await supabase.from('group_member').insert({
        'group_id': groupId,
        'member_id': memberId,
        'status': 'active',
        'joined_at': DateTime.now().toIso8601String(),
      });
      */
    } catch (e, s) {
      log('Error adding member to group: $e\n$s');
      rethrow;
    }
  }
  

  // Remove a member from a group
  Future<void> removeMemberFromGroup(String groupId, String memberId) async {
    try {
      await supabase.from('group_member').delete().match({
        'group_id': groupId,
        'member_id': memberId,
      });
    } catch (e, s) {
      log('Error removing member from group: $e\n$s');
      rethrow;
    }
  }
  */

  // Get members of a specific group
  /*
  Future<List<Profile>> getGroupMembers(String groupId) async {
    try {
      final response = await supabase
          .from('group_member')
          .select('member:profile(*)')
          .eq('group_id', groupId)
          .eq('status', 'active');

      return response.map((data) => Profile.fromMap(data['member'])).toList();
    } catch (e, s) {
      log('Error fetching group members: $e\n$s');
      rethrow;
    }
  }
  

  Future<List<Map<String, dynamic>>?> getAcceptedUsers() async {
    // List<Profile> profiles = [];
    try {
      final response = await supabase
          .from('cooperative_member_requests')
          .select('*, profiles(*)')
          .eq('status', 'accepted');
      // log(JsonEncoder.withIndent(' ').convert(response));
      return response;
    } catch (e) {
      log('getAcceptedUsers error: $e');
      return null;
    }
  }
  */
}
