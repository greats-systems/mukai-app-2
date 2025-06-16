import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';

// @ConnectOfflineFirstWithSupabase(
//   restConfig: RestSerializable(
//     endpoint: r'''/chats''',
//   ),
// )
class Chat extends OfflineFirstWithSupabaseModel {
  Chat({
    this.id,
    this.refKey,
    this.receiverId,
    this.receiverAvatarId,
    this.receiverFirstName,
    this.receiverLastName,
    this.profileId,
    this.profileAvatarId,
    this.profileFirstName,
    this.profileLastName,
    this.mostRecentContent,
    this.mostRecentContentFormat,
  });

  final String? id;
  final String? refKey;
  final String? receiverId;
  final String? receiverAvatarId;
  final String? receiverFirstName;
  final String? receiverLastName;
  final String? profileId;
  final String? profileAvatarId;
  final String? profileFirstName;
  final String? profileLastName;
  final String? mostRecentContent;
  final String? mostRecentContentFormat;

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        id: json['id'] as String?,
        refKey: json['ref_key'] as String?,
        receiverId: json['receiver_id'] as String?,
        receiverAvatarId: json['receiver_avatar_id'] as String?,
        receiverFirstName: json['receiver_first_name'] as String?,
        receiverLastName: json['receiver_last_name'] as String?,
        profileId: json['profile_id'] as String?,
        profileAvatarId: json['profile_avatar_id'] as String?,
        profileFirstName: json['profile_first_name'] as String?,
        profileLastName: json['profile_last_name'] as String?,
        mostRecentContent: json['most_recent_content'] as String?,
        mostRecentContentFormat: json['most_recent_content_format'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'ref_key': refKey,
        'receiver_id': receiverId,
        'receiver_avatar_id': receiverAvatarId,
        'receiver_first_name': receiverFirstName,
        'receiver_last_name': receiverLastName,
        'profile_id': profileId,
        'profile_avatar_id': profileAvatarId,
        'profile_first_name': profileFirstName,
        'profile_last_name': profileLastName,
        'most_recent_content': mostRecentContent,
        'most_recent_content_format': mostRecentContentFormat,
      };
}
