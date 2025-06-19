import 'package:mukai/brick/db/schema.g.dart';
import 'package:mukai/main.dart';
import 'brick.g.dart';
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_sqlite/memory_cache_provider.dart';
// import 'package:brick_supabase/brick_supabase.dart';
import 'package:sqflite/sqflite.dart' show databaseFactory;
// ignore: depend_on_referenced_packages
// import 'package:supabase/supabase.dart';

class MyRepository extends OfflineFirstWithSupabaseRepository {
  static late MyRepository? _singleton;

  MyRepository._({
    required super.supabaseProvider,
    required super.sqliteProvider,
    required super.migrations,
    required super.offlineRequestQueue,
    super.memoryCacheProvider,
  });

  factory MyRepository() => _singleton!;

  static void configure({
    required String supabaseUrl,
    required String supabaseAnonKey,
  }) {
    _singleton = MyRepository._(
      supabaseProvider: supabaseProvider,
      sqliteProvider: SqliteProvider(
        'mukai.sqlite',
        databaseFactory: databaseFactory,
        modelDictionary: sqliteModelDictionary,
      ),
      migrations: migrations,
      offlineRequestQueue: restOfflineRequestQueue,
      memoryCacheProvider: MemoryCacheProvider(),
    );
  }
}
