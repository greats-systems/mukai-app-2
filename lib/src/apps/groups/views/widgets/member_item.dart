import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ri.dart';
import 'package:mukai/brick/models/profile.model.dart';
import 'package:mukai/src/apps/chats/views/screen/conversation.dart';
import 'package:mukai/src/controllers/profile_controller.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/utils/utils.dart';
import 'package:mukai/widget/render_supabase_image.dart';
import 'package:uuid/uuid.dart';

class MemberItemWidget extends StatefulWidget {
  final Profile? profile;
  const MemberItemWidget({super.key, required this.profile});

  @override
  State<MemberItemWidget> createState() => _MemberItemWidgetState();
}

class _MemberItemWidgetState extends State<MemberItemWidget> {
  ProfileController get profileController => Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        heightSpace,
        _buildMemberDetail(widget.profile),
        heightSpace,
        _buildStatusSection(widget.profile),
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

  Widget _buildStatusSection(Profile? profile) {
    if (profile != null) {
      switch (profile.status) {
        case 'request':
        case 'declined':
          return _buildRequestSummary(profile);
        default:
          return _buildAccountSummary(profile);
      }
    } else {
      return Center(
        child: Text('No profile'),
      );
    }
  }

  Widget _buildMemberDetail(Profile? profile) {
    return profile != null
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    _buildProfileImage(profile),
                    widthSpace,
                    width5Space,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _formatName(profile),
                            style: semibold12black,
                            overflow: TextOverflow.ellipsis,
                          ),
                          height5Space,
                          _buildAccountInfo(profile),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        : Center(
            child: Text('No profile'),
          );
  }

  Widget _buildProfileImage(Profile? profile) {
    if (profile != null) {
      final imageUrl = profile.profile_image_url;
      return SizedBox(
        height: 50,
        width: 50,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: imageUrl != null && imageUrl.isNotEmpty
              ? RenderSupabaseImageIdWidget(filePath: imageUrl)
              : const Icon(Icons.image, size: 50.0, color: Colors.grey),
        ),
      );
    } else {
      return Center(
        child: Text('No profile image'),
      );
    }
  }

  String _formatName(Profile? profile) {
    if (profile != null) {
      final firstName = profile.first_name?.toUpperCase() ?? 'N';
      final lastName = profile.last_name?.toUpperCase() ?? '';
      final idSnippet = profile.id ?? '';
      return '$firstName $lastName';
    } else {
      return 'No name to format in member_item';
    }
  }

  Widget _buildAccountInfo(Profile? profile) {
    return profile != null
        ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Utils.trimp(profile.account_type ?? ''),
                    style: semibold14Primary,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Phone', style: semibold14Primary),
                  Text(
                    Utils.trimp(profile.phone ?? ''),
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

  Widget _buildAccountSummary(Profile? profile) {
    return profile != null
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: 20,
                children: [
                  _buildInfoColumn(
                      'Subs Balance', profile.wallet_balance.toString()),
                  _buildInfoColumn(
                      'Account ID', profile.id != null ? profile.id!.substring(0, 8) : 'N/A'),
                ],
              ),
              _buildChatButton(profile),
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

  Widget _buildChatButton(Profile? profile) {
    final size = MediaQuery.sizeOf(context);
    final width = size.width;
    final height = size.height;
    return InkWell(
      onTap: () => _navigateToConversation(profile),
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

  Widget _buildRequestSummary(Profile? profile) {
    return profile != null
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.profile!.status != 'declined') ...[
                  _buildActionButton(
                    'Accept',
                    primaryColor,
                    () => _showConfirmationDialog(profile, true),
                  ),
                  _buildActionButton(
                    'Decline',
                    redColor,
                    () => _showConfirmationDialog(profile, false),
                  ),
                ],
                _buildChatButton(profile),
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

  void _showConfirmationDialog(Profile? profile, bool isAccept) {
    final action = isAccept ? 'accept' : 'decline';
    final name = '${profile?.first_name?.toUpperCase() ?? ''} '
        '${profile?.last_name?.toUpperCase() ?? ''}';
    final id = profile?.id?.substring(0, 8) ?? '';

    Get.defaultDialog(
      middleTextStyle: const TextStyle(color: blackColor, fontSize: 14),
      buttonColor: primaryColor,
      backgroundColor: tertiaryColor,
      title: 'Membership Request',
      middleText: 'Are you sure you want to $action $name Request ID $id?',
      textConfirm: 'Yes, ${isAccept ? 'Accept' : 'Decline'}',
      confirmTextColor: whiteColor,
      onConfirm: () async {
        if (profile?.id != null) {
          await profileController.updateMemberRequest(
              profile?.id, isAccept ? 'accepted' : 'declined');
        }
      },
      cancelTextColor: redColor,
      onCancel: () => Get.back(),
    );
  }

  void _navigateToConversation(Profile? profile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConversationPage(
          firstName: _getFullName(profile),
          profileImageUrl: profile?.profile_image_url ?? '',
          receiverId: profile?.id ?? Uuid().v4(),
          receiverFirstName: _getFirstName(profile),
          receiverLastName: profile?.last_name ?? '',
          conversationId: Uuid().v4(),
        ),
      ),
    );
  }

  String _getFullName(Profile? profile) {
    return '${Utils.trimp(profile?.first_name ?? '')} '
        '${Utils.trimp(profile?.last_name ?? '')}';
  }

  String _getFirstName(Profile? profile) {
    return Utils.trimp(profile?.first_name ?? '');
  }
}
