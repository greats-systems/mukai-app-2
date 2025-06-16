/*
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
//import 'package:appwrite/appwrite.dart' as appwrite;
import 'package:mukai/constants.dart' as constants;
import 'package:mukai/brick/models/cooperative-member-request.model.dart';
import 'package:mukai/src/apps/chats/schema/chat.dart';
import 'package:mukai/src/apps/chats/views/screen/notifications/process_request.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/utils/utils.dart';
import 'package:mukai/widget/render_supabase_image.dart';
// import 'package:mukai/brick/models/chat.model.dart';

class NotificationTile extends StatelessWidget {
  // final List<CooperativeMemberRequest> requests;
  final List<Chat> chats; 

  NotificationTile({super.key, required this.chats});

  bool isToday(String dateString) {
    final date = DateTime.parse(dateString);
    final formattedDate = DateFormat.yMMMd().format(date);
    final todayFormattedDate = DateFormat.yMMMd().format(DateTime.now());

    return formattedDate == todayFormattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        final width = MediaQuery.of(context).size.width;

        // Safe null handling for names
        final firstName = chat.f  .trim() ?? 'Unknown';
        final lastName = request.profileLastName?.trim() ?? '';

        // Handle null content
        final content = request.message?.trim() ?? 'No message';
        final contentIcon = _getContentIcon(request.mostRecentContentFormat);

        // Handle null timestamp
        final timestampText = request.updatedAt != null
            ? _formatTimestamp(request.updatedAt!)
            : 'Time unknown';

        return ListTile(
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'from ${Utils.trimp(firstName)}${lastName.isNotEmpty ? ' ${Utils.trimp(lastName)}' : ''}',
                style: regular14Black,
              ),
            ],
          ),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (contentIcon != null) contentIcon,
                  SizedBox(width: 4),
                  SizedBox(
                    width: width * 0.5,
                    child: AutoSizeText(
                      Utils.trimp(content).tr,
                      style: medium14Black,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              if (timestampText.isNotEmpty)
                Text(
                  timestampText,
                  style: const TextStyle(color: blackColor, fontSize: 10),
                ),
            ],
          ),
          onTap: () {
            Get.to(ProcessRequest(request: request));
          },
        );
      },
    );
  }

  Widget? _getContentIcon(String? format) {
    if (format == 'file' || format == 'image') {
      return const Icon(
        Icons.picture_as_pdf,
        color: Colors.red,
        size: 20,
      );
    }
    return null;
  }

  String _formatTimestamp(String? timestamp) {
    if (timestamp == null) return '';

    final dateTime = DateTime.parse(timestamp);
    return isToday(timestamp)
        ? Utils.formatTime(dateTime)
        : DateFormat.yMMMd().format(dateTime);
  }

  picInfo(profileImageUrl) {
    return profileImageUrl != null
        ? ClipOval(
            // borderRadius: BorderRadius.circular(20), // Image border
            child: SizedBox.fromSize(
              size: const Size.fromRadius(20), // Image radius
              child: RenderSupabaseImageIdWidget(filePath: profileImageUrl),
            ),
          )
        : Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: blackColor,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: const Icon(
              Icons.person_2_rounded,
              color: whiteF5Color,
              size: 30,
            ),
          );
  }

  Widget cachedImage(String id) {
    var url = '${constants.APP_API_ENDPOINT}/assets/${id}';
    return CachedNetworkImage(
      width: 60.0,
      height: 60.0,
      fit: BoxFit.cover,
      imageUrl: url,
      errorWidget: _error,
      progressIndicatorBuilder: _progressIndicator,
    );
  }

  Widget _progressIndicator(
      BuildContext context, String url, downloadProgress) {
    return Center(
      child: CircularProgressIndicator(value: downloadProgress.progress),
    );
  }

  Widget _error(BuildContext context, String url, Object error) {
    return const Center(child: Icon(Icons.error));
  }
}
*/