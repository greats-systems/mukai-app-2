import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  log('Title : ${message.notification?.title}');
  log('Body : ${message.notification?.body}');
  log('Payload : ${message.data}');
}

class FirebaseApi {
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
      'high_importance_channel', 'High Importance Channel',
      description: 'This channel is used for important notifications',
      importance: Importance.defaultImportance);
  final _localNotifications = FlutterLocalNotificationsPlugin();

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    log(message.toString());
    // if (message.notification?.title == 'Wallet Cash Out') {
    //   Get.to(() => ConfirmCashOutScreen(message: message), arguments: message);
    // }
    log('message : $message');
    log('Title : ${message.notification?.title}');
    log('Body : ${message.notification?.body}');
    log('Payload : ${message.data}');

    // Get.to(() => const ChatsPage(), arguments: message);

    // navigatorKey.currentState?.pushNamed(ChatsPage.route, arguments: message);
  }

  Future initPushNotifications() async {
    log('initPushNotifications: setting...');
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
    fMessaging.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;
      _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
                  _androidChannel.id, _androidChannel.name,
                  channelDescription: _androidChannel.description,
                  icon: '@drawable/launcher_icon')),
          payload: jsonEncode(message.toMap()));
    });
  }

  Future initLocalNotifications() async {
    // ignore: unused_local_variable
    // const iOS = IOSInitializationSettings();
    const android = AndroidInitializationSettings('@drawable/launcher_icon');
    // const settings = InitializationSettings(android: android);
    // await _localNotifications.initialize(
    //   settings,
    //   onSelectNotification: (payload) {
    //     final message = RemoteMessage.fromMap(jsonDecode(payload!));
    //     handleMessage(message);
    //   },
    // );
    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  Future<void> initNotifications() async {
    await fMessaging.requestPermission();
    await initPushNotifications();
    await initLocalNotifications();
    const topic = 'messages';
    await fMessaging.subscribeToTopic(topic);
  }

  static Future<String?> getFirebaseMessagingToken() async {
    final fMCToken = await fMessaging.getToken();
    return fMCToken;
  }
}
