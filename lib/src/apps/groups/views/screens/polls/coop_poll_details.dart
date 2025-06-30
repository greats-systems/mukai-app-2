/*
import 'package:flutter/material.dart';

class CoopPollDetailsScreen extends StatefulWidget {
  const CoopPollDetailsScreen({super.key});

  @override
  State<CoopPollDetailsScreen> createState() => _CoopPollDetailsScreenState();
}

class _CoopPollDetailsScreenState extends State<CoopPollDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
*/

import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:mukai/brick/models/cooperative-member-approval.model.dart';
import 'package:mukai/core/config/dio_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mukai/brick/models/group.model.dart';
import 'package:mukai/components/app_bar.dart';
import 'package:mukai/constants.dart';
import 'package:mukai/src/controllers/cooperative-member-approvals.controller.dart';
import 'package:mukai/src/controllers/profile_controller.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/utils/helper/helper_controller.dart';
import 'package:mukai/utils/utils.dart';

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
  TextEditingController numberOfMembersController = TextEditingController();
  TextEditingController supportingVotesController = TextEditingController();
  TextEditingController opposingVotesController = TextEditingController();
  CooperativeMemberApprovalsController cmaController =
      Get.put(CooperativeMemberApprovalsController());
  // TextEditingController repaymentAmountController = TextEditingController();
  // LoanController cmaController = Get.put(LoanController());
  // ProfileController profileController = Get.put(ProfileController());
  late double height;
  late double width;
  String? userId;
  String? role;
  Dio dio = Dio();

  @override
  void initState() {
    userId = GetStorage().read('userId');
    role = GetStorage().read('role');
    log(widget.group?.id ?? 'No ID');
    super.initState();
    // Initialize controllers with poll data
    pollDescriptionController.text = widget.poll.pollDescription ?? '';
    numberOfMembersController.text =
        widget.poll.numberOfMembers.toString() ?? '0';
    supportingVotesController.text =
        widget.poll.supportingVotes?.toString() ?? '0';
    opposingVotesController.text = widget.poll.opposingVotes ?? '';
  }

  @override
  Widget build(BuildContext context) {
    cmaController.isLoading.value = false;
    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;
    return Scaffold(
        appBar: MyAppBar(
          widget: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Utils.trimp(widget.poll.pollDescription ?? 'Poll Details'),
                style: semibold18WhiteF5,
              ),
              Text(
                "CooperativeMemberApproval ID: ${widget.poll.id?.substring(28, 36) ?? ''}",
                style: semibold14WhiteF5,
              ),
            ],
          ),
        ),
        body: Container(
          color: whiteF5Color,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildDetailField(
                label: 'Purpose',
                value: pollDescriptionController.text,
              ),
              const SizedBox(height: 16),
              _buildDetailField(
                label: 'Opposing votes',
                value: '${opposingVotesController.text}',
              ),
              const SizedBox(height: 16),
              _buildDetailField(
                label: 'Supporting votes',
                value: supportingVotesController.text,
              ),
              const SizedBox(height: 24),
              Text(
                '* Calculated at ${(widget.group?.interest_rate ?? 0.0).toString()}% monthly compound interest',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: role == 'coop-member'
            ? pollSummary(widget.poll)
            : requestSummary(widget.poll));
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
            style: TextStyle(color: greyB5Color),
          ),
        ),
      ],
    );
  }

  supportButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: GestureDetector(
        onTap: () {
          log('${widget.group!.id}');
          // cmaController.updateUser();
          // Navigator.pop(context);
        },
        child: Obx(() => cmaController.isLoading.value == true
            ? const LinearProgressIndicator(
                color: whiteColor,
              )
            : Container(
                width: double.maxFinite,
                margin: const EdgeInsets.fromLTRB(fixPadding * 2.0,
                    fixPadding * 2.0, fixPadding * 2.0, fixPadding * 3.0),
                padding: const EdgeInsets.symmetric(
                    horizontal: fixPadding * 2.0, vertical: fixPadding * 1.4),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: buttonShadow,
                ),
                child: const Text(
                  "Support",
                  style: bold18White,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              )),
      ),
    );
  }

  opposeButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: GestureDetector(
        onTap: () {
          log('I oppose');
          // cmaController.updateUser();
          // Navigator.pop(context);
        },
        child: Obx(() => cmaController.isLoading.value == true
            ? const LinearProgressIndicator(
                color: whiteColor,
              )
            : Container(
                width: double.maxFinite,
                margin: const EdgeInsets.fromLTRB(fixPadding * 2.0,
                    fixPadding * 2.0, fixPadding * 2.0, fixPadding * 3.0),
                padding: const EdgeInsets.symmetric(
                    horizontal: fixPadding * 2.0, vertical: fixPadding * 1.4),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: buttonShadow,
                ),
                child: const Text(
                  "Oppose",
                  style: bold18White,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              )),
      ),
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

  pollSummary(CooperativeMemberApproval poll) {
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
                log('poll id: ${widget.poll.id}');
                /*
                cmaController.selectedLoan.value.id = widget.poll.id;
                cmaController.selectedCoop.value.id = widget.group!.id;
                cmaController.selectedProfile.value.id = userId;
                cmaController.isSupporting.value = true;
                */
                try {
                  cmaController.selectedCma.value!.id = poll.id;
                  cmaController.selectedCma.value!.supportingVotes = userId!;
                  final response = await cmaController.updatePoll();
                  // log('CoopPollDetailsScreen polling response:\n${JsonEncoder.withIndent(' ').convert(response.data)}');
                  if (response != null) {
                    if (response!['data'] == "You have voted already") {
                      Helper.warningSnackBar(
                          title: 'Duplicate vote',
                          message: response['data'],
                          duration: 5);
                    } else {
                      Helper.successSnackBar(
                          title: 'Success!',
                          message: 'You have cast your vote',
                          duration: 5);
                    }
                  }
                } on DioException catch (e, s) {
                  log('DioException encountered when casting vote $e $s');
                  Helper.errorSnackBar(
                      title: 'Error', message: e.toString(), duration: 5);
                  // TODO
                } on Exception catch (e, s) {
                  log('Error encountered when casting vote $e $s');
                  Helper.errorSnackBar(
                      title: 'Error', message: e.toString(), duration: 5);
                }
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
                        'Support',
                        style: bold16White,
                      ),
                    ],
                  )),
            ),
            GestureDetector(
              onTap: () async {
                // log('I oppose');
                /*
                cmaController.selectedLoan.value.id = widget.poll.id;
                cmaController.selectedCoop.value.id = widget.group!.id;
                cmaController.selectedProfile.value.id = userId;
                cmaController.isSupporting.value = false;
                */
                try {
                  // log(params.toString());
                  cmaController.selectedCma.value!.opposingVotes = userId!;
                  final response = await cmaController.updatePoll();
                  // log('CoopPollDetailsScreen polling response:\n${JsonEncoder.withIndent(' ').convert(response.data)}');
                  // Navigator.pop(context);
                  if (response!['data'] == 'You have voted already') {
                    Helper.warningSnackBar(
                        title: 'Duplicate vote',
                        message: response['data'],
                        duration: 5);
                  } else {
                    Helper.successSnackBar(
                        title: 'Success!',
                        message: 'You have cast your vote',
                        duration: 5);
                  }
                } on Exception catch (e, s) {
                  log('Error casting opposing vote: $e $s');
                }
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
                        'Oppose',
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
}
