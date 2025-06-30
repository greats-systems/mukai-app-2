import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ri.dart';
import 'package:mukai/brick/models/cooperative-member-approval.model.dart';
import 'package:mukai/src/controllers/profile_controller.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/utils/utils.dart';

class PollItemWidget extends StatefulWidget {
  final CooperativeMemberApproval? cma;
  const PollItemWidget({super.key, required this.cma});

  @override
  State<PollItemWidget> createState() => _PollItemWidgetState();
}

class _PollItemWidgetState extends State<PollItemWidget> {
  ProfileController get profileController => Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        heightSpace,
        _buildPollDetail(widget.cma),
        heightSpace,
        // _buildStatusSection(widget.cma),
        // heightSpace,
        LinearProgressIndicator(
          value: 1,
          backgroundColor: primaryColor.withOpacity(0.2),
          color: redColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ],
    );
  }

  /*
  Widget _buildStatusSection(CooperativeMemberApproval? cma) {
    if (cma != null) {
      switch (cma.supportingVotes) {
        case >0:
          return _buildRequestSummary(cma);
        default:
          return _buildAccountSummary(cma);
      }
    } else {
      return Center(
        child: Text('No cma'),
      );
    }
  }
  */

  Widget _buildPollDetail(CooperativeMemberApproval? cma) {
    return cma != null
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          height5Space,
                          _buildAccountInfo(cma),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        : Center(
            child: Text('No cma'),
          );
  }

  // Widget _buildProfileImage(CooperativeMemberApproval? cma) {
  //   if (cma != null) {
  //     final imageUrl = cma.profile_image_url;
  //     return SizedBox(
  //       height: 50,
  //       width: 50,
  //       child: ClipRRect(
  //         borderRadius: BorderRadius.circular(20),
  //         child: imageUrl != null && imageUrl.isNotEmpty
  //             ? RenderSupabaseImageIdWidget(filePath: imageUrl)
  //             : const Icon(Icons.image, size: 50.0, color: Colors.grey),
  //       ),
  //     );
  //   } else {
  //     return Center(
  //       child: Text('No cma image'),
  //     );
  //   }
  // }

  // String _formatName(CooperativeMemberApproval? cma) {
  //   if (cma != null) {
  //     final firstName = cma.first_name?.toUpperCase() ?? 'N';
  //     final lastName = cma.last_name?.toUpperCase() ?? '';
  //     final idSnippet = cma.id ?? '';
  //     return '$firstName $lastName';
  //   } else {
  //     return 'No name to format in member_item';
  //   }
  // }

  Widget _buildAccountInfo(CooperativeMemberApproval? cma) {
    return cma != null
        ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Poll',
                    style: semibold14Primary,
                  ),
                  Text(
                    Utils.trimp(cma.pollDescription ?? 'No description'),
                    style: semibold14Primary,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Number of members', style: semibold14Primary),
                  Text(
                    Utils.trimp(cma.numberOfMembers.toString()),
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

  // Widget _buildAccountSummary(CooperativeMemberApproval? cma) {
  //   return cma != null
  //       ? Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Row(
  //               spacing: 20,
  //               children: [
  //                 _buildInfoColumn(
  //                     'Subs Balance', cma.wallet_balance.toString()),
  //                 _buildInfoColumn('Account ID',
  //                     cma.id != null ? cma.id!.substring(0, 8) : 'N/A'),
  //               ],
  //             ),
  //             _buildChatButton(cma),
  //           ],
  //         )
  //       : Center(
  //           child: Text('Cannot build account summary'),
  //         );
  // }

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

  Widget _buildChatButton(CooperativeMemberApproval? cma) {
    final size = MediaQuery.sizeOf(context);
    final width = size.width;
    final height = size.height;
    return InkWell(
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

  /*
  Widget _buildRequestSummary(CooperativeMemberApproval? cma) {
    return cma != null
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.cma!.status != 'declined') ...[
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
  */

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

  // void _showConfirmationDialog(CooperativeMemberApproval? cma, bool isAccept) {
  //   final action = isAccept ? 'accept' : 'decline';
  //   final name = '${cma?.first_name?.toUpperCase() ?? ''} '
  //       '${cma?.last_name?.toUpperCase() ?? ''}';
  //   final id = cma?.id?.substring(0, 8) ?? '';

  //   Get.defaultDialog(
  //     middleTextStyle: const TextStyle(color: blackColor, fontSize: 14),
  //     buttonColor: primaryColor,
  //     backgroundColor: tertiaryColor,
  //     title: 'Membership Request',
  //     middleText: 'Are you sure you want to $action $name Request ID $id?',
  //     textConfirm: 'Yes, ${isAccept ? 'Accept' : 'Decline'}',
  //     confirmTextColor: whiteColor,
  //     onConfirm: () async {
  //       if (cma?.id != null) {
  //         await profileController.updateMemberRequest(
  //             cma?.id, isAccept ? 'accepted' : 'declined');
  //       }
  //     },
  //     cancelTextColor: redColor,
  //     onCancel: () => Get.back(),
  //   );
  // }
  // void _navigateToConversation(CooperativeMemberApproval? cma) {
  //   Get.to(() => ConversationPage(
  //       firstName: _getFullName(cma),
  //       receiverId: cma?.id ?? Uuid().v4(),
  //       conversationId: Uuid().v4(),
  //       receiverFirstName: _getFirstName(cma),
  //       receiverLastName: cma?.last_name ?? ''));
  // }

  // String _getFullName(CooperativeMemberApproval? cma) {
  //   return '${Utils.trimp(cma?.first_name ?? '')} '
  //       '${Utils.trimp(cma?.last_name ?? '')}';
  // }

  // String _getFirstName(CooperativeMemberApproval? cma) {
  //   return Utils.trimp(cma?.first_name ?? '');
  // }
}
