import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ri.dart';
import 'package:mukai/brick/models/loan.model.dart';
import 'package:mukai/src/controllers/loan.controller.dart';
import 'package:mukai/theme/theme.dart';

class LoanItemWidget extends StatefulWidget {
  final Loan? loan;
  const LoanItemWidget({super.key, required this.loan});

  @override
  State<LoanItemWidget> createState() => _LoanItemWidgetState();
}

class _LoanItemWidgetState extends State<LoanItemWidget> {
  LoanController get loanController => Get.put(LoanController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        heightSpace,
        _buildLoanDetail(widget.loan),
        heightSpace,
        _buildStatusSection(widget.loan),
        heightSpace,
        LinearProgressIndicator(
          value: 1,
          backgroundColor: primaryColor.withOpacity(0.2),
          color: redColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ],
    );
  }

  Widget _buildStatusSection(Loan? loan) {
    if (loan != null) {
      switch (loan.status) {
        case 'request':
        case 'declined':
          return _buildRequestSummary(loan);
        default:
          return _buildAccountSummary(loan);
      }
    } else {
      return Center(
        child: Text('No loan'),
      );
    }
  }

  Widget _buildLoanDetail(Loan? loan) {
    // final size = MediaQuery.of(context).size;
    return loan != null
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    // _buildLoanImage(loan),
                    // widthSpace,
                    // width5Space,
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                // _formatName(loan),
                                loan.loanPurpose ?? 'No loan purpose',
                                style: semibold12black,
                                overflow: TextOverflow.ellipsis,
                              ),
                              height5Space,
                              _buildPrincipalAmountInfo(loan),
                            ],
                          ),
                          // Column(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     Text(
                          //       // _formatName(loan),
                          //       'Interest rate',
                          //       style: semibold12black,
                          //       overflow: TextOverflow.ellipsis,
                          //     ),
                          //     height5Space,
                          //     _buildInterestInfo(loan),
                          //   ],
                          // ),
                          // SizedBox(width: size.width/20,)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        : Center(
            child: Text('No loan'),
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
                    '${(loan.interestRate!*100).toStringAsFixed(0)}%',
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

  Widget _buildPrincipalAmountInfo(Loan? loan) {
    return loan != null
        ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${loan.principalAmount.toString()}',
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

  Widget _buildAccountSummary(Loan? loan) {
    return loan != null
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: 20,
                children: [
                  _buildMoneyColumn(
                      'Remaining Balance', loan.remainingBalance.toString()),
                  _buildInfoColumn('Account ID',
                      loan.id != null ? loan.id!.substring(0, 8) : 'N/A'),
                      _buildInfoColumn('Loan term (months)',
                      loan.loanTermMonths.toString() ?? 'N/A'),
                ],
              ),
              // _buildChatButton(loan),
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

  Widget _buildChatButton(Loan? loan) {
    final size = MediaQuery.sizeOf(context);
    final width = size.width;
    final height = size.height;
    return InkWell(
      onTap: () => log('Tapped'),
      // onTap: () => _navigateToConversation(loan),
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

  Widget _buildRequestSummary(Loan? loan) {
    return loan != null
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.loan!.status != 'declined') ...[
                  _buildActionButton(
                    'Accept',
                    primaryColor,
                    () => _showConfirmationDialog(loan, true),
                  ),
                  _buildActionButton(
                    'Decline',
                    redColor,
                    () => _showConfirmationDialog(loan, false),
                  ),
                ],
                _buildChatButton(loan),
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

  void _showConfirmationDialog(Loan? loan, bool isAccept) {
    final action = isAccept ? 'accept' : 'decline';
    final name = loan?.profileId;
    final id = loan?.id?.substring(0, 8) ?? '';

    Get.defaultDialog(
      middleTextStyle: const TextStyle(color: blackColor, fontSize: 14),
      buttonColor: primaryColor,
      backgroundColor: tertiaryColor,
      title: 'Loanship Request',
      middleText: 'Are you sure you want to $action $name Request ID $id?',
      textConfirm: 'Yes, ${isAccept ? 'Accept' : 'Decline'}',
      confirmTextColor: whiteColor,
      onConfirm: () async {
        if (loan?.id != null) {
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
