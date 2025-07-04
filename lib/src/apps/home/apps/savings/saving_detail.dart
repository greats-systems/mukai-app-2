import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
import 'package:mukai/brick/models/loan.model.dart';
import 'package:mukai/brick/models/group.model.dart';
import 'package:mukai/brick/models/saving.model.dart';
import 'package:mukai/components/app_bar.dart';
import 'package:mukai/src/controllers/loan.controller.dart';
import 'package:mukai/src/controllers/wallet.controller.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/utils/helper/helper_controller.dart';
import 'package:mukai/utils/utils.dart';

class SavingDetailScreen extends StatefulWidget {
  final Saving saving;
  final String? status;

  const SavingDetailScreen({
    super.key,
    required this.saving,
    this.status,
  });

  @override
  State<SavingDetailScreen> createState() => _SavingDetailScreenState();
}

class _SavingDetailScreenState extends State<SavingDetailScreen> {
  TextEditingController purposeController = TextEditingController();
  TextEditingController collateralDescriptionController =
      TextEditingController();
  TextEditingController lockAmountController = TextEditingController();
  TextEditingController currentBalanceController = TextEditingController();
  TextEditingController lockFeatureController = TextEditingController();
  TextEditingController lockKeyController = TextEditingController();
  LoanController loanController = Get.put(LoanController());
  final WalletController walletController = WalletController();

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
    super.initState();
    // Initialize controllers with loan data
    purposeController.text = widget.saving.purpose ?? '';
    collateralDescriptionController.text = widget.saving.purpose ?? '';
    lockAmountController.text = widget.saving.lockAmount?.toString() ?? '';
    currentBalanceController.text =
        widget.saving.currentBalance?.toStringAsFixed(2) ?? '';
    lockFeatureController.text = widget.saving.lockFeature!;
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
              Utils.trimp(widget.saving.purpose ?? 'Saving Details'),
              style: semibold18WhiteF5,
            ),
            Text(
              "Saving ID: ${widget.saving.id?.substring(28, 36) ?? ''}",
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
              label: 'Current Balance',
              value: '${currentBalanceController.text}',
            ),
            const SizedBox(height: 16),
            _buildDetailField(
              label: 'Lock Amount',
              value: lockAmountController.text,
            ),
            const SizedBox(height: 16),
            _buildDetailField(
              label: 'Locked By',
              value: lockFeatureController.text,
            ),
            Obx(() => walletController.unlockPortfolio.value == true
                ? Column(
                    children: [
                      height20Space,
                      Text(
                        'Enter Vault Key',
                        style: TextStyle(color: blackColor),
                      ),
                      height20Space,
                      TextField(
                        controller: lockKeyController,
                        onChanged: (value) =>
                            walletController.lockKey.value = value,
                        decoration: InputDecoration(
                          hintText: 'Enter Vault Key',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  )
                : SizedBox()),
            const SizedBox(height: 24),
            Obx(() => walletController.lockKey.value.isNotEmpty &&
                    walletController.lockKey.value.length == 16
                ? unlockButton(context)
                : SizedBox()),
            Obx(() => walletController.unlockPortfolio.value == true
                ? SizedBox()
                : widget.saving.isLocked == false
                    ? lockPortfolioBtn(context)
                    : supportButton(context))
          ],
        ),
      ),
    );
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
          log('${widget.saving.profileId}');
          walletController.unlockPortfolio.value = true;
          walletController.unlockPortfolio.refresh();
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
                  "Unlock Portfolio",
                  style: bold18White,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              )),
      ),
    );
  }

  lockPortfolioBtn(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: GestureDetector(
        onTap: () {
          lockPortfolioDialog();
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
                  "Lock Portfolio",
                  style: bold18White,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              )),
      ),
    );
  }

  unlockButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: GestureDetector(
        onTap: () {
          log('Unlock Portfolio');
          logoutDialog();
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
                  "Continue",
                  style: bold18White,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              )),
      ),
    );
  }

  logoutDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: whiteF5Color,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(fixPadding * 2.0),
            children: [
              Container(
                height: 48.0,
                width: 48.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: whiteColor.withOpacity(0.1),
                ),
                alignment: Alignment.center,
                child: const Iconify(
                  MaterialSymbols.lock_open_outline_sharp,
                  color: primaryColor,
                  size: 35,
                ),
              ),
              heightSpace,
              heightSpace,
              Obx(() => walletController.isLoading.value == true
                  ? const Text(
                      "Okay then unlocking your portfolio ...",
                      style: bold16Black,
                      textAlign: TextAlign.center,
                    )
                  : const Text(
                      "Are you sure you want to unlock this portfolio before reaching the goal that you set yourself?",
                      style: bold16Black,
                      textAlign: TextAlign.center,
                    )),
              heightSpace,
              heightSpace,
              Obx(() => walletController.isLoading.value
                  ? const Center(
                      child: LinearProgressIndicator(
                      minHeight: 1,
                      color: primaryColor,
                    ))
                  : Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              clipBehavior: Clip.hardEdge,
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: tertiaryColor,
                                boxShadow: recShadow,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(fixPadding),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: whiteColor.withOpacity(0.1),
                                ),
                                child: const Text(
                                  "Cancel",
                                  style: bold16Primary,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ),
                        widthSpace,
                        widthSpace,
                        Expanded(
                          child: GestureDetector(
                              onTap: () {
                                if (widget.saving.unlockKey ==
                                    lockKeyController.text) {
                                  walletController.unlockSavingPortfolio(
                                      widget.saving.id!,
                                      lockKeyController.text);
                                  Navigator.pop(context);
                                } else {
                                  Get.snackbar(
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: redColor,
                                      'Error',
                                      'Invalid unlock key',
                                      duration: const Duration(seconds: 5));
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(fixPadding),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: primaryColor,
                                  boxShadow: buttonShadow,
                                ),
                                child: const Text(
                                  "Unlock",
                                  style: bold16White,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )),
                        ),
                      ],
                    ))
            ],
          ),
        );
      },
    );
  }

  lockPortfolioDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: whiteF5Color,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(fixPadding * 2.0),
            children: [
              Container(
                height: 48.0,
                width: 48.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: whiteColor.withOpacity(0.1),
                ),
                alignment: Alignment.center,
                child: const Iconify(
                  MaterialSymbols.lock_open_outline_sharp,
                  color: primaryColor,
                  size: 35,
                ),
              ),
              heightSpace,
              heightSpace,
              Obx(() => walletController.isLoading.value == true
                  ? const Text(
                      "Okay then unlocking your portfolio ...",
                      style: bold16Black,
                      textAlign: TextAlign.center,
                    )
                  : Column(
                      children: [
                        const Text(
                          "Are you sure you want to lock this portfolio?",
                          style: bold16Black,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Save your unlock Key in a safe place ${widget.saving.unlockKey} ",
                          style: bold16Black,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )),
              heightSpace,
              heightSpace,
              Obx(() => walletController.isLoading.value
                  ? const Center(
                      child: LinearProgressIndicator(
                      minHeight: 1,
                      color: primaryColor,
                    ))
                  : Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              clipBehavior: Clip.hardEdge,
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: tertiaryColor,
                                boxShadow: recShadow,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(fixPadding),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: whiteColor.withOpacity(0.1),
                                ),
                                child: const Text(
                                  "Cancel",
                                  style: bold16Primary,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ),
                        widthSpace,
                        widthSpace,
                        Expanded(
                          child: GestureDetector(
                              onTap: () {
                                walletController
                                    .lockSavingPortfolio(widget.saving.id!);
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(fixPadding),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: primaryColor,
                                  boxShadow: buttonShadow,
                                ),
                                child: const Text(
                                  "Unlock",
                                  style: bold16White,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )),
                        ),
                      ],
                    ))
            ],
          ),
        );
      },
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
                // log('loan id: ${widget.loan.id}');
                // loanController.selectedLoan.value.id = widget.loan.id;
                // loanController.selectedCoop.value.id = widget.group!.id;
                loanController.selectedProfile.value.id = userId;
                loanController.isSupporting.value = true;
                try {
                  final response = await loanController.updateLoanApproval();
                  // log('LoanDetail polling response:\n${JsonEncoder.withIndent(' ').convert(response.data)}');
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
                // loanController.selectedLoan.value.id = widget.loan.id;
                // loanController.selectedCoop.value.id = widget.group!.id;
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
