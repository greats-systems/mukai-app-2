import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mukai/constants.dart';
import 'package:mukai/main.dart';
import 'package:mukai/src/controllers/auth.controller.dart';
import 'package:mukai/src/apps/chats/schema/chat.dart';
import 'package:mukai/src/controllers/profile_controller.dart';
// import 'package:mukai/src/bottom_bar.dart';
import 'package:mukai/theme/theme.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
//import 'package:appwrite/appwrite.dart' as appwrite;
import 'package:mukai/constants.dart' as constants;

class GroupConversationsList extends StatefulWidget {
  final int? index;
  GroupConversationsList({super.key, required this.index});

  @override
  _GroupConversationsListState createState() => _GroupConversationsListState();
}

class _GroupConversationsListState extends State<GroupConversationsList>
    with SingleTickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();
  AuthController get authController => Get.put(AuthController());
  ProfileController get profileController => Get.find<ProfileController>();

  final RxList<Map<String, String?>> names = <Map<String, String?>>[].obs;
  final RxBool isLoading = true.obs;
  final GetStorage _getStorage = GetStorage();
  late final Stream<List<Chat>> profileIdStream;
  late final Stream<List<Chat>> receiverIdStream;

  String? loggedInUserId;
  bool refresh = false;

  @override
  void initState() {
    super.initState();

    var userId =
        _getStorage.read('userId') ?? 'b35bd2e8-efcc-4824-9750-b5439c5d625e';
    log('GroupConversationsList userId: $userId');

    // Create two separate streams
    profileIdStream = supabase
        .from('group')
        .stream(primaryKey: ['id'])
        .eq('admin_id', userId)
        .order('created_at')
        .map((maps) =>
            maps.map((map) => Chat.fromMap(map: map, userId: userId)).toList());
    receiverIdStream = supabase
        .from('group')
        .stream(primaryKey: ['id'])
        .eq('admin_id', userId)
        .order('created_at')
        .map((maps) =>
            maps.map((map) => Chat.fromMap(map: map, userId: userId)).toList());
    /*
    profileIdStream = supabase
        .from('chats')
        .stream(primaryKey: ['id'])
        .eq('profile_id', userId)
        .order('created_at')
        .map((maps) =>
            maps.map((map) => Chat.fromMap(map: map, userId: userId)).toList());
    receiverIdStream = supabase
        .from('chats')
        .stream(primaryKey: ['id'])
        .eq('receiver_id', userId)
        .order('created_at')
        .map((maps) =>
            maps.map((map) => Chat.fromMap(map: map, userId: userId)).toList());
            */

    /*
    _chatsStream = supabase
        .from('chats')
        .stream(primaryKey: ['id'])
        .or('profile_id.eq.$userId,receiver_id.eq.$userId')
        .order('most_recent_content_time', ascending: false)
        .map((maps) =>
            maps.map((map) => Chat.fromMap(map: map, userId: userId)).toList());
            */
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isToday(String dateString) {
    final date = DateTime.parse(dateString);
    final formattedDate = DateFormat.yMMMd().format(date);
    final todayFormattedDate = DateFormat.yMMMd().format(DateTime.now());
    return formattedDate == todayFormattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Group chats'),
    );
  }

  /*
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Chat>>(
      stream: _chatsStream,
      builder: (context, snapshot) {
        log('StreamBuilder snapshot: ${snapshot.connectionState}, hasData: ${snapshot.hasData}, error: ${snapshot.error}');
        if (snapshot.hasError) {
          log('Stream error: ${snapshot.error}');
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.hasData) {
          final chats = snapshot.data!;
          log('snapshot: $chats');
          return Container(
            color: whiteF5Color,
            child: Column(
              children: [
                if (chats.isNotEmpty) searchTextField(),
                height5Space,
                chats.isEmpty
                    ? const Center(
                        child: Text('No chats found'),
                      )
                    : Expanded(
                        child: ListView.builder(
                          reverse: false,
                          itemCount: chats.length,
                          itemBuilder: (context, index) {
                            final chat = chats[index];
                            log('direct chat list: ${JsonEncoder.withIndent(' ').convert(chat)}');
                            // log('chat ${chat.toJson()}');
                            return ConversationTile(
                                chat: chat,
                                );
                          },
                        ),
                      ),
              ],
            ),
          );
        } else {
          return Center(
            child: Text('No groups'),
          );
        }
      },
    );
  }
  */

  searchTextField() {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      width: width * 0.8,
      height: height * 0.05,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: whiteF5Color,
        boxShadow: [
          BoxShadow(
            blurRadius: 4.0,
            spreadRadius: 1.0,
            color: blackColor.withValues(alpha: 0.25),
          ),
        ],
      ),
      child: TextField(
        controller: searchController,
        onChanged: (query) {
          // Update the list when the user types in the search bar
          profileController.filterProfiles(query);
        },
        style: medium14Black,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          focusedBorder: InputBorder.none,
          hintText: 'search chats...',
          hintStyle: medium15Grey,
          contentPadding: const EdgeInsets.only(bottom: 7.0),
          prefixIcon: const Icon(
            Icons.search,
            color: greyColor,
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              searchController.clear();
            },
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  picInfo(profileImageUrl) {
    return profileImageUrl != null
        ? ClipOval(
            // borderRadius: BorderRadius.circular(20), // Image border
            child: SizedBox.fromSize(
              size: const Size.fromRadius(20), // Image radius
              child: cachedImage(profileImageUrl),
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
    var url = '${EnvConstants.APP_API_ENDPOINT}/assets/$id';
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

  tabItem(text, number) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          text,
          style: medium14Black,
        ),
      ],
    );
  }
}
