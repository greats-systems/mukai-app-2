// lib/brick/db/my_repository.dart
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_sqlite/memory_cache_provider.dart';
import 'package:brick_supabase/brick_supabase.dart' hide Supabase;
import 'package:mukai/brick/brick.g.dart';
import 'package:mukai/brick/db/schema.g.dart';
import 'package:mukai/main.dart';
import 'package:sqflite/sqflite.dart';

// For Where/Query if needed

class MyRepository extends OfflineFirstWithSupabaseRepository {
  static MyRepository? _instance;

  MyRepository._({
    required super.supabaseProvider,
    required super.sqliteProvider,
    required super.migrations,
    required super.offlineRequestQueue,
    super.memoryCacheProvider,
  });

  factory MyRepository() {
    if (_instance == null) {
      throw StateError('Repository not initialized. Call configure() first.');
    }
    return _instance!;
  }

  static Future<MyRepository> configure(DatabaseFactory databaseFactory) async {
    final (client, queue) = OfflineFirstWithSupabaseRepository.clientQueue(
      databaseFactory: databaseFactory,
    );

    final provider = SupabaseProvider(
      supabase,
      modelDictionary: supabaseModelDictionary,
    );

    _instance = MyRepository._(
      supabaseProvider: provider,
      sqliteProvider: SqliteProvider(
        'mkandowallet.sqlite',
        databaseFactory: databaseFactory,
        modelDictionary: sqliteModelDictionary,
      ),
      migrations: migrations,
      offlineRequestQueue: queue,
      memoryCacheProvider: MemoryCacheProvider(),
    );

    await _instance!.initialize();
    return _instance!;
  }
}