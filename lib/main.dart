import 'dart:developer';
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mukai/brick/brick.g.dart';
import 'package:mukai/brick/repository.dart';
import 'package:mukai/classes/session_manager.dart';
import 'package:mukai/constants.dart';
import 'package:mukai/data/repositories/asset_repository.dart';
import 'package:mukai/data/repositories/cooperative_member_approval_repository.dart';
import 'package:mukai/firebase_options.dart';
import 'package:mukai/src/app.dart';
import 'package:mukai/src/apps/settings/settings_controller.dart';
import 'package:mukai/src/apps/settings/settings_service.dart';
import 'package:mukai/src/apps/transactions/controllers/transactions_controller.dart';
import 'package:mukai/src/controllers/asset.controller.dart';
import 'package:mukai/src/controllers/auth.controller.dart';
import 'package:mukai/src/controllers/cooperative-member-approvals.controller.dart';
import 'injection_container.dart' as injection_container;
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase_flutter;
import 'package:sqflite/sqflite.dart' show databaseFactory;
import 'package:supabase/supabase.dart';
import 'package:brick_supabase/brick_supabase.dart';

late SupabaseProvider supabaseProvider;
late var restOfflineRequestQueue;
late String initialRoute;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EnvConstants.init(envFile: '.env');
  // await EnvConstants.init(envFile: environment.envFile);

  // 2. Initialize local storage
  await GetStorage.init();
  final dio = Dio();
  
  // Initialize Supabase first
  await supabase_flutter.Supabase.initialize(
    url: EnvConstants.SUPABASE_URL,
    anonKey: EnvConstants.SUPABASE_ROLE_KEY,
  );

  // Configure repository
  final repository = await MyRepository.configure(databaseFactory);
  
  // Dependency Injection
  // 1. Register Dio and Repository
  Get.put(dio);
  Get.put(repository);

  // 2. Register AssetRepository and AssetController
  Get.put(AssetRepository(repository, dio));
  Get.put(AssetController(Get.find<AssetRepository>()));

  // 3. Register CooperativeMemberApprovalRepository and CooperativeMemberApprovalsController
  Get.put(CooperativeMemberApprovalRepository(
      repository, dio));
  Get.put(CooperativeMemberApprovalsController(
      Get.find<CooperativeMemberApprovalRepository>()));

  log('kReleaseMode? $kReleaseMode');
  // final environment = kReleaseMode ? AppEnvironment.prod : AppEnvironment.dev;

  // 1. Initialize environment variables
  // await dotenv.load(fileName: ".env");
  

  // 3. Initialize session manager and check auth state
  final sessionManager = SessionManager(GetStorage(), Dio());
  final isLoggedIn = await sessionManager.isLoggedIn();
  initialRoute = isLoggedIn ? '/home' : '/login';

  try {
    // 4. Initialize Supabase
    var supabaseUrl = EnvConstants.SUPABASE_URL;
    var supabaseAnonKey = EnvConstants.SUPABASE_ROLE_KEY;


    final (client, queue) = OfflineFirstWithSupabaseRepository.clientQueue(
      databaseFactory: databaseFactory,
      ignorePaths: {},
    );

    log('SUPABASE_URL: $supabaseUrl\nSUPABASE_ROLE_KEY: $supabaseAnonKey');
    restOfflineRequestQueue = queue;

    MyRepository.configure(databaseFactory);

    supabaseProvider = SupabaseProvider(
      SupabaseClient(supabaseUrl, supabaseAnonKey, httpClient: client),
      modelDictionary: supabaseModelDictionary,
    );
  } catch (error) {
    log('Failed connecting to supabase server $error');
  }

  try {
    // 5. Initialize Firebase
    await Firebase.initializeApp(
        name: 'mukai', options: DefaultFirebaseOptions.currentPlatform);
    await injection_container.init();
  } catch (error) {
    log('Firebase initialization error: $error');
  }

  // 6. Initialize settings controller
  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();

  // 7. Initialize controllers
  Get.put(AuthController());
  Get.put(TransactionController());
  // debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      child: Center(
        child: Text('Render Error: ${details.exception}'),
      ),
    );
  };
  await MyRepository().initialize();

  // 8. Run the app with initial route based on auth state
  runApp(MyApp(
    settingsController: settingsController,
    initialRoute: initialRoute,
  ));
}


final supabase = supabase_flutter.Supabase.instance.client;
