import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mukai/brick/models/cooperative-member-request.model.dart';
import 'package:mukai/constants.dart';
import 'package:mukai/main.dart';
import 'package:mukai/src/controllers/auth.controller.dart';
import 'package:mukai/src/apps/chats/schema/chat.dart';
import 'package:mukai/src/apps/chats/views/screen/notifications/widgets/notification_tile.dart';
import 'package:mukai/src/apps/chats/views/widgets/conversation_tile.dart';
import 'package:mukai/src/controllers/profile_controller.dart';
import 'package:mukai/src/controllers/chat.controller.dart';
import 'package:mukai/src/controllers/cooperative-member-requests.controller.dart';
import 'package:mukai/theme/theme.dart';
import 'package:rxdart/rxdart.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
//import 'package:appwrite/appwrite.dart' as appwrite;
import 'package:mukai/constants.dart' as constants;

class NotificationsList extends StatefulWidget {
  final int? index;
  NotificationsList({super.key, required this.index});

  @override
  _NotificationsListState createState() => _NotificationsListState();
}

class _NotificationsListState extends State<NotificationsList>
    with SingleTickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();
  AuthController get authController => Get.put(AuthController());
  ProfileController get profileController => Get.find<ProfileController>();
  final CooperativeMemberRequestController cooperativeMemberRequestController =
      CooperativeMemberRequestController();
  // final ChatController chatController = ChatController();

  final RxList<Map<String, String?>> names = <Map<String, String?>>[].obs;
  final RxBool isLoading = true.obs;
  // final GetStorage _getStorage = GetStorage();
  late final Stream<List<Chat>> _chatsStream;
  late final Stream<List<Chat>> profileIdStream;
  late final Stream<List<Chat>> receiverIdStream;

  List<CooperativeMemberRequest>? _requests;
  bool _isLoading = false;

  String? loggedInUserId;
  bool refresh = false;

  /*
  void _fetchData() async {
    setState(() {
      _isLoading = true;
    });
    final requests =
        await cooperativeMemberRequestController.getUnresolvedRequests();
    setState(() {
      _requests = requests;
      _isLoading = false;
    });
  }

  @override  
  void initState() {
    super.initState();
    _fetchData();
  }
  */

  @override
  void initState() {
    log('NotificationsList');
    var userId = authController.userId.value;
    // Create two separate streams
    profileIdStream = supabase
        .from('cooperative_member_requests')
        .stream(primaryKey: ['id'])
        // .eq('most_recent_content', 'pending approval')
        .eq('profile_id', userId)
        .order('most_recent_content_time')
        .map((maps) =>
            maps.map((map) => Chat.fromMap(map: map, userId: userId)).toList());
    receiverIdStream = supabase
        .from('cooperative_member_requests')
        .stream(primaryKey: ['id'])
        // .eq('most_recent_content', 'pending approval')
        .eq('receiver_id', userId)
        .order('most_recent_content_time')
        .map((maps) =>
            maps.map((map) => Chat.fromMap(map: map, userId: userId)).toList());
    _chatsStream = CombineLatestStream.list([
      profileIdStream,
      receiverIdStream,
    ]).map((listOfLists) {
      final allChats = listOfLists.expand((list) => list).toList();
      final uniqueChats = allChats.toSet().toList();
      return uniqueChats.map((chat) {
        return chat;
      }).toList();
    });
    super.initState();
  }

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
    /*
    return Center(
      child: _isLoading
          ? LoadingShimmerWidget()
          : _requests != null
              ? NotificationTile(requests: _requests!,)
              : Text('No notifications'),
    );
    */

    return StreamBuilder<List<Chat>>(
      stream: _chatsStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final chats = snapshot.data!;
          return Container(
            color: whiteF5Color,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Today',
                  style: TextStyle(color: greyColor, fontSize: 14),
                ),
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
                            log('chat ${chat.toJson()}');
                            // return NotificationTile(
                            //   chat: chat,
                            // );
                          },
                        ),
                      ),
              ],
            ),
          );
        } else {
          // return preloader;
          return Center(
            child: Text('Notifications list'),
          );
        }
      },
    );
  }

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
