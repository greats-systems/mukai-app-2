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

class GroupMembersList extends StatefulWidget {
  final String groupId;
   String? category;

   GroupMembersList({super.key, required this.groupId, this.category});

  @override
  State<GroupMembersList> createState() => _GroupMembersListState();
}

class _GroupMembersListState extends State<GroupMembersList> {
  int? selectedCategory;
  String category = '1 day';
  late double height;
  late double width;

  TransactionController get transactionController =>
      Get.put(TransactionController());
  ProfileController get profileController => Get.put(ProfileController());
  late final Stream<List<Profile>> _membersStream;

  @override
  void initState() {
    log('Getting data for coop_member_requests for group${widget.groupId}');
    _membersStream = supabase
        .from('cooperative_member_requests')
        .stream(primaryKey: ['id'])
        .eq('id', widget.groupId)
        .order('created_at')
        .asyncMap((maps) async {
          List<Profile> profiles = [];
          try {
            profiles = await Future.wait(
              maps.map((map) async {
                Profile profile = Profile.fromMap(map);
                log('profile ${profile.toMap()}');
                return profile;
              }).toList(),
            );
            return profiles;
          } catch (error) {
            log(' profiles  error ${error}');
            return profiles;
          }
        });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;
    return Column(
      children: [
        StreamBuilder<List<Profile>>(
            stream: _membersStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              if (snapshot.hasData) {
                final profiles = snapshot.data!;
                return profiles.isEmpty
                    ? const Center(
                        child: Text('No Transaction found'),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        // physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: profiles.length,
                        itemBuilder: (context, index) {
                          Profile profile = profiles[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                profileController.selectedProfile.value =
                                    profile;
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
                                  padding:
                                      const EdgeInsets.all(fixPadding * 1.5),
                                  margin: const EdgeInsets.symmetric(
                                      vertical: fixPadding),
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
                        },
                      );
              }
              return preloader;
            }),
      ],
    );
  }
}
