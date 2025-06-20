import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mukai/brick/models/group.model.dart';
import 'package:mukai/constants.dart';
import 'package:mukai/src/apps/auth/views/member_register_coop.dart';
import 'package:mukai/src/apps/chats/views/screen/mukando_members_landing_page.dart';
import 'package:mukai/src/apps/chats/views/screen/mukando_members_list.dart';
import 'package:mukai/src/apps/groups/views/screens/create_group.dart';
import 'package:mukai/src/apps/groups/views/screens/landing_page.dart';
import 'package:mukai/src/controllers/auth.controller.dart';
import 'package:mukai/theme/theme.dart';

class GroupsList extends StatefulWidget {
  final int index;

  const GroupsList({super.key, required this.index});

  @override
  State<GroupsList> createState() => _GroupsListState();
}

class _GroupsListState extends State<GroupsList> {
  final TextEditingController searchController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();
  final GetStorage _getStorage = GetStorage();

  late Stream<List<Group>>? _groupsStream;
  List<Group>? _memberGroups;
  String? loggedInUserId;
  String? role;
  String searchQuery = '';

  bool _isLoading = false;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    super.initState();
    setState(() {
      loggedInUserId = _getStorage.read('userId');
      role = _getStorage.read('account_type');
      _initializeStream();
      _initializeMembers();
      _isLoading = false;
    });
    log('GroupsList userId: $loggedInUserId\trole: $role\n groups: $_memberGroups');
  }

  Future<void> _initializeStream() async {
    _groupsStream = supabase
        .from('cooperatives')
        .stream(primaryKey: ['id'])
        .eq('admin_id', loggedInUserId ?? '')
        .order('created_at', ascending: false)
        .map((maps) => maps.map((map) => Group.fromMap(map)).toList());
  }

  Future<void> _initializeMembers() async {
    final memberData = await supabase
        .from('group_members')
        .select('member_id, cooperatives(*)')
        .eq('member_id', loggedInUserId ?? '')
        .order('created_at', ascending: false);
    log('_initializeMembers memberData: ${memberData[0]}');
    setState(() {
    if (memberData[0]['cooperatives'] is Map) {
      _memberGroups = [Group.fromMap(memberData[0]['cooperatives'])];
    } else {
      _memberGroups = memberData.map((item) => Group.fromMap(item)).toList();
    }
  });
    log('_memberGroups: $_memberGroups');
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  if (_isLoading) {
    return Center(child: CircularProgressIndicator());
  }

  // Determine which list to show based on role
  final isCoopMember = role == 'coop-member';
  final mainContent = isCoopMember ? _buildMembersList() : _buildGroupsList();

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      if (!isCoopMember) _buildSearchField(),
      Expanded(child: mainContent),
      const SizedBox(height: 10),
    ],
  );
}

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'Search groups...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              searchController.clear();
              setState(() => searchQuery = '');
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onChanged: (value) => setState(() => searchQuery = value),
      ),
    );
  }

  Widget _buildGroupsList() {
    return Expanded(
      child: StreamBuilder<List<Group>>(
        stream: _groupsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('This account has no groups associated with it.'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Navigate to search screen
                      Get.to(() => MemberRegisterCoopScreen());
                    },
                    child: const Text('Search for Groups'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Navigate to create group screen
                      Get.to(() => CreateGroup());
                    },
                    child: const Text('Create a Group'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }

          final groups = snapshot.data!
              .where((group) =>
                  group.name
                      ?.toLowerCase()
                      .contains(searchQuery.toLowerCase()) ??
                  false)
              .toList();

          return ListView.builder(
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];
              return _buildGroupTile(group);
            },
          );
        },
      ),
    );
  }

  Widget _buildMembersList() {
    return Expanded(
      child: StreamBuilder<List<Group>>(
        stream: _memberGroups != null
            ? Stream.fromIterable([_memberGroups!])
            : Stream.empty(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('This account has no groups associated with it.'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Navigate to search screen
                      Get.to(() => MemberRegisterCoopScreen());
                    },
                    child: const Text('Search for Groups'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Navigate to create group screen
                      Get.to(() => CreateGroup());
                    },
                    child: const Text('Create a Group'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }

          final groups = snapshot.data!
              .where((group) =>
                  group.name
                      ?.toLowerCase()
                      .contains(searchQuery.toLowerCase()) ??
                  false)
              .toList();

          return ListView.builder(
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];
              return _buildMemberTile(group);
            },
          );
        },
      ),
    );
  }

  Widget _buildGroupTile(Group group) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: primaryColor,
        child: Text(
          group.name?.substring(0, 1).toUpperCase() ?? 'G',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(group.name ?? 'Unnamed Group'),
      subtitle: Text('${group.members?.length ?? 0} members'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // log('Group: ${group.name}');

        Get.to(() => CoopLandingScreen(group: group));
        // Get.to(() => MukandoMembersLandingPage(group: group));
      },
    );
  }

  Widget _buildMemberTile(Group group) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: primaryColor,
        child: Text(
          group.name?.substring(0, 1).toUpperCase() ?? 'G',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(group.name ?? 'Unnamed Group'),
      subtitle: Text('${group.members?.length ?? 0} members'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // log('Group: ${group.name}');

        Get.to(() => CoopLandingScreen(group: group));
        // Get.to(() => MukandoMembersLandingPage(group: group));
      },
    );
  }
}
