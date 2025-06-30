import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ri.dart';
import 'package:mukai/brick/models/cooperative-member-approval.model.dart';
import 'package:mukai/src/controllers/cooperative-member-approvals.controller.dart';
import 'package:mukai/theme/theme.dart';

class PollItemWidget extends StatefulWidget {
  final CooperativeMemberApproval? cma;
  const PollItemWidget({super.key, required this.cma});

  @override
  State<PollItemWidget> createState() => _PollItemWidgetState();
}

class _PollItemWidgetState extends State<PollItemWidget> {
  CooperativeMemberApprovalsController get loanController => Get.put(CooperativeMemberApprovalsController());

  void initState() {
    super.initState();
    // log('PollItemWidget cma: ${widget.cma?.hasReceivedVote}');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        heightSpace,
        _buildPollDetail(widget.cma),
        heightSpace,
        _buildStatusSection(widget.cma),
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

  Widget _buildStatusSection(CooperativeMemberApproval? cma) {
    if (cma != null) {
      switch (cma.pollDescription) {
        case 'request':
        case 'declined':
          return _buildRequestSummary(cma);
        default:
          return _buildPollSummary(cma);
      }
    } else {
      return Center(
        child: Text('No cma'),
      );
    }
  }

  Widget _buildPollDetail(CooperativeMemberApproval? cma) {
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;
  
  if (cma == null) {
    return Center(child: Text('No polls'));
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
                  cma.pollDescription ?? 'No description',
                  style: semibold12black,
                  overflow: TextOverflow.ellipsis,
                ),
                height5Space,
                _buildPollInfo(cma),
              ],
            ),
            SizedBox(
              width: height/8,
              height: width/8,
              child: Card(
                color: cma.supportingVotes != null || cma.opposingVotes != null
                    ? tertiaryColor
                    : primaryColor,
                child: Center(
                  child: Text(
                    cma.supportingVotes != null || cma.opposingVotes != null
                        ? 'Voting underway'
                        : 'Pending vote', 
                    style: TextStyle(
                      fontSize: 12, 
                      fontWeight: FontWeight.bold,
                      color: whiteColor
                    ),
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
/*
  Widget _buildInterestInfo(CooperativeMemberApproval? cma) {
    return cma != null
        ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${(cma.interestRate! * 100).toStringAsFixed(0)}%',
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
  */

  Widget _buildPollInfo(CooperativeMemberApproval? cma) {
    return cma != null
        ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    cma.numberOfMembers.toString(),
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
                    cma.interestRate.toString(),
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

  Widget _buildPollSummary(CooperativeMemberApproval? cma) {
    return cma != null
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: 20,
                children: [
                  _buildMoneyColumn(
                      'Supporting votes', cma.supportingVotes.toString()),
                  _buildInfoColumn('Account ID',
                      cma.id != null ? cma.id!.substring(0, 8) : 'N/A'),
                  _buildInfoColumn('Opposing votes',
                      cma.opposingVotes.toString() ?? 'N/A'),
                ],
              ),
              // _buildChatButton(cma),
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

  Widget _buildChatButton(CooperativeMemberApproval? cma) {
    final size = MediaQuery.sizeOf(context);
    final width = size.width;
    final height = size.height;
    return InkWell(
      onTap: () => log('Tapped'),
      // onTap: () => _navigateToConversation(cma),
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

  Widget _buildRequestSummary(CooperativeMemberApproval? cma) {
    return cma != null
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.cma!.updatedAt != 'declined') ...[
                  _buildActionButton(
                    'Accept',
                    primaryColor,
                    () => _showConfirmationDialog(cma, true),
                  ),
                  _buildActionButton(
                    'Decline',
                    redColor,
                    () => _showConfirmationDialog(cma, false),
                  ),
                ],
                _buildChatButton(cma),
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

  void _showConfirmationDialog(CooperativeMemberApproval? cma, bool isAccept) {
    final action = isAccept ? 'accept' : 'decline';
    final name = cma?.groupId;
    final id = cma?.id?.substring(0, 8) ?? '';

    Get.defaultDialog(
      middleTextStyle: const TextStyle(color: blackColor, fontSize: 14),
      buttonColor: primaryColor,
      backgroundColor: tertiaryColor,
      title: 'Pollship Request',
      middleText: 'Are you sure you want to $action $name Request ID $id?',
      textConfirm: 'Yes, ${isAccept ? 'Accept' : 'Decline'}',
      confirmTextColor: whiteColor,
      onConfirm: () async {
        if (cma?.id != null) {
          log('Accepted');
          /*
          await loanController.updatePollRequest(
              cma?.id, isAccept ? 'accepted' : 'declined');
              */
        }
      },
      cancelTextColor: redColor,
      onCancel: () => Get.back(),
    );
  }
  /*
  void _navigateToConversation(Poll? cma) {
    Get.to(() => ConversationPage(
        firstName: _getFullName(cma),
        receiverId: cma?.id ?? Uuid().v4(),
        conversationId: Uuid().v4(),
        receiverFirstName: _getFirstName(cma),
        receiverLastName: cma?.last_name ?? ''));
  }

  String _getFullName(Poll? cma) {
    return '${Utils.trimp(cma?.first_name ?? '')} '
        '${Utils.trimp(cma?.last_name ?? '')}';
  }

  String _getFirstName(Poll? cma) {
    return Utils.trimp(cma?.first_name ?? '');
  }
  */
}
