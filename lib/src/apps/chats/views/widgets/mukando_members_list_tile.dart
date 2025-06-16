import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mukai/brick/models/profile.model.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/utils/utils.dart';
import 'package:mukai/widget/render_supabase_image.dart';

class MukandoMembersListTile extends StatelessWidget {
  final Profile groupMember;
  const MukandoMembersListTile({super.key, required this.groupMember});

  bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    final contentIcon = const SizedBox();
    final width = MediaQuery.of(context).size.width;
    final timestamp = DateTime.now();
    final timestampText = isToday(timestamp)
        ? Utils.formatTime(timestamp)
        : DateFormat.yMMMd().format(timestamp);

    return ListTile(
      leading: picInfo(null),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(groupMember.email ?? 'No name', style: bold16Black),
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
                  Utils.trimp('No data'),
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
        log('Member: ${groupMember.first_name}');
        // log('ConversationTile onTap:\nisMine: $isMine\nreceiverId: ${chat.reciever_id}\nprofileId: ${chat.profile_id}');
        /*
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
        */
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
}
