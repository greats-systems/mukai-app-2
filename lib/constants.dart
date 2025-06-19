import 'package:mukai/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

/// Supabase client
final supabase = Supabase.instance.client;

BoxDecoration bgBoxDecoration = BoxDecoration(
  color: recColor,
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: recShadow,
);

/// Simple preloader inside a Center widget
const preloader =
    Center(child: CircularProgressIndicator(color: Colors.orange));

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

const ENV = 'production';
const API_ENV = 'localhost';
const DEVICE_ENV = 'virtual';
const APP_API_ENDPOINT = API_ENV == 'localhost'
    ? DEVICE_ENV == 'physical'
        ? 'http://172.16.32.87:3001'
        : 'http://10.0.2.2:3001'
    : 'https://supabasekong-w0skgw8swgwcocwowokscokk.freetrader.africa';
const CMS_ENDPOINT = DEVICE_ENV == 'physical'
    ? 'http://172.16.32.87:54321/graphql/v1'
    : 'http://172.16.32.87:54321/graphql/v1';
const GRAPH_API_TOKEN =
    'Bearer EAAUavcvJKVgBO8nrNqlcy5p5K7Sv7XZAudraZC5PpwMWhFupmm8hED7SqH7RQKZATPu4HI3drryZAn8AzqOpSobT2trLOgwIGLJZBPk9kASXckuKRZCfrYZBeNdRbqSnygiIBGZBEWHUmgWUAg5XmKJZB6N9m0roNxsCFjWuAJ8MlaUy1h7U2ArpBDMJglQ9I9xa1OMrtX31RE1YUZAdaZCuhYD';
const WEBHOOK_VERIFY_TOKEN = 'simplyledgers_hook';
const PHONE_ID = '416179854905155';
const APP_ID = '1436777353652568';
const AD_ACCOUNT_ID = '1148308405530886';
const PHONE_NUMBER = '+14847390602';
const APP_SECRET = "a95c61ee2cd7e8a1c7cbbefd6c03f6a9";
const API_VERSION = "v20.0";
const CUSTOM_GOOGLE_APPLICATION_CREDENTIALS =
    'https://appwrite-usgwgoo8cs8kw4kcowwggkow.livestockledger.co.zw/v1/storage/buckets/credentials/files/66c1b252002ce8f3e48c/view?project=commodity-chain&mode=admin';
