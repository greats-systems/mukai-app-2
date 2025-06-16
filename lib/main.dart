import 'dart:developer';
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:isar/isar.dart';
import 'package:mukai/brick/brick.g.dart';
import 'package:mukai/firebase_options.dart';
import 'package:mukai/src/app.dart';
import 'package:mukai/src/apps/settings/settings_controller.dart';
import 'package:mukai/src/apps/settings/settings_service.dart';
import 'injection_container.dart' as injection_container;
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase_flutter;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sqflite/sqflite.dart' show databaseFactory;
import 'package:supabase/supabase.dart';
import 'package:brick_supabase/brick_supabase.dart';

late Isar isar;
late SupabaseProvider supabaseProvider;
late var restOfflineRequestQueue;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await GetStorage.init();
  try {
    var supabaseUrl = dotenv.get('ENV') == 'local'
        ? dotenv.get('LOCAL_SUPABASE_URL')
        : dotenv.get('SUPABASE_URL');
    var supabaseAnonKey = dotenv.get('ENV') == 'local'
        ? dotenv.get('LOCAL_SERVICE_ROLE_KEY')
        : dotenv.get('SUPABASE_ROLE_KEY');
    final (client, queue) = OfflineFirstWithSupabaseRepository.clientQueue(
      databaseFactory: databaseFactory,
      ignorePaths: {},
    );
    restOfflineRequestQueue = queue;
    await supabase_flutter.Supabase.initialize(
        url: supabaseUrl, anonKey: supabaseAnonKey, httpClient: client);

    supabaseProvider = SupabaseProvider(
      SupabaseClient(supabaseUrl, supabaseAnonKey, httpClient: client),
      modelDictionary: supabaseModelDictionary,
    );
  } catch (error) {
    log('failed connecting to supabase server $error');
  }
  try {
    await Firebase.initializeApp(
        name: 'mukai', options: DefaultFirebaseOptions.currentPlatform);
    // await FirebaseApi().initNotifications();
    // await determineLocationPosition();
    await injection_container.init();
  } catch (error) {
    log('Firebase errors $error');
  }
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(MyApp(settingsController: settingsController));
  // runApp(const MyApp());
}

final supabase = supabase_flutter.Supabase.instance.client;
