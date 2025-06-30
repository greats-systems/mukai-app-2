import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mukai/brick/models/cooperative-member-approval.model.dart';
import 'package:mukai/brick/models/group.model.dart';
import 'package:mukai/brick/models/wallet.model.dart';
import 'package:mukai/src/apps/groups/views/screens/polls/coop_poll_details.dart';
import 'package:mukai/src/apps/groups/views/screens/polls/coop_polls.dart';
import 'dart:developer';
// import 'package:mukai/src/apps/home/apps/cmas/loan_detail.dart';
import 'package:mukai/src/apps/groups/views/widgets/loan_item.dart';
import 'package:mukai/src/controllers/cooperative-member-approvals.controller.dart';
import 'package:mukai/src/controllers/wallet.controller.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/widget/loading_shimmer.dart';

class CoopPollsScreen extends StatefulWidget {
  final Group group;
  const CoopPollsScreen({super.key, required this.group});

  @override
  State<CoopPollsScreen> createState() => _PollsScreenState();
}

class _PollsScreenState extends State<CoopPollsScreen> {
  final GetStorage _getStorage = GetStorage();
  final CooperativeMemberApprovalsController _cmaController = Get.put(CooperativeMemberApprovalsController());
  // final LoanController _loanController = LoanController();
  List<CooperativeMemberApproval>? cmas;
  // List<Loan>? cmas;
  String? userId;
  String? role;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
  }

  void fetchId() async {
    try {
      final id = await _getStorage.read('userId');
      if (!mounted) return;
      setState(() {
        _isLoading = true;
        userId = id;
      });
      final cmaData = await _cmaController.getCoopPolls(widget.group.id!);
      if (!mounted) return;
      setState(() {
        cmas = cmaData;
      });
      /*
      final cmasData =
          await _loanController.getCoopPolls(widget.group.id!, userId!);
      if (!mounted) return;
      setState(() {
        cmas = cmasData;
      });
      */
    } on Exception catch (e, s) {
      log('LoanLandingPage: $e $s');
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    fetchId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: LoadingShimmerWidget(),
          )
        : cmas == null
            ? Center(
                child: Text('No coop cmas yet'),
              )
            : ListView.builder(
                itemCount: cmas!.length,
                itemBuilder: (context, index) {
                  CooperativeMemberApproval cma = cmas![index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        log(widget.group.toJson().toString());
                        // loanController.selectedLoan.value = cma;
                        Get.to(() => CoopPollDetailsScreen(
                              group: widget.group,
                              poll: cma,
                              // isActive: _showActiveMembers,
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
                          margin:
                              const EdgeInsets.symmetric(vertical: fixPadding),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: whiteColor.withOpacity(0.1),
                          ),
                          child: CoopPolls(
                            group: widget.group,
                            cma: cma),
                          // child: Widget(cma: cma),
                        ),
                      ),
                    ),
                  );
                },
              );
    /*
    return Scaffold(
      appBar: CoopAppBar(title: 'Loan Status'),
      body: Center(child: Text('Loan status')));
      */
  }
}
