import 'dart:async';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mukai/brick/models/profile.model.dart';
import 'package:mukai/constants.dart';
import 'package:mukai/main.dart';
import 'package:mukai/src/controllers/auth.controller.dart';
import 'package:mukai/src/apps/chats/schema/message.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/utils/helper/helper_controller.dart';
import 'package:mukai/widget/render_supabase_image.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeago/timeago.dart';
import 'package:mukai/constants.dart' as constants;

class ConversationPage extends StatefulWidget {
  static const String route = '/conversation-page';

  final String firstName;
  final String? profileImageUrl;
  final String receiverId;
  final String receiverFirstName;
  final String receiverLastName;
  final String conversationId;

  const ConversationPage({
    required this.firstName,
    this.profileImageUrl,
    required this.receiverId,
    required this.conversationId,
    required this.receiverFirstName,
    required this.receiverLastName,
  });

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  late final Stream<List<Message>> _messagesStream;
  final Map<String, Profile> _profileCache = {};
  final GetStorage _getStorage = GetStorage();
  String? userId;

  void feichUserId() async {
    final id = await _getStorage.read('userId');
    setState(() {
      userId = id;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeMessagesStream();
  }

  void _initializeMessagesStream() {
    final userId =
        _getStorage.read('userId') ?? 'cc77061e-0357-4129-8259-2b3be947a0e2';
    final refKey = _generateChatRefKey(userId, widget.receiverId);

    _messagesStream = supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('ref_key', refKey)
        .order('message_timestamp')
        .map((maps) => maps
            .map((map) => Message.fromMap(map: map, myUserId: userId))
            .toList());
  }

  String _generateChatRefKey(String senderId, String receiverId) {
    return senderId.compareTo(receiverId) < 0
        ? '$senderId-$receiverId'
        : '$receiverId-$senderId';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () => Get.back(),
            ),
            CircleAvatar(
              radius: 30,
              child: widget.profileImageUrl != null
                  ? RenderSupabaseImageIdWidget(
                      filePath: widget.profileImageUrl!)
                  : Text('No avatar'),
            ),
            const SizedBox(width: 10),
            Text(
              widget.firstName,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: StreamBuilder<List<Message>>(
        stream: _messagesStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return preloader;

          final messages = snapshot.data!;
          return Column(
            children: [
              Expanded(
                child: messages.isEmpty
                    ? const Center(
                        child: Text('Start your conversation now :)'))
                    : ListView.builder(
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          return _ChatBubble(
                            message: message,
                            profile: _profileCache[message.profileId],
                          );
                        },
                      ),
              ),
              _MessageBar(
                receiverId: widget.receiverId,
                receiverAvatarId: widget.profileImageUrl ?? '',
                receiverFirstName: widget.receiverFirstName,
                receiverLastName: widget.receiverLastName,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MessageBar extends StatefulWidget {
  final String receiverId;
  final String receiverFirstName;
  final String receiverLastName;
  final String receiverAvatarId;

  const _MessageBar({
    required this.receiverId,
    required this.receiverAvatarId,
    required this.receiverFirstName,
    required this.receiverLastName,
  });

  @override
  State<_MessageBar> createState() => _MessageBarState();
}

class _MessageBarState extends State<_MessageBar> {
  late final TextEditingController _textController;
  final GetStorage _getStorage = GetStorage();

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  String _generateChatRefKey(String senderId, String receiverId) {
    log('$senderId-$receiverId\n$receiverId-$senderId');
    return senderId.compareTo(receiverId) < 0
        ? '$senderId-$receiverId'
        : '$receiverId-$senderId';
  }

  Future<void> _submitMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _textController.clear();
    final accountController = Get.find<AuthController>();
    final userId = _getStorage.read('userId');
    final refKey = _generateChatRefKey(userId, widget.receiverId);
    final messageTimestamp = DateTime.now().toString();

    try {
      final chat = await supabase.from('chats').select().eq('ref_key', refKey);
      log('chat: $chat');
      String chatId = chat.isEmpty
          ? await _createNewChat(refKey, accountController, messageTimestamp)
          : chat[0]['id'];

      await _insertMessage(refKey, chatId, userId, text, messageTimestamp);
      await _updateChat(chatId, text, messageTimestamp);
      await _sendNotification(accountController, chatId, refKey, text);
    } on PostgrestException catch (error, st) {
      log('_submitMessage PostgrestException: $error, $st');
      Helper.errorSnackBar(
          title: 'PostgrestException', message: error.toString(), duration: 5);
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text(error.message)));
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('An error occurred')));
    }
  }

  Future<String> _createNewChat(
    String refKey,
    AuthController accountController,
    String messageTimestamp,
  ) async {
    final userId = await accountController.fetchUserId();
    log('_createNewChat userId: $userId');
    final newChat = await supabase
        .from('chats')
        .insert({
          'ref_key': refKey,
          'receiver_id': widget.receiverId,
          'receiver_avatar_id': widget.receiverAvatarId,
          'receiver_first_name': widget.receiverFirstName,
          'receiver_last_name': widget.receiverLastName,
          // 'profile_id_text': accountController.person.value.id,
          'profile_id': userId,
          'profile_avatar_id': accountController.person.value.profile_image_id,
          'profile_first_name': accountController.person.value.first_name,
          'profile_last_name': accountController.person.value.last_name,
        })
        .select()
        .single();
    log('_createNewChat: $newChat');
    return newChat['id'];
  }

  Future<void> _insertMessage(
    String refKey,
    String chatId,
    String userId,
    String text,
    String messageTimestamp,
  ) async {
    await supabase.from('messages').insert({
      'ref_key': refKey,
      'chat_id': chatId,
      'profile_id': userId,
      'content': text,
      'message_timestamp': messageTimestamp,
    });
  }

  Future<void> _updateChat(
    String chatId,
    String text,
    String messageTimestamp,
  ) async {
    await supabase.from('chats').update({
      'most_recent_content': text,
      'most_recent_content_time': messageTimestamp,
      'most_recent_content_format': 'text',
    }).eq('id', chatId);
  }

  Future<void> _sendNotification(
    AuthController accountController,
    String chatId,
    String refKey,
    String text,
  ) async {
    await GetConnect().post(
      '${EnvConstants.APP_API_ENDPOINT}/notify/v1/message_notification',
      {
        "user_id": accountController.person.value.id,
        "message": "message notification",
        "notify": {
          "message": text,
          "chat_id": chatId,
          "ref_key": refKey,
          "receiver_id": widget.receiverId,
          "sender_id": accountController.person.value.id,
          "time": DateFormat.Hm().format(DateTime.now()).toString(),
        },
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey[200],
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _textController,
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Type a message',
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.all(8),
                  ),
                ),
              ),
              TextButton(
                onPressed: _submitMessage,
                child: Text(
                  'Send',
                  style: TextStyle(color: primaryColor.withValues(alpha: 0.5)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final Message message;
  final Profile? profile;

  const _ChatBubble({
    required this.message,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final chatContents = [
      Column(
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: message.isMine
                    ? primaryColor.withValues(alpha: 0.5)
                    : const Color.fromRGBO(224, 224, 224, 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(message.content),
            ),
          ),
        ],
      ),
      const SizedBox(width: 12),
      Text(format(message.createdDate ?? DateTime.now(), locale: 'en_short')),
      const SizedBox(width: 60),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
      child: Row(
        mainAxisAlignment:
            message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children:
            message.isMine ? chatContents.reversed.toList() : chatContents,
      ),
    );
  }
}
