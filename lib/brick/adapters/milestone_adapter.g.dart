// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Milestone> _$MilestoneFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Milestone(
    name: data['name'] as String,
    amount: data['amount'] as String,
  );
}

Future<Map<String, dynamic>> _$MilestoneToSupabase(
  Milestone instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {'name': instance.name, 'amount': instance.amount};
}

Future<Milestone> _$MilestoneFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Milestone(
    name: data['name'] as String,
    amount: data['amount'] as String,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$MilestoneToSqlite(
  Milestone instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {'name': instance.name, 'amount': instance.amount};
}

/// Construct a [Milestone]
class MilestoneAdapter extends OfflineFirstWithSupabaseAdapter<Milestone> {
  MilestoneAdapter();

  @override
  final supabaseTableName = 'milestones';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'name': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'name',
    ),
    'amount': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'amount',
    ),
  };
  @override
  final ignoreDuplicates = false;
  @override
  final uniqueFields = {};
  @override
  final Map<String, RuntimeSqliteColumnDefinition> fieldsToSqliteColumns = {
    'primaryKey': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: '_brick_id',
      iterable: false,
      type: int,
    ),
    'name': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'name',
      iterable: false,
      type: String,
    ),
    'amount': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'amount',
      iterable: false,
      type: String,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    Milestone instance,
    DatabaseExecutor executor,
  ) async => instance.primaryKey;
  @override
  final String tableName = 'Milestone';

  @override
  Future<Milestone> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$MilestoneFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    Milestone input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$MilestoneToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Milestone> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$MilestoneFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    Milestone input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$MilestoneToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
