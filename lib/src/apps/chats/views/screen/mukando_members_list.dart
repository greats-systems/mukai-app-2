import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mukai/brick/models/group.model.dart';
import 'package:mukai/brick/models/profile.model.dart';
import 'package:mukai/src/apps/chats/views/widgets/mukando_members_list_tile.dart';
import 'package:mukai/src/components/my_app_bar.dart';
// import 'package:mukai/constants.dart';
import 'package:mukai/src/controllers/group.controller.dart';
// import 'package:mukai/theme/theme.dart';
// import 'package:mukai/utils/utils.dart';
import 'dart:developer';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mukai/brick/models/profile.model.dart';
import 'package:mukai/constants.dart';
import 'package:mukai/src/apps/groups/views/screens/member_detail.dart';
import 'package:mukai/src/apps/groups/views/widgets/member_item.dart';
import 'package:mukai/src/controllers/profile_controller.dart';
import 'package:mukai/src/apps/transactions/controllers/transactions_controller.dart';
import 'package:mukai/theme/theme.dart';

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
  bool _isLoading = true;

  void _fetchGroupMembers() async {
    setState(() => _isLoading = true);
    try {
      final members =
          await _groupController.getMukandoGroupMembers(widget.group.id ?? '');
      setState(() {
        mukandoMembers = members;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      log('Error fetching members: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    loggedInUserId = _getStorage.read('userId');
    _fetchGroupMembers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: MyAppBar(title: 'Group members'),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (widget.group.id == null) {
      return const Center(child: Text('Invalid mukando group'));
    }

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (mukandoMembers == null || mukandoMembers!.isEmpty) {
      return const Center(child: Text('No members found'));
    }

    return ListView.builder(
      itemCount: mukandoMembers!.length,
      itemBuilder: (context, index) {
        Profile profile = mukandoMembers![index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              profileController.selectedProfile.value = profile;
              log('Profile ID: ${profile.id}');
              Get.to(() => MemberDetailScreen(
                    profile: profile,
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
                child: MemberItemWidget(
                  profile: profile,
                ),
              ),
            ),
          ),
        );
        // MukandoMembersListTile(groupMember: member);
      },
    );
  }
}
