/*
import 'package:flutter/material.dart';

class CoopPollsWidgetScreen extends StatefulWidget {
  const CoopPollsWidgetScreen({super.key});

  @override
  State<CoopPollsWidgetScreen> createState() => _CoopPollsWidgetScreenState();
}

class _CoopPollsWidgetScreenState extends State<CoopPollsWidgetScreen> {
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
import 'package:mukai/src/apps/groups/views/widgets/poll_item.dart';
// import 'package:mukai/brick/models/cma.model.dart';
// import 'package:mukai/src/apps/home/widgets/transaction_item.dart';
import 'package:mukai/src/apps/transactions/controllers/transactions_controller.dart';
// import 'package:mukai/src/controllers/cma.controller.dart';
import 'package:mukai/src/controllers/cooperative-member-approvals.controller.dart';
import 'package:mukai/widget/loading_shimmer.dart';

class CoopPollsWidget extends StatefulWidget {
  final CooperativeMemberApproval cma;
  final Group group;
  const CoopPollsWidget({super.key, required this.cma, required this.group});

  @override
  State<CoopPollsWidget> createState() => _MyCoopPollsWidgetState();
}

class _MyCoopPollsWidgetState extends State<CoopPollsWidget> {
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
      var polls_list = await cmaController.getCoopPolls(widget.group.id ?? '', loggedInUserId!);
      setState(() {
        polls = polls_list;
        _isLoading = false;
      });
      log('CoopPollsWidgetpolls: $polls');
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
    log('CoopPollsWidget role: $role');
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
                      child: PollItemWidget(cma: cma),
                    ),
                  );

                  // MukandoMembersListTile(groupMember: member);
                },
              );
  }
}
