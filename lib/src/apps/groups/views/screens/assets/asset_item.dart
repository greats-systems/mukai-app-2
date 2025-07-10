import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mukai/brick/models/asset.model.dart';
import 'package:mukai/brick/models/profile.model.dart';
import 'package:mukai/src/apps/chats/views/screen/conversation.dart';
import 'package:mukai/src/controllers/profile_controller.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/utils/utils.dart';
import 'package:mukai/widget/render_supabase_image.dart';
import 'package:uuid/uuid.dart';

class AssetItemWidget extends StatefulWidget {
  final Asset? asset;
  const AssetItemWidget({super.key, required this.asset});

  @override
  State<AssetItemWidget> createState() => _AssetItemWidgetState();
}

class _AssetItemWidgetState extends State<AssetItemWidget> {
  ProfileController get profileController => Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        heightSpace,
        _buildMemberDetail(widget.asset),
        heightSpace,
        _buildStatusSection(widget.asset),
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

  Widget _buildStatusSection(Asset? asset) {
    if (asset != null) {
      switch (asset.status) {
        case 'request':
        case 'declined':
          return _buildRequestSummary(asset);
        default:
          return _buildAccountSummary(asset);
      }
    } else {
      return Center(
        child: Text('No profile'),
      );
    }
  }

  Widget _buildMemberDetail(Asset? asset) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return asset != null
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _formatName(asset),
                                style: semibold12black,
                                overflow: TextOverflow.ellipsis,
                              ),
                              height5Space,
                              _buildAccountInfo(asset),
                            ],
                          ),
                       if (asset.hasReceivedVote!=null)   SizedBox(
                            width: height / 8,
                            height: width / 8,
                            child: Card(
                              color: asset.hasReceivedVote!
                                  ? tertiaryColor
                                  : primaryColor,
                              child: Center(
                                child: Text(
                                  asset.hasReceivedVote!
                                      ? 'Voting underway'
                                      : 'Pending vote',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: whiteF5Color),
                                ),
                              ),
                            ),
                          ),
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

  String _formatName(Asset? asset) {
    if (asset != null) {
      final title = asset.assetDescriptiveName?.toUpperCase() ?? 'N';
      final id = asset.id?.substring(28, 36) ?? '';
      return '$title - $id';
    } else {
      return 'No name to format';
    }
  }

  Widget _buildAccountInfo(Asset? asset) {
    return asset != null
        ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.6,
                    child: AutoSizeText(
                      maxLines: 2,
                      Utils.trimp(asset.assetDescription ?? ''),
                      style: regular14Black,
                    ),
                  ),
                ],
              ),
            ],
          )
        : Center(
            child: Text('No account info to build'),
          );
  }

  Widget _buildAccountSummary(Asset? asset) {
    return asset != null
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: 20,
                children: [
                  _buildInfoColumn('Fiat Value', asset.fiatValue.toString()),
                  _buildInfoColumn('Token Value', asset.tokenValue.toString()),
                  _buildInfoColumn(
                      'Valuation Currency', asset.valuationCurrency ?? ''),
                ],
              ),
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

  Widget _buildRequestSummary(Asset? asset) {
    return asset != null
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.asset!.status != 'declined') ...[
                  _buildActionButton(
                    'Accept',
                    primaryColor,
                    () => _showConfirmationDialog(asset, true),
                  ),
                  _buildActionButton(
                    'Decline',
                    redColor,
                    () => _showConfirmationDialog(asset, false),
                  ),
                ],
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

  void _showConfirmationDialog(Asset? asset, bool isAccept) {
    final action = isAccept ? 'accept' : 'decline';
    final name = '${asset?.assetDescription?.toUpperCase() ?? ''} '
        '${asset?.id?.toUpperCase() ?? ''}';
    final id = asset?.id?.substring(0, 8) ?? '';

    Get.defaultDialog(
      middleTextStyle: const TextStyle(color: blackColor, fontSize: 14),
      buttonColor: primaryColor,
      backgroundColor: tertiaryColor,
      title: 'Membership Request',
      middleText: 'Are you sure you want to $action $name Request ID $id?',
      textConfirm: 'Yes, ${isAccept ? 'Accept' : 'Decline'}',
      confirmTextColor: whiteColor,
      onConfirm: () async {
        if (asset?.id != null) {
          // await assetController.updateAssetRequest(
          //     asset?.id, isAccept ? 'accepted' : 'declined');
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
