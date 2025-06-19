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
      final response =
          await dio.patch('$APP_API_ENDPOINT/cooperatives', data: group);
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
      final response = await dio.get('$APP_API_ENDPOINT/groups');
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
      // 1. Fetch the group data with members
      /*
      final response = await supabase
          .from('group')
          .select('members')
          .eq('id', groupId)
          .single()
          .timeout(const Duration(seconds: 10)); // Add timeout
      */
      final response = await dio.get('$APP_API_ENDPOINT/cooperatives/$groupId');
      // 2. Validate and parse the response
      if (response.data['members'] == null) {
        log('No members found for group $groupId');
        return [];
      }

      // 3. Convert members to Profile objects
      final membersList = response.data['members'] as List;
      final profiles = membersList
          .whereType<Map<String, dynamic>>() // Ensure each item is a Map
          .map((item) => Profile.fromMap(item))
          .where((profile) => profile.id != null) // Filter out invalid profiles
          .toList();

      log('Fetched ${profiles.length} members for group $groupId');
      log('Fetched ${profiles.map((profile) => profile.toMap())}');

      return profiles;
    } on PostgrestException catch (e) {
      log('Supabase error fetching group members: ${e.message}', error: e);
      return null;
    } on TimeoutException catch (e) {
      log('Timeout fetching group members: $e');
      return null;
    } catch (e, s) {
      log('Unexpected error fetching group members', error: e, stackTrace: s);
      return null;
    }
  }

  Future<List<Profile>?> getPendingMukandoGroupMembers(String groupId) async {
    try {
      // 1. Fetch the group data with members
      /*
      final response = await supabase
          .from('group')
          .select('members')
          .eq('id', groupId)
          .single()
          .timeout(const Duration(seconds: 10)); // Add timeout
      */
      final response = await dio.get(
          '$APP_API_ENDPOINT/cooperative_member_requests/$groupId/unresolved');
      log('getPendingMukandoGroupMembers response: ${JsonEncoder.withIndent(' ').convert(response.data['data'])}');
      // 2. Validate and parse the response
      if (response.data == null) {
        log('No members found for group $groupId');
        return [];
      } else {
        // 3. Convert members to Profile objects
        if (response.data['data'].length > 1) {
          final membersList = response.data['data']['profiles'] as List;
          final profiles = membersList
              .whereType<Map<String, dynamic>>() // Ensure each item is a Map
              .map((item) => Profile.fromMap(item))
              .where((profile) =>
                  profile.id != null) // Filter out invalid profiles
              .toList();

          log('Fetched ${profiles.length} members for group $groupId');
          log('Fetched ${profiles.map((profile) => profile.toMap())}');
          return profiles;
        } else if (response.data['data'].length == 1) {
          final data = response.data['data'][0]['profiles'];
          return [Profile.fromMap(data)];
        } else {
          log('No members found for group $groupId');
          return [];
        }
      }
    } on PostgrestException catch (e) {
      log('Supabase error fetching group members: ${e.message}', error: e);
      return null;
    } on TimeoutException catch (e) {
      log('Timeout fetching group members: $e');
      return null;
    } catch (e, s) {
      log('Unexpected error fetching group members', error: e, stackTrace: s);
      return null;
    }
  }

  Future<Wallet?> getGroupWallet(String groupId) async {
    try {
      final response = await dio.get('$APP_API_ENDPOINT/groups/$groupId');
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
      final response = await dio.get('$APP_API_ENDPOINT/wallets/$walletId');
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
      final response = await dio.get('$APP_API_ENDPOINT/groups/$groupId');
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
      final response =
          await dio.patch('$APP_API_ENDPOINT/groups/${group.id}', data: group);
      log(response.data);
    } catch (e, s) {
      log('updateGroup error: $e $s');
    }
  }

  Future<void> deleteGroup(Group group) async {
    try {
      final response = await dio.delete('$APP_API_ENDPOINT/groups/${group.id}');
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
      final response = await dio.patch('$APP_API_ENDPOINT/groups/$groupId');
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
