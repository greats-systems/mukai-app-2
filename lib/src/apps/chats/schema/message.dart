// Flutter Equivalent for Django Message model

// import 'package:isar/isar.dart';
import 'package:mukai/utils/utilities.dart';
// part 'message.g.dart';

// @collection
class Message {
  late String? chatId;
  late String? id;
  // Id get isarId => fastHash(id!);
  late DateTime? createdDate;
  late DateTime? messageTimestamp;
  late DateTime? updatedDate;
  late String? text;
  late bool? isMe;
  late String? userId;
  late String? time;
  late String? image;
  late String? documentUrl;
  late String? fileName;
  late String? status;
  late bool? isRead;
  final String content;
  final bool isMine;
  final String profileId;
  final String? content_format;

  // @Backlink(to: 'messages')
  // final profile = IsarLink<Profile>();

  // @Backlink(to: 'messages')
  // final chat = IsarLink<Chat>();
  Message({
    this.id,
    required this.profileId,
    this.messageTimestamp,
    this.createdDate,
    this.updatedDate,
    required this.content,
    this.content_format,
    required this.isMine,
    this.text,
    this.isMe,
    this.chatId,
    this.userId,
    this.time,
    this.image,
    this.documentUrl,
    this.fileName,
    this.isRead,
    this.status,
  });
  Message.fromMap({
    required Map<String, dynamic> map,
    required String myUserId,
  })  : id = map['id'],
        profileId = map['profile_id'],
        content = map['content'],
        content_format = map['content_format'],
        createdDate = DateTime.parse(map['created_at']),
        messageTimestamp = DateTime.parse(map['message_timestamp']),
        isMine = myUserId == map['profile_id'];

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      createdDate: DateTime.parse(json['created_date']),
      updatedDate: DateTime.parse(json['updated_date']),
      text: json['text'],
      isMe: json['isMe'],
      userId: json['userId'],
      chatId: json['chatId'],
      time: json['time'],
      image: json['image'],
      documentUrl: json['documentUrl'],
      fileName: json['fileName'],
      status: json['status'],
      isRead: json['isRead'],
      id: json['id'],
      profileId: 'profile_id',
      content: 'content',
      isMine: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'isarId': isarId,
      'id': id,
      'isMe': isMe,
      'text': text,
      'chatId': chatId,
      'userId': userId,
      'time': time,
      'image': image,
      'documentUrl': documentUrl,
      'fileName': fileName,
      'status': status,
      'isRead': isRead,
    };
  }
}
