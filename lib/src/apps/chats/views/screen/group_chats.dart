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
  String? loggedInUserId;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    loggedInUserId = _getStorage.read('userId');
    _initializeStream();
  }

  void _initializeStream() {
    _groupsStream = supabase
        .from('cooperatives')
        .stream(primaryKey: ['id'])
        .eq('admin_id', loggedInUserId ?? '')
        .order('created_at', ascending: false)
        .map((maps) => maps.map((map) => Group.fromMap(map)).toList());
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _groupsStream != null
        ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // _buildSearchField(),
              _buildGroupsList(),
              const SizedBox(height: 10),
            ],
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('No groups'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Navigate to search screen
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
}
