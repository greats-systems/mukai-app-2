import 'dart:convert';
import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:isar/isar.dart';
import 'package:mukai/utils/utilities.dart';
// part 'chat.g.dart';

// @collection
class Chat {
  late String id;
  late String? chatId;
  late String? ref_key;
  late String? reciever_id;
  late String? reciever_avatar_id;
  late String? reciever_first_name;
  late String? reciever_last_name;
  late String? profile_id;
  late String? profile_avatar_id;
  late String? profile_first_name;
  late String? profile_last_name;
  late String? most_recent_content;
  late String? most_recent_content_format;
  late String? most_recent_content_time;
  // Id get isarId => fastHash(id);
  late DateTime? createdDate;
  late DateTime? updatedDate;
  late String? lastMessageCategory;
  late String? lastMessage;
  late String? timestamp;
  late String? image;
  late String? documentUrl;
  late String? fileName;
  late String? isMe;
  late String? userId;
  late String? userName;
  late String? profileImage;
  late String? lastMessageTime;
  late bool? isMine;

  late dynamic me;
  late dynamic user;

  // final messages = IsarLinks<Message>();

  Chat(
      {required this.id,
      this.createdDate,
      this.updatedDate,
      this.lastMessage,
      this.lastMessageCategory,
      this.lastMessageTime,
      this.isMe,
      this.ref_key,
      this.reciever_id,
      this.reciever_avatar_id,
      this.reciever_first_name,
      this.reciever_last_name,
      this.most_recent_content,
      this.most_recent_content_format,
      this.most_recent_content_time,
      this.profile_id,
      this.profile_avatar_id,
      this.profile_first_name,
      this.profile_last_name,
      this.me,
      this.user,
      this.chatId,
      this.userId,
      this.userName,
      this.profileImage,
      this.timestamp,
      this.image,
      this.documentUrl,
      this.isMine,
      this.fileName});
  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      createdDate: DateTime.parse(json['date_created']),
      updatedDate: DateTime.parse(json['date_updated']),
      isMe: json['isMe'],
      userId: json['userId'],
      me: json['me'],
      user: json['user'],
      chatId: json['chatId'],
      userName: json['user_name'],
      profileImage: json['profile_image_url'],
      timestamp: json['time'],
      lastMessage: json['last_message'],
      lastMessageCategory: json['last_message_category'],
      lastMessageTime: json['last_message_time'],
      id: json['id'],
    );
  }
  Chat.fromMap({
    required Map<String, dynamic> map,
    required String userId,
  }) {
    id = map['id'];
    ref_key = map['ref_key'];
    reciever_id = map['receiver_id'];
    reciever_avatar_id = map['reciever_avatar_id'];
    reciever_first_name = map['reciever_first_name'];
    reciever_last_name = map['reciever_last_name'];
    profile_id = map['profile_id'];
    profile_avatar_id = map['profile_avatar_id'];
    profile_last_name = map['profile_last_name'];
    profile_first_name = map['profile_first_name'];
    most_recent_content = map['most_recent_content'];
    most_recent_content_format = map['most_recent_content_format'];
    most_recent_content_time = map['most_recent_content_time'];
    isMine = userId == map['profile_id'];
    createdDate = DateTime.parse(map['created_at']);
    log('Chat.fromMap data: ${JsonEncoder.withIndent(' ').convert(map)}');
  }

  Map<String, dynamic> toJson() {
    return {
      'isMine': isMine,
      'id': id,
      'ref_key': ref_key,
      'reciever_id': reciever_id,
      'reciever_avatar_id': reciever_avatar_id,
      'reciever_first_name': reciever_first_name,
      'reciever_last_name': reciever_last_name,
      'profile_id': profile_id,
      'profile_avatar_id': profile_avatar_id,
      'profile_last_name': profile_last_name,
      'profile_first_name': profile_first_name,
      'most_recent_content': most_recent_content,
      'most_recent_content_format': most_recent_content_format,
      'most_recent_content_time': most_recent_content_time,
    };
  }
}
