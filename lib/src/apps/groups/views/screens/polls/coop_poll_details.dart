import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:mukai/brick/models/cooperative-member-approval.model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mukai/brick/models/group.model.dart';
import 'package:mukai/components/app_bar.dart';
import 'package:mukai/src/controllers/cooperative-member-approvals.controller.dart';
import 'package:mukai/src/controllers/profile_controller.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/utils/helper/helper_controller.dart';
import 'package:mukai/utils/utils.dart';
import 'package:mukai/src/controllers/asset.controller.dart';
import 'package:mukai/widget/loading_shimmer.dart';

class CoopPollDetailsScreen extends StatefulWidget {
  final CooperativeMemberApproval poll;
  final String? status;
  final Group? group;

  const CoopPollDetailsScreen({
    super.key,
    required this.poll,
    this.status,
    this.group,
  });

  @override
  State<CoopPollDetailsScreen> createState() => _CoopPollDetailsScreenState();
}

class _CoopPollDetailsScreenState extends State<CoopPollDetailsScreen> {
  TextEditingController pollDescriptionController = TextEditingController();
  TextEditingController proposedValueController = TextEditingController();
  TextEditingController numberOfMembersController = TextEditingController();
  TextEditingController supportingVotesController = TextEditingController();
  TextEditingController opposingVotesController = TextEditingController();
  CooperativeMemberApprovalsController cmaController =Get.find<CooperativeMemberApprovalsController>();
  // TextEditingController repaymentAmountController = TextEditingController();
  // LoanController cmaController = Get.put(LoanController());
  // ProfileController profileController = Get.put(ProfileController());
  late double height;
  late double width;
  String? userId;
  String? role;
  Dio dio = Dio();
  bool _isSupporting = false;
  bool _isOpposing = false;
  bool _isLoading = true;
  bool _consensusReached = false;

  // List<ProfileModel> pendingMembers = [];
  // List<ProfileModel> activeMembers = [];
  // List<AssetModel> assets = [];

  @override
  void initState() {
    super.initState();
    userId = GetStorage().read('userId');
    role = GetStorage().read('role');

    // Initialize controllers
    pollDescriptionController.text = widget.poll.pollDescription ?? '';
    if (widget.poll.additionalInfo != null) {
      proposedValueController.text = (widget.poll.additionalInfo).toString();
    }
    if (widget.poll.numberOfMembers != null) {
      numberOfMembersController.text =
          (widget.poll.numberOfMembers! - 1).toString();
    }
    if (widget.poll.supportingVotes != null) {
      supportingVotesController.text =
          widget.poll.supportingVotes?.length.toString() ?? '0';
    }
    if (widget.poll.opposingVotes != null) {
      opposingVotesController.text =
          widget.poll.opposingVotes?.length.toString() ?? '0';
    }

    // Check current vote status
    _checkVoteStatus();
    _fetchData();
  }

  @override
  void dispose() {
    // Reset all controllers and state when widget is disposed
    pollDescriptionController.dispose();
    numberOfMembersController.dispose();
    supportingVotesController.dispose();
    opposingVotesController.dispose();
    cmaController.cma.value =
        CooperativeMemberApproval(); // Reset the selected poll
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    cmaController.isLoading.value = false;
    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;
    return Scaffold(
        backgroundColor: whiteColor,
        appBar: MyAppBar(
          widget: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Utils.trimp(widget.poll.pollDescription ?? 'Poll Details'),
                style: semibold18WhiteF5,
              ),
              /*
            Text(
              "CooperativeMemberApproval ID: ${widget.poll.id?.substring(28, 36) ?? ''}",
              style: semibold14WhiteF5,
            ),
            */
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: LoadingShimmerWidget())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailField(
                      label: 'Purpose',
                      value: pollDescriptionController.text,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailField(
                      label: 'Number of group members',
                      value: numberOfMembersController.text,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailField(
                      label: 'Proposed value',
                      value: proposedValueController.text,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailField(
                      label: 'Opposing votes',
                      value: opposingVotesController.text,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailField(
                      label: 'Supporting votes',
                      value: supportingVotesController.text,
                    ),
                    const SizedBox(height: 24),
                    // Text(
                    //   '* Calculated at ${(widget.group?.interest_rate ?? 0 * 100).toStringAsFixed(0)}% monthly compound interest',
                    //   style: TextStyle(
                    //     fontSize: 16,
                    //     color: Colors.grey[600],
                    //     // fontStyle: FontStyle.italic,
                    //   ),
                    // ),
                    // const SizedBox(height: 20),
                  ],
                ),
              ),
              bottomNavigationBar:  pollSummary(widget.poll));
        // bottomNavigationBar: role == 'coop-member'
        //     ? pollSummary(widget.poll)
        //     : requestSummary(widget.poll));
  }

  Widget _buildDetailField({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: semibold14Black,
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
            ],
          ),
          child: Text(
            value.isNotEmpty ? value : '0',
            style: TextStyle(color: blackColor),
          ),
        ),
      ],
    );
  }

  requestSummary(CooperativeMemberApproval poll) {
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.fromLTRB(fixPadding * 2.0, fixPadding * 2.0,
          fixPadding * 2.0, fixPadding * 3.0),
      padding: const EdgeInsets.symmetric(
          horizontal: fixPadding * 2.0, vertical: fixPadding * 1.4),
      decoration: BoxDecoration(
        color: whiteF5Color,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: buttonShadow,
      ),
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () async {
                Get.defaultDialog(
                    barrierDismissible: true,
                    middleTextStyle: TextStyle(color: blackColor, fontSize: 14),
                    buttonColor: primaryColor,
                    backgroundColor: tertiaryColor,
                    title: 'Confirm CooperativeMemberApproval',
                    middleText: 'Confirm poll approval',
                    textConfirm: 'OK',
                    confirmTextColor: whiteColor,
                    onConfirm: () async {
                      if (poll.id != null) {
                        log('message');
                        /*
                        cmaController.selectedLoan.value.id = poll.id!;
                        cmaController.selectedLoan.value.status = 'approved';
                        cmaController.selectedLoan.value.updatedAt =
                            DateTime.now().toIso8601String();
                        await cmaController.updateLoan();
                        Navigator.pop(context);
                        Get.back();
                        */
                      } else {
                        Helper.errorSnackBar(
                            title: 'Blank ID',
                            message: 'No ID was provided',
                            duration: 5);
                      }
                    },
                    cancelTextColor: redColor,
                    onCancel: () {
                      if (Get.isDialogOpen!) {
                        Get.back();
                      }
                    });
              },
              child: Container(
                  alignment: Alignment(0, 0),
                  height: height * 0.04,
                  width: width * 0.25,
                  // padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 1,
                    children: [
                      Text(
                        'Update',
                        style: bold16White,
                      ),
                    ],
                  )),
            ),
            GestureDetector(
              onTap: () {
                Get.defaultDialog(
                    barrierDismissible: true,
                    middleTextStyle: TextStyle(color: blackColor, fontSize: 14),
                    buttonColor: primaryColor,
                    backgroundColor: tertiaryColor,
                    title: 'Reject poll',
                    middleText: 'Confirm poll rejection',
                    textConfirm: 'OK',
                    confirmTextColor: whiteColor,
                    onConfirm: () async {
                      // await cmaController.deleteLoan(poll.id!);
                      Navigator.pop(context);
                      Navigator.pop(context);

                      // Navigator.pop(context);
                      // if (Get.isDialogOpen!) {
                      //   Get.back();
                      // }
                    },
                    cancelTextColor: redColor,
                    onCancel: () {
                      if (Get.isDialogOpen!) {
                        Get.back();
                      }
                    });
              },
              child: Container(
                  alignment: Alignment(0, 0),
                  height: height * 0.04,
                  width: width * 0.25,
                  // padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: redColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 1,
                    children: [
                      Text(
                        'Delete',
                        style: bold16White,
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget pollSummary(CooperativeMemberApproval poll) {
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.fromLTRB(fixPadding * 2.0, fixPadding * 2.0,
          fixPadding * 2.0, fixPadding * 3.0),
      padding: const EdgeInsets.symmetric(
          horizontal: fixPadding * 2.0, vertical: fixPadding * 1.4),
      decoration: BoxDecoration(
        color: whiteF5Color,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: buttonShadow,
      ),
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Support Button
            GestureDetector(
              onTap: _isSupporting ? null : () => _handleVote(true),
              child: Container(
                alignment: Alignment(0, 0),
                height: height * 0.04,
                width: width * 0.25,
                decoration: BoxDecoration(
                  color: _isSupporting ? Colors.green : primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _isLoading && _isSupporting
                    ? const CircularProgressIndicator(color: whiteColor)
                    : Text(
                        _isSupporting ? 'Supported' : 'Support',
                        style: bold16White,
                      ),
              ),
            ),

            // Oppose Button
            GestureDetector(
              onTap: _isOpposing ? null : () => _handleVote(false),
              child: Container(
                alignment: Alignment(0, 0),
                height: height * 0.04,
                width: width * 0.25,
                decoration: BoxDecoration(
                  color: _isOpposing ? Colors.red[800] : redColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _isLoading && _isOpposing
                    ? const CircularProgressIndicator(color: whiteColor)
                    : Text(
                        _isOpposing ? 'Opposed' : 'Oppose',
                        style: bold16White,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleVote(bool isSupporting) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      if (isSupporting) {
        _isSupporting = true;
        _isOpposing = false;
        final supportingVotes = widget.poll.supportingVotes!.length + 1;
        // log((supportingVotes / (widget.poll.numberOfMembers! - 1)).toString());
        if (supportingVotes / (widget.poll.numberOfMembers! - 1) >= 0.75) {
          setState(() {
            _consensusReached = true;
          });
        }
      } else {
        _isSupporting = false;
        _isOpposing = true;
      }
      // else {
      //   final supportingVotes = widget.poll.supportingVotes!.length - 1;
      //   log((supportingVotes / (widget.poll.numberOfMembers! - 1)).toString());
      //   if (supportingVotes / (widget.poll.numberOfMembers! - 1) < 0.75) {
      //     setState(() {
      //       _consensusReached = false;
      //     });
      //   }
      // }
    });

    try {
      log(_consensusReached.toString());
      final response = await cmaController.castVote(
          groupId: widget.group!.id!,
          profileId: widget.poll.profileId!,
          pollId: widget.poll.id!,
          pollDescription: widget.poll.pollDescription!,
          memberId: userId!,
          isSupporting: isSupporting,
          consensusReahed: _consensusReached,
          additionalInfo: widget.poll.additionalInfo,
          loanId: widget.poll.loanId);

      if (response != null && response.containsKey('error')) {
        Helper.errorSnackBar(
          title: 'Error',
          message: response['error'],
          duration: 5,
        );
        // Reset vote state on error
        setState(() {
          _isSupporting = false;
          _isOpposing = false;
        });
      } else {
        Helper.successSnackBar(
          title: 'Success!',
          message: 'Your vote has been recorded',
          duration: 3,
        );
        // Refresh poll data
        _refreshPollData();
      }
    } catch (e) {
      log('Error handling vote: $e');
      Helper.errorSnackBar(
        title: 'Error',
        message: 'Failed to process your vote',
        duration: 5,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Add this method to refresh poll data
  Future<void> _refreshPollData() async {
    try {
      final updatedPoll = await cmaController.getPollDetails(widget.poll.id!);
      setState(() {
        supportingVotesController.text =
            updatedPoll['supporting_votes']?.length.toString() ?? '0';
        opposingVotesController.text =
            updatedPoll['opposing_votes']?.length.toString() ?? '0';

        // Update current vote status
        final supportingVotes =
            List<String>.from(updatedPoll['supporting_votes'] ?? []);
        final opposingVotes =
            List<String>.from(updatedPoll['opposing_votes'] ?? []);

        _isSupporting = supportingVotes.contains(userId);
        _isOpposing = opposingVotes.contains(userId);
      });
    } catch (e) {
      log('Error refreshing poll data: $e');
    }
  }

  Future<void> _checkVoteStatus() async {
    try {
      final poll = await cmaController.getPollDetails(widget.poll.id!);
      final supportingVotes = List<String>.from(poll['supporting_votes'] ?? []);
      final opposingVotes = List<String>.from(poll['opposing_votes'] ?? []);

      setState(() {
        _isSupporting = supportingVotes.contains(userId);
        _isOpposing = opposingVotes.contains(userId);
      });
    } catch (e) {
      log('Error checking vote status: $e');
    }
  }

  Future<void> _fetchData() async {
    try {
      setState(() => _isLoading = false);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch data: $e');
    }
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}
