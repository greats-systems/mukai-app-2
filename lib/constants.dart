import 'package:mukai/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:mukai/widget/messages_shimmer.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:developer';

class Constants {}

BoxDecoration bgBoxDecoration = BoxDecoration(
  color: recColor,
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: recShadow,
);

/// Simple preloader inside a Center widget
const preloader = Center(child: LoadingMessagesShimmerWidget());

/// Simple sized box to space out form elements
const formSpacer = SizedBox(width: 16, height: 16);

/// Some padding for all the forms to use
const formPadding = EdgeInsets.symmetric(vertical: 20, horizontal: 16);

/// Set of extension methods to easily display a snackbar
extension ShowSnackBar on BuildContext {
  /// Displays a basic snackbar
  void showSnackBar({
    required String message,
    Color backgroundColor = Colors.white,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    ));
  }

  /// Displays a red snackbar indicating error
  void showErrorSnackBar({required String message}) {
    showSnackBar(message: message, backgroundColor: Colors.red);
  }
}

String formatDate(String isoString) {
  try {
    // log(isoString);
    final dateTime = DateTime.parse(isoString);
    return DateFormat('d MMM yyyy').format(dateTime);
  } catch (e) {
    return isoString;
  }
}

String truncateDate(String interval) {
  return "date_trunc('$interval', created_at)";
}

class EnvConstants {
  static late final String LOCAL_SUPABASE_URL;
  static late final String SUPABASE_URL;
  static late final String LOCAL_SERVICE_ROLE_KEY;
  static late final String SUPABASE_ROLE_KEY;
  static late final String ENV;
  static late final String API_ENV;
  static late final String APP_API_ENDPOINT;
  static late final String CMS_ENDPOINT;
  static late final String GRAPH_API_TOKEN;
  static late final String WEBHOOK_VERIFY_TOKEN;
  static late final String PHONE_ID;
  static late final String APP_ID;
  static late final String AD_ACCOUNT_ID;
  static late final String PHONE_NUMBER;
  static late final String APP_SECRET;
  static late final String API_VERSION;
  static late final String CUSTOM_GOOGLE_APPLICATION_CREDENTIALS;

  static Future<void> init({String envFile = '.env'}) async {
    try {
      log(envFile);
      await dotenv.load(fileName: envFile);
      ENV = dotenv.get('ENV', fallback: 'localhost');
      LOCAL_SUPABASE_URL = dotenv.get('LOCAL_SUPABASE_URL');
      SUPABASE_URL = dotenv.get('SUPABASE_URL');
      LOCAL_SERVICE_ROLE_KEY = dotenv.get('LOCAL_SERVICE_ROLE_KEY');
      SUPABASE_ROLE_KEY = dotenv.get('SUPABASE_ROLE_KEY');
      API_ENV = dotenv.get('ENV') == 'localhost'
          ? dotenv.get('DEVICE') == 'physical'
              ? dotenv.get('LOCAL_NETWORK_ENDPOINT')
              : dotenv.get('LOCAL_API_ENDPOINT')
          : 'http://10.0.2.2:3001';
      // : dotenv.get('PRODUCTION_API_ENDPOINT');
      // APP_API_ENDPOINT = dotenv.get('APP_API_ENDPOINT');
      APP_API_ENDPOINT = 'http://10.0.2.2:3001';

      CMS_ENDPOINT = dotenv.get('CMS_ENDPOINT');
      GRAPH_API_TOKEN = dotenv.get('GRAPH_API_TOKEN');
      WEBHOOK_VERIFY_TOKEN = dotenv.get('WEBHOOK_VERIFY_TOKEN');
      PHONE_ID = dotenv.get('PHONE_ID');
      APP_ID = dotenv.get('APP_ID');
      AD_ACCOUNT_ID = dotenv.get('AD_ACCOUNT_ID');
      PHONE_NUMBER = dotenv.get('PHONE_NUMBER');
      APP_SECRET = dotenv.get('APP_SECRET');
      API_VERSION = dotenv.get('API_VERSION');
      CUSTOM_GOOGLE_APPLICATION_CREDENTIALS =
          dotenv.get('CUSTOM_GOOGLE_APPLICATION_CREDENTIALS');
    } on Exception catch (e) {
      log('EnvConstants error: $e');
    }
  }
}
