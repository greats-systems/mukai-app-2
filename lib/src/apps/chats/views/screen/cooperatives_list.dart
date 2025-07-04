import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mukai/brick/models/asset.model.dart';
import 'package:mukai/brick/models/group.model.dart';
import 'package:mukai/brick/models/group_members.model.dart';
import 'package:mukai/main.dart';
import 'package:mukai/src/apps/auth/views/member_register_coop.dart';
import 'package:mukai/src/apps/groups/views/screens/members/create_group.dart';
import 'package:mukai/src/apps/groups/views/screens/dashboard/landing_page.dart';
import 'package:mukai/src/controllers/auth.controller.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/utils/utils.dart';
import 'package:mukai/widget/loading_shimmer.dart';
import 'package:mukai/widget/render_supabase_image.dart';

class CooperativesList extends StatefulWidget {
  final int index;
  const CooperativesList({super.key, required this.index});

  @override
  State<CooperativesList> createState() => _CooperativesListState();
}

class _CooperativesListState extends State<CooperativesList> {
  final TextEditingController searchController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();
  final GetStorage _getStorage = GetStorage();

  late Stream<List<Group>>? _groupsStream;
  late Stream<List<GroupMembers>>? _groupMembersStrem;
  List<Group>? _groups;
  List<GroupMembers>? _groupMembers;
  String? loggedInUserId;
  String? role;
  String searchQuery = '';

  bool _isLoading = true; // Start with loading true
  bool _dataLoaded = false; // Track if data loading is complete

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      loggedInUserId = _getStorage.read('userId');
      role = _getStorage.read('role');
      log('CooperativesList role: $role');

      await Future.wait([
        _initializeStream(),
        _initializeMembers(),
      ]);

      if (mounted) {
        setState(() {
          _dataLoaded = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      log('Error initializing data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _initializeStream() async {
    if (!mounted) return;

    final stream = supabase
        .from('cooperatives')
        .stream(primaryKey: ['id'])
        .eq('admin_id', loggedInUserId ?? '')
        .order('created_at', ascending: false)
        .map((maps) => maps.map((map) => Group.fromMap(map)).toList());

    // final gmStream = supabase.from('group_members').stream(primaryKey: ['id']).eq(column, value)

    if (mounted) {
      setState(() {
        _groupsStream = stream;
      });
    }
  }

  Future<void> _initializeMembers() async {
    try {
      final memberData = await supabase
          .from('group_members')
          .select('member_id, cooperatives(*)')
          .eq('member_id', loggedInUserId ?? '')
          .order('created_at', ascending: false);

      if (mounted) {
        setState(() {
          _groups = memberData[0]['cooperatives'] is Map
              ? [Group.fromMap(memberData[0]['cooperatives'])]
              : memberData.map((item) => Group.fromMap(item)).toList();
        });
      }
    } catch (e) {
      log('Error loading members: $e');
      if (mounted) {
        setState(() {
          _groups = [];
        });
      }
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: LoadingShimmerWidget());
    }

    // Show empty state if no data loaded
    if (!_dataLoaded) {
      return Center(child: Text('Failed to load data'));
    }

    final isCoopMember = role == 'coop-member';
    final hasGroups =
        isCoopMember ? _groups?.isNotEmpty ?? false : _groupsStream != null;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: hasGroups
                ? isCoopMember
                    ? _buildMembersList()
                    : _buildCooperativesList()
                : _buildEmptyState(isCoopMember),
          )
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isCoopMember) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(isCoopMember
              ? 'You are not part of any groups yet'
              : 'No groups found'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Get.to(() => MemberRegisterCoopScreen()),
            child: const Text('Search for Groups'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          if (!isCoopMember) ...[
            ElevatedButton(
              onPressed: () => Get.to(() => CreateGroup()),
              child: const Text('Create a Group'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
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

  Widget _buildCooperativesList() {
    return StreamBuilder<List<Group>>(
      stream: _groupsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: LoadingShimmerWidget());
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
                group.name?.toLowerCase().contains(searchQuery.toLowerCase()) ??
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
    );
  }

  Widget _buildMembersList() {
    return _isLoading
        ? const Center(child: LoadingShimmerWidget())
        : StreamBuilder<List<Group>>(
            stream: _groups != null
                ? Stream.fromIterable([_groups!])
                : Stream.empty(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: LoadingShimmerWidget());
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
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: whiteF5Color,
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => CoopLandingScreen(group: group));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _buildMemberTile(group),
                      ),
                    ),
                  );
                },
              );
            },
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
      // subtitle: Text('${group.members?.length ?? 0} group members'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // log('Group: ${group.name}');

        Get.to(() => CoopLandingScreen(group: group));
        // Get.to(() => MukandoMembersLandingPage(group: group));
      },
    );
  }

  Widget _buildMemberTile(Group group) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: whiteF5Color,
            width: 1.0,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          heightSpace,
          _buildMemberDetail(group),
          heightSpace,
          _buildStatusSection(group),
          heightSpace,
          LinearProgressIndicator(
            value: 1,
            backgroundColor: primaryColor.withOpacity(0.2),
            color: redColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ],
      ),
    );

    // ListTile(
    //   leading: CircleAvatar(
    //     backgroundColor: primaryColor,
    //     child: Text(
    //       group.name?.substring(0, 1).toUpperCase() ?? 'G',
    //       style: const TextStyle(color: Colors.white),
    //     ),
    //   ),
    //   title: Text(group.name ?? 'Unnamed Group'),
    //   // subtitle: Text('${group.members?.length ?? 0} members'),
    //   trailing: const Icon(Icons.chevron_right),
    //   onTap: () {
    //     // log('Group: ${group.name}');

    //     Get.to(() => CoopLandingScreen(group: group));
    //     // Get.to(() => MukandoMembersLandingPage(group: group));
    //   },
    // );
  }

  Widget _buildStatusSection(Group? group) {
    if (group != null) {
      return _buildAccountSummary(group);
    } else {
      return Center(
        child: Text('No profile'),
      );
    }
  }

  Widget _buildMemberDetail(Group? group) {
    return group != null
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatName(group),
                    style: semibold12black,
                    overflow: TextOverflow.ellipsis,
                  ),
                  height5Space,
                  _buildAccountInfo(group),
                ],
              ),
            ],
          )
        : Center(
            child: Text('No profile'),
          );
  }

  Widget _buildProfileImage(Asset? asset) {
    if (asset != null) {
      final imageUrl = asset.imageUrl;
      return SizedBox(
        height: 50,
        width: 50,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: imageUrl != null && imageUrl.isNotEmpty
              ? RenderSupabaseImageIdWidget(filePath: imageUrl)
              : const Icon(Icons.image, size: 50.0, color: Colors.grey),
        ),
      );
    } else {
      return Center(
        child: Text('No profile image'),
      );
    }
  }

  String _formatName(Group? asset) {
    if (asset != null) {
      return asset.name?.toUpperCase() ?? 'N';
    } else {
      return 'No name to format';
    }
  }

  Widget _buildAccountInfo(Group? asset) {
    return asset != null
        ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.6,
                    child: AutoSizeText(
                      maxLines: 2,
                      '${Utils.trimp(asset.country ?? '')}, ${Utils.trimp(asset.city ?? '')}',
                      style: regular14Black,
                    ),
                  ),
                ],
              ),
            ],
          )
        : Center(
            child: Text('No account info to build'),
          );
  }

  Widget _buildAccountSummary(Group? group) {
    return group != null
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: 20,
                children: [
                  _buildInfoColumn('Subs Amount', group.monthly_sub.toString()),
                  _buildInfoColumn(
                      'Interest Rate', group.interest_rate.toString()),
                  _buildInfoColumn('Number of Members', 0.toString()),
                ],
              ),
            ],
          )
        : Center(
            child: Text('Cannot build account summary'),
          );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: semibold12black),
        height5Space,
        Text(value, style: semibold16Primary),
      ],
    );
  }

  Widget _buildRequestSummary(Group? group) {
    return group != null
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (group.city != 'declined') ...[
                  _buildActionButton(
                    'Accept',
                    primaryColor,
                    () => _showConfirmationDialog(group, true),
                  ),
                  _buildActionButton(
                    'Decline',
                    redColor,
                    () => _showConfirmationDialog(group, false),
                  ),
                ],
              ],
            ),
          )
        : Center(
            child: Text('No summary'),
          );
  }

  void _showConfirmationDialog(Group? group, bool isAccept) {
    final action = isAccept ? 'accept' : 'decline';
    final name = '${group?.name?.toUpperCase() ?? ''} '
        '${group?.id?.toUpperCase() ?? ''}';
    final id = group?.id?.substring(0, 8) ?? '';

    Get.defaultDialog(
      middleTextStyle: const TextStyle(color: blackColor, fontSize: 14),
      buttonColor: primaryColor,
      backgroundColor: tertiaryColor,
      title: 'Membership Request',
      middleText: 'Are you sure you want to $action $name Request ID $id?',
      textConfirm: 'Yes, ${isAccept ? 'Accept' : 'Decline'}',
      confirmTextColor: whiteColor,
      onConfirm: () async {
        if (group?.id != null) {
          // await assetController.updateAssetRequest(
          //     asset?.id, isAccept ? 'accepted' : 'declined');
        }
      },
      cancelTextColor: redColor,
      onCancel: () => Get.back(),
    );
  }

  Widget _buildActionButton(String text, Color color, VoidCallback onTap) {
    final size = MediaQuery.sizeOf(context);
    final width = size.width;
    final height = size.height;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: height * 0.04,
        width: width * (text == 'Accept' ? 0.25 : 0.22),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(text, style: bold16White),
      ),
    );
  }
}
