/*
import 'package:flutter/material.dart';

class CoopPollsScreen extends StatefulWidget {
  const CoopPollsScreen({super.key});

  @override
  State<CoopPollsScreen> createState() => _CoopPollsScreenState();
}

class _CoopPollsScreenState extends State<CoopPollsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
*/

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:mukai/brick/models/cma.model.dart';
import 'package:mukai/brick/models/cooperative-member-approval.model.dart';
import 'package:mukai/brick/models/group.model.dart';
import 'package:mukai/src/apps/groups/views/screens/polls/coop_poll_details.dart';
// import 'package:mukai/brick/models/cma.model.dart';
// import 'package:mukai/src/apps/home/widgets/transaction_item.dart';
import 'package:mukai/src/apps/transactions/controllers/transactions_controller.dart';
// import 'package:mukai/src/controllers/cma.controller.dart';
import 'package:mukai/src/controllers/cooperative-member-approvals.controller.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/widget/loading_shimmer.dart';

class CoopPolls extends StatefulWidget {
  final CooperativeMemberApproval cma;
  final Group group;
  const CoopPolls({super.key, required this.cma, required this.group});

  @override
  State<CoopPolls> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<CoopPolls> {
  TransactionController get transactionController =>
      Get.put(TransactionController());
  CooperativeMemberApprovalsController get cmaController =>
      Get.put(CooperativeMemberApprovalsController());
  late double height;
  late double width;
  String? loggedInUserId;
  String? role;
  List<CooperativeMemberApproval>? polls = [];
  bool _isLoading = true;

  void _fetchGroupMembers() async {
    setState(() => _isLoading = true);
    try {
      var polls_list = await cmaController.getCoopPolls(widget.group.id ?? '');
      setState(() {
        polls = polls_list;
        _isLoading = false;
      });
      log('CoopPollspolls: $polls');
    } catch (e) {
      setState(() => _isLoading = false);
      log('Error fetching members: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    loggedInUserId = GetStorage().read('userId');
    role = GetStorage().read('role');
    _fetchGroupMembers();
    log('CoopPolls role: $role');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;
    return _isLoading
        ? const Center(child: LoadingShimmerWidget())
        : polls == null
            ? const Center(child: Text('No polls found'))
            : ListView.builder(
              shrinkWrap: true,
                itemCount: polls!.length,
                itemBuilder: (context, index) {
                  CooperativeMemberApproval cma = polls![index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        cmaController.selectedCma.value = cma;
                        log('Profile ID: ${cma.id}');
                        Get.to(() => CoopPollDetailsScreen(
                              poll: widget.cma,
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
                        // child: PollS,
                      ),
                    ),
                  );

                  // MukandoMembersListTile(groupMember: member);
                },
              );
  }
}
