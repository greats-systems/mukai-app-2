import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mukai/constants.dart' as constants;
import 'package:mukai/src/apps/chats/schema/chat.dart';
import 'package:mukai/src/apps/chats/views/screen/conversation.dart';
// import 'package:mukai/src/apps/chats/views/screen/conversation.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/utils/utils.dart';
import 'package:mukai/widget/render_supabase_image.dart';

class ConversationTile extends StatelessWidget {
  final Chat chat;
  const ConversationTile({super.key, required this.chat});

  bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    log(chat.reciever_id ?? 'no receiver id');
    final width = MediaQuery.of(context).size.width;
    final isMine = chat.isMine == true;

    // Extract names
    final firstName =
        isMine ? chat.reciever_first_name : chat.profile_first_name;
    final lastName = isMine ? chat.reciever_last_name : chat.profile_last_name;
    final displayName =
        '${Utils.trimp(firstName ?? '')} ${Utils.trimp(lastName ?? '')}'.trim();

    // Handle content format
    final contentIcon = chat.most_recent_content_format == 'file' ||
            chat.most_recent_content_format == 'image'
        ? const Icon(Icons.picture_as_pdf, color: Colors.red, size: 20)
        : const SizedBox();

    // Handle timestamp
    final timestamp = chat.most_recent_content_time != null
        ? DateTime.parse(chat.most_recent_content_time!)
        : DateTime.now();
    final timestampText = isToday(timestamp)
        ? Utils.formatTime(timestamp)
        : DateFormat.yMMMd().format(timestamp);

    return ListTile(
      leading:
          picInfo(isMine ? chat.reciever_avatar_id : chat.profile_avatar_id),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(displayName, style: bold16Black),
        ],
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              contentIcon,
              const SizedBox(width: 10),
              SizedBox(
                width: width * 0.5,
                child: AutoSizeText(
                  Utils.trimp(chat.most_recent_content ?? 'No data').tr,
                  style: medium14Black,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          Text(
            timestampText,
            style: const TextStyle(color: blackColor, fontSize: 10),
          ),
        ],
      ),
      onTap: () {
        // log('ConversationTile onTap:\nisMine: $isMine\nreceiverId: ${chat.reciever_id}\nprofileId: ${chat.profile_id}');
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConversationPage(
              firstName: displayName,
              profileImageUrl:
                  isMine ? chat.reciever_avatar_id : chat.profile_avatar_id ?? 'no avatar',
              receiverId:
                  isMine ? chat.reciever_id ?? '' : chat.profile_id ?? '',
              receiverFirstName: firstName ?? '',
              receiverLastName: lastName ?? '',
              conversationId: chat.id ?? '',
            ),
          ),
        );
        
      },
    );
  }

  Widget picInfo(String? profileImageUrl) {
    return profileImageUrl != null
        ? ClipOval(
            child: SizedBox.fromSize(
              size: const Size.fromRadius(20),
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
    final url = '${constants.APP_API_ENDPOINT}/assets/$id';
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
