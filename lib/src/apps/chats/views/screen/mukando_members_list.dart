import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mukai/brick/models/group.model.dart';
import 'package:mukai/brick/models/profile.model.dart';
// import 'package:mukai/constants.dart';
import 'package:mukai/src/controllers/group.controller.dart';
// import 'package:mukai/theme/theme.dart';
// import 'package:mukai/utils/utils.dart';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:mukai/src/apps/groups/views/screens/members/member_detail.dart';
import 'package:mukai/src/apps/groups/views/widgets/member_item.dart';
import 'package:mukai/src/controllers/profile_controller.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/widget/loading_shimmer.dart';

class MukandoMembersList extends StatefulWidget {
  final Group group;
  const MukandoMembersList({super.key, required this.group});

  @override
  State<MukandoMembersList> createState() => _MukandoMembersListState();
}

class _MukandoMembersListState extends State<MukandoMembersList> {
  final GetStorage _getStorage = GetStorage();
  final GroupController _groupController = GroupController();
  ProfileController get profileController => Get.put(ProfileController());
  String? loggedInUserId;
  List<Profile>? mukandoMembers = [];
  List<Profile>? pendingMukandoMembers = [];
  bool _isLoading = true;
  bool _showActiveMembers = true;
  bool _isDisposed = false; // Add disposal flag

  @override
  void dispose() {
    _isDisposed = true; // Set flag when widget is disposed
    super.dispose();
  }

  void _fetchGroupMembers() async {
    if (!mounted) return; // Check if widget is still mounted

    setState(() => _isLoading = true);
    try {
      final members =
          await _groupController.getMukandoGroupMembers(widget.group.id ?? '');
      final pendingMembers = await _groupController
          .getPendingMukandoGroupMembers(widget.group.id ?? '');

      if (!mounted) return; // Check again after async operations

      setState(() {
        mukandoMembers = members;
        pendingMukandoMembers = pendingMembers;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      log('Error fetching members: $e');
    }
  }

  @override
  void initState() {
    log('MukandoMembersList group.id: ${widget.group.id}');
    super.initState();
    loggedInUserId = _getStorage.read('userId');
    _fetchGroupMembers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Text('Pending'),
                Switch(
                  value: _showActiveMembers,
                  onChanged: (value) {
                    setState(() {
                      _showActiveMembers = value;
                    });
                  },
                ),
                const Text('Active'),
              ],
            ),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (widget.group.id == null) {
      return const Center(child: Text('Invalid mukando group'));
    }

    if (_isLoading) {
      return const Center(child: LoadingShimmerWidget());
    }

    final membersToShow =
        _showActiveMembers ? mukandoMembers : pendingMukandoMembers;

    if (membersToShow == null || membersToShow.isEmpty) {
      return Center(
        child: Text(_showActiveMembers
            ? 'No active members found'
            : 'No pending members found'),
      );
    }

    return ListView.builder(
      itemCount: membersToShow.length,
      itemBuilder: (context, index) {
        Profile profile = membersToShow[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              profileController.selectedProfile.value = profile;
              Get.to(() => MemberDetailScreen(
                    groupId: widget.group.id,
                    profile: profile,
                    isActive: _showActiveMembers,
                  ));
            },
            child: Container(
              width: double.maxFinite,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: recShadow,
              ),
              child: Container(
                padding: const EdgeInsets.all(fixPadding * 1.5),
                margin: const EdgeInsets.symmetric(vertical: fixPadding),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: whiteColor.withOpacity(0.1),
                ),
                child: MemberItemWidget(profile: profile),
              ),
            ),
          ),
        );
      },
    );
  }
}
