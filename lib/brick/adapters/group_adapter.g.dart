// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Group> _$GroupFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Group(
    id: data['id'] == null ? null : data['id'] as String?,
    admin_id: data['admin_id'] == null ? null : data['admin_id'] as String?,
    wallet_id: data['wallet_id'] == null ? null : data['wallet_id'] as String?,
    name: data['name'] == null ? null : data['name'] as String?,
    city: data['city'] == null ? null : data['city'] as String?,
    country: data['country'] == null ? null : data['country'] as String?,
    monthly_sub: data['monthly_sub'] as double,
    interest_rate: data['interest_rate'] as double,
  );
}

Future<Map<String, dynamic>> _$GroupToSupabase(
  Group instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'admin_id': instance.admin_id,
    'wallet_id': instance.wallet_id,
    'name': instance.name,
    'city': instance.city,
    'country': instance.country,
    'monthly_sub': instance.monthly_sub,
    'interest_rate': instance.interest_rate,
  };
}

Future<Group> _$GroupFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Group(
    id: data['id'] == null ? null : data['id'] as String?,
    admin_id: data['admin_id'] == null ? null : data['admin_id'] as String?,
    wallet_id: data['wallet_id'] == null ? null : data['wallet_id'] as String?,
    name: data['name'] == null ? null : data['name'] as String?,
    city: data['city'] == null ? null : data['city'] as String?,
    country: data['country'] == null ? null : data['country'] as String?,
    monthly_sub: data['monthly_sub'] as double,
    interest_rate: data['interest_rate'] as double,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$GroupToSqlite(
  Group instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'admin_id': instance.admin_id,
    'wallet_id': instance.wallet_id,
    'name': instance.name,
    'city': instance.city,
    'country': instance.country,
    'monthly_sub': instance.monthly_sub,
    'interest_rate': instance.interest_rate,
  };
}

/// Construct a [Group]
class GroupAdapter extends OfflineFirstWithSupabaseAdapter<Group> {
  GroupAdapter();

  @override
  final supabaseTableName = 'groups';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'admin_id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'admin_id',
    ),
    'wallet_id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'wallet_id',
    ),
    'name': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'name',
    ),
    'city': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'city',
    ),
    'country': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'country',
    ),
    'monthly_sub': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'monthly_sub',
    ),
    'interest_rate': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'interest_rate',
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
    'id': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'id',
      iterable: false,
      type: String,
    ),
    'admin_id': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'admin_id',
      iterable: false,
      type: String,
    ),
    'wallet_id': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'wallet_id',
      iterable: false,
      type: String,
    ),
    'name': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'name',
      iterable: false,
      type: String,
    ),
    'city': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'city',
      iterable: false,
      type: String,
    ),
    'country': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'country',
      iterable: false,
      type: String,
    ),
    'monthly_sub': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'monthly_sub',
      iterable: false,
      type: double,
    ),
    'interest_rate': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'interest_rate',
      iterable: false,
      type: double,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    Group instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `Group` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Group';

  @override
  Future<Group> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$GroupFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    Group input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$GroupToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Group> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$GroupFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    Group input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$GroupToSqlite(input, provider: provider, repository: repository);
}
