import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ri.dart';
import 'package:mukai/brick/models/loan.model.dart';
import 'package:mukai/brick/models/saving.model.dart';
import 'package:mukai/src/controllers/loan.controller.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/utils/utils.dart';

class SavingItemWidget extends StatefulWidget {
  final Saving? saving;
  const SavingItemWidget({super.key, required this.saving});

  @override
  State<SavingItemWidget> createState() => _SavingItemWidgetState();
}

class _SavingItemWidgetState extends State<SavingItemWidget> {
  LoanController get loanController => Get.put(LoanController());

  void initState() {
    super.initState();
    log('SavingItemWidget saving: ${widget.saving?.id}');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        heightSpace,
        _buildSavingDetail(widget.saving),
        heightSpace,
        heightSpace,
        _buildStatusSection(widget.saving),
      ],
    );
  }

  Widget _buildStatusSection(Saving? saving) {
    if (saving != null) {
      return _buildAccountSummary(saving);
    } else {
      return Center(
        child: Text('No loan'),
      );
    }
  }

  Widget _buildSavingDetail(Saving? saving) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    if (saving == null) {
      return Center(child: Text('No saving'));
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Utils.trimp(
                        'Created on ${Utils.formatDateTime(DateTime.parse(saving.createdAt!))}'),
                    style: semibold15black,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    Utils.trimp(saving.purpose ?? 'No saving purpose'),
                    style: semibold15black,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              SizedBox(
                width: height / 8,
                height: width / 8,
                child: Card(
                  color: saving.isLocked == true ? tertiaryColor : primaryColor,
                  child: Center(
                    child: Text(
                      saving.isLocked == true ? 'Locked' : 'Unlocked',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: whiteColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInterestInfo(Loan? loan) {
    return loan != null
        ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${(loan.interestRate! * 100).toStringAsFixed(0)}%',
                    style: semibold14Primary,
                  ),
                ],
              ),
            ],
          )
        : Center(
            child: Text('No account info to build'),
          );
  }

  Widget _buildPrincipalAmountInfo(Saving? saving) {
    return saving != null
        ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${saving.currentBalance.toString()}',
                    style: semibold14Primary,
                  ),
                ],
              ),
              /*
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Interest', style: semibold14Primary),
                  Text(
                    loan.interestRate.toString(),
                    style: semibold14Primary,
                  ),
                ],
              ),
              */
            ],
          )
        : Center(
            child: Text('No account info to build'),
          );
  }

  Widget _buildAccountSummary(Saving? saving) {
    return saving != null
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 20,
            children: [
              _buildMoneyColumn(
                  'Current Balance', saving.currentBalance.toString()),
              _buildInfoColumn(
                  'Locked By', Utils.trimp(saving.lockFeature!) ?? 'N/A'),
              if (saving.lockFeature == 'date')
                _buildInfoColumn(
                    'Lock', saving.id != null ? saving.lockDate! : '')
              else if (saving.lockFeature == 'milestone')
                _buildInfoColumn(
                    'Lock',
                    saving.id != null
                        ? saving.lockMilestones!.length.toString()
                        : '')
              else if (saving.lockFeature == 'event')
                _buildInfoColumn(
                    'Lock', saving.id != null ? saving.lockEvent! : '')
              else if (saving.lockFeature == 'amount')
                _buildInfoColumn('Lock Status',
                    saving.id != null ? saving.lockAmount.toString() : '')
              else
                _buildInfoColumn('Lock Status', 'N/A'),
            ],
          )
        : Center(
            child: Text('Cannot build account summary'),
          );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: semibold12black),
        height5Space,
        Text(value, style: semibold16Primary),
      ],
    );
  }

  Widget _buildMoneyColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: semibold12black),
        height5Space,
        Text('\$$value', style: semibold16Primary),
      ],
    );
  }

  Widget _buildChatButton(Saving? saving) {
    final size = MediaQuery.sizeOf(context);
    final width = size.width;
    final height = size.height;
    return InkWell(
      onTap: () => log('Tapped'),
      // onTap: () => _navigateToConversation(saving  ),
      child: Container(
        alignment: Alignment.center,
        height: height * 0.04,
        width: width * 0.1,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Iconify(Ri.chat_1_line, color: whiteF5Color),
      ),
    );
  }

  Widget _buildRequestSummary(Saving? saving) {
    return saving != null
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.saving!.status != 'declined') ...[
                  _buildActionButton(
                    'Accept',
                    primaryColor,
                    () => _showConfirmationDialog(saving, true),
                  ),
                  _buildActionButton(
                    'Decline',
                    redColor,
                    () => _showConfirmationDialog(saving, false),
                  ),
                ],
                _buildChatButton(saving),
              ],
            ),
          )
        : Center(
            child: Text('No summary'),
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

  void _showConfirmationDialog(Saving? saving, bool isAccept) {
    final action = isAccept ? 'accept' : 'decline';
    final name = saving?.profileId;
    final id = saving?.id?.substring(0, 8) ?? '';

    Get.defaultDialog(
      middleTextStyle: const TextStyle(color: blackColor, fontSize: 14),
      buttonColor: primaryColor,
      backgroundColor: tertiaryColor,
      title: 'Loanship Request',
      middleText: 'Are you sure you want to $action $name Request ID $id?',
      textConfirm: 'Yes, ${isAccept ? 'Accept' : 'Decline'}',
      confirmTextColor: whiteColor,
      onConfirm: () async {
        if (saving?.id != null) {
          log('Accepted');
          /*
          await loanController.updateLoanRequest(
              loan?.id, isAccept ? 'accepted' : 'declined');
              */
        }
      },
      cancelTextColor: redColor,
      onCancel: () => Get.back(),
    );
  }
  /*
  void _navigateToConversation(Loan? loan) {
    Get.to(() => ConversationPage(
        firstName: _getFullName(loan),
        receiverId: loan?.id ?? Uuid().v4(),
        conversationId: Uuid().v4(),
        receiverFirstName: _getFirstName(loan),
        receiverLastName: loan?.last_name ?? ''));
  }

  String _getFullName(Loan? loan) {
    return '${Utils.trimp(loan?.first_name ?? '')} '
        '${Utils.trimp(loan?.last_name ?? '')}';
  }

  String _getFirstName(Loan? loan) {
    return Utils.trimp(loan?.first_name ?? '');
  }
  */
}
