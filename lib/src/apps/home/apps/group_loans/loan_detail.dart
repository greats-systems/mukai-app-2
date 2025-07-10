import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mukai/brick/models/loan.model.dart';
import 'package:mukai/brick/models/group.model.dart';
import 'package:mukai/components/app_bar.dart';
import 'package:mukai/constants.dart';
import 'package:mukai/src/controllers/cooperative-member-approvals.controller.dart';
import 'package:mukai/src/controllers/loan.controller.dart';
import 'package:mukai/src/controllers/profile_controller.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/utils/helper/helper_controller.dart';
import 'package:mukai/utils/utils.dart';

class LoanDetailScreen extends StatefulWidget {
  final Loan loan;
  final String? status;
  final Group? group;

  const LoanDetailScreen({
    super.key,
    required this.loan,
    this.status,
    this.group,
  });

  @override
  State<LoanDetailScreen> createState() => _LoanDetailScreenState();
}

class _LoanDetailScreenState extends State<LoanDetailScreen> {
  TextEditingController purposeController = TextEditingController();
  TextEditingController collateralDescriptionController =
      TextEditingController();
  TextEditingController paybackPeriodController = TextEditingController();
  TextEditingController principalAmountController = TextEditingController();
  TextEditingController repaymentAmountController = TextEditingController();
  LoanController loanController = Get.put(LoanController());
  CooperativeMemberApprovalsController cmaController =Get.find<CooperativeMemberApprovalsController>();
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
    // Initialize controllers with loan data
    purposeController.text = widget.loan.loanPurpose ?? '';
    collateralDescriptionController.text =
        widget.loan.collateralDescription ?? '';
    paybackPeriodController.text = widget.loan.loanTermMonths?.toString() ?? '';
    principalAmountController.text =
        widget.loan.principalAmount?.toStringAsFixed(2) ?? '';
    repaymentAmountController.text =
        widget.loan.paymentAmount?.toStringAsFixed(2) ?? '';
  }

  @override
  Widget build(BuildContext context) {
    loanController.isLoading.value = false;
    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;
    return Scaffold(
        appBar: MyAppBar(
          widget: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Utils.trimp(widget.loan.loanPurpose ?? 'Loan Details'),
                style: semibold18WhiteF5,
              ),
              Text(
                "Loan ID: ${widget.loan.id?.substring(28, 36) ?? ''}",
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
                value: purposeController.text,
              ),
              const SizedBox(height: 16),
              _buildDetailField(
                label: 'Principal Amount',
                value: '${principalAmountController.text}',
              ),
              const SizedBox(height: 16),
              _buildDetailField(
                label: 'Payback Period (months)',
                value: paybackPeriodController.text,
              ),
              const SizedBox(height: 16),
              _buildDetailField(
                label: 'Total Repayment Amount',
                value: repaymentAmountController.text,
              ),
              if (widget.loan.collateralDescription?.isNotEmpty ?? false) ...[
                const SizedBox(height: 16),
                /*
                _buildDetailField(
                  label: 'Collateral Description',
                  value: collateralDescriptionController.text,
                ),
                */
                // _buildDropdownField(
                //   label: 'Collateral',
                //   value: widget.loan.collateralDescription ?? '',
                //   options: [
                //     'Car',
                //     'House',
                //     'Savings account',
                //   ],
                //   onChanged: (newValue) {
                //     // Handle dropdown selection
                //     setState(() {
                //       widget.loan.status = newValue;
                //     });
                //   },
                // )
              ],
              const SizedBox(height: 24),
              Text(
                '* Calculated at 2% monthly compound interest',
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
            ? pollSummary(widget.loan)
            : requestSummary(widget.loan));
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
            value.isNotEmpty ? value : 'Not specified',
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
          // loanController.updateUser();
          // Navigator.pop(context);
        },
        child: Obx(() => loanController.isLoading.value == true
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
          // loanController.updateUser();
          // Navigator.pop(context);
        },
        child: Obx(() => loanController.isLoading.value == true
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

  requestSummary(Loan loan) {
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
                    title: 'Confirm Loan',
                    middleText: 'Confirm loan approval',
                    textConfirm: 'OK',
                    confirmTextColor: whiteColor,
                    onConfirm: () async {
                      if (loan.id != null) {
                        loanController.selectedLoan.value.id = loan.id!;
                        loanController.selectedLoan.value.status = 'approved';
                        loanController.selectedLoan.value.updatedAt =
                            DateTime.now().toIso8601String();
                        await loanController.updateLoan();
                        Navigator.pop(context);
                        Get.back();
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
                    title: 'Reject loan',
                    middleText: 'Confirm loan rejection',
                    textConfirm: 'OK',
                    confirmTextColor: whiteColor,
                    onConfirm: () async {
                      // await loanController.deleteLoan(loan.id!);
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

  pollSummary(Loan loan) {
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
                cmaController.cma.value.groupId = widget.group!.id;
                cmaController.cma.value.profileId = userId;
                cmaController.cma.value.pollDescription = 'loan application';
                cmaController.cma.value.additionalInfo =
                    widget.loan.principalAmount;
                cmaController.cma.value.supportingVotes = [userId!];

                // log('loan id: ${widget.loan.id}');
                // loanController.selectedLoan.value.id = widget.loan.id;
                // loanController.selectedCoop.value.id = widget.group!.id;
                // loanController.selectedProfile.value.id = userId;
                // loanController.isSupporting.value = true;
                try {
                  final response = await cmaController.updatePoll();
                  // log(response.toString())
                  // final response = await loanController.updateLoanApproval();
                  // log('LoanDetail polling response:\n${JsonEncoder.withIndent(' ').convert(response.data)}');
                  // if (response!['data'] == "You have voted already") {
                  //   Helper.warningSnackBar(
                  //       title: 'Duplicate vote',
                  //       message: response['data'],
                  //       duration: 5);
                  // } else {
                  //   Helper.successSnackBar(
                  //       title: 'Success!',
                  //       message: 'You have cast your vote',
                  //       duration: 5);
                  // }
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
                        'Supportttt',
                        style: bold16White,
                      ),
                    ],
                  )),
            ),
            GestureDetector(
              onTap: () async {
                // log('I oppose');
                loanController.selectedLoan.value.id = widget.loan.id;
                loanController.selectedCoop.value.id = widget.group!.id;
                loanController.selectedProfile.value.id = userId;
                loanController.isSupporting.value = false;
                try {
                  // log(params.toString());
                  final response = await loanController.updateLoanApproval();
                  // log('LoanDetail polling response:\n${JsonEncoder.withIndent(' ').convert(response.data)}');
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
