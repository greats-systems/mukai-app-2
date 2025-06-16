// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Cooperative> _$CooperativeFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Cooperative(
    id: data['id'] == null ? null : data['id'] as String?,
    name: data['name'] == null ? null : data['name'] as String?,
    category: data['category'] == null ? null : data['category'] as String?,
    city: data['city'] == null ? null : data['city'] as String?,
    county: data['county'] == null ? null : data['county'] as String?,
    province_state:
        data['province_state'] == null
            ? null
            : data['province_state'] as String?,
    admin_id: data['admin_id'] == null ? null : data['admin_id'] as String?,
    members:
        data['members'] == null
            ? null
            : await Future.wait<Profile>(
              data['members']
                      ?.map(
                        (d) => ProfileAdapter().fromSupabase(
                          d,
                          provider: provider,
                          repository: repository,
                        ),
                      )
                      .toList()
                      .cast<Future<Profile>>() ??
                  [],
            ),
  );
}

Future<Map<String, dynamic>> _$CooperativeToSupabase(
  Cooperative instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'name': instance.name,
    'category': instance.category,
    'city': instance.city,
    'county': instance.county,
    'province_state': instance.province_state,
    'admin_id': instance.admin_id,
    'members': await Future.wait<Map<String, dynamic>>(
      instance.members
              ?.map(
                (s) => ProfileAdapter().toSupabase(
                  s,
                  provider: provider,
                  repository: repository,
                ),
              )
              .toList() ??
          [],
    ),
  };
}

Future<Cooperative> _$CooperativeFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Cooperative(
    id: data['id'] == null ? null : data['id'] as String?,
    name: data['name'] == null ? null : data['name'] as String?,
    category: data['category'] == null ? null : data['category'] as String?,
    city: data['city'] == null ? null : data['city'] as String?,
    county: data['county'] == null ? null : data['county'] as String?,
    province_state:
        data['province_state'] == null
            ? null
            : data['province_state'] as String?,
    admin_id: data['admin_id'] == null ? null : data['admin_id'] as String?,
    members:
        (await provider
            .rawQuery(
              'SELECT DISTINCT `f_Profile_brick_id` FROM `_brick_Cooperative_members` WHERE l_Cooperative_brick_id = ?',
              [data['_brick_id'] as int],
            )
            .then((results) {
              final ids = results.map((r) => r['f_Profile_brick_id']);
              return Future.wait<Profile>(
                ids.map(
                  (primaryKey) => repository!
                      .getAssociation<Profile>(
                        Query.where('primaryKey', primaryKey, limit1: true),
                      )
                      .then((r) => r!.first),
                ),
              );
            })).toList().cast<Profile>(),
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$CooperativeToSqlite(
  Cooperative instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'name': instance.name,
    'category': instance.category,
    'city': instance.city,
    'county': instance.county,
    'province_state': instance.province_state,
    'admin_id': instance.admin_id,
    'members': instance.members != null ? jsonEncode(instance.members) : null,
  };
}

/// Construct a [Cooperative]
class CooperativeAdapter extends OfflineFirstWithSupabaseAdapter<Cooperative> {
  CooperativeAdapter();

  @override
  final supabaseTableName = 'cooperatives';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'name': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'name',
    ),
    'category': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'category',
    ),
    'city': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'city',
    ),
    'county': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'county',
    ),
    'province_state': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'province_state',
    ),
    'admin_id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'admin_id',
    ),
    'members': const RuntimeSupabaseColumnDefinition(
      association: true,
      columnName: 'members',
      associationType: String,
      associationIsNullable: true,
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
    'name': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'name',
      iterable: false,
      type: String,
    ),
    'category': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'category',
      iterable: false,
      type: String,
    ),
    'city': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'city',
      iterable: false,
      type: String,
    ),
    'county': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'county',
      iterable: false,
      type: String,
    ),
    'province_state': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'province_state',
      iterable: false,
      type: String,
    ),
    'admin_id': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'admin_id',
      iterable: false,
      type: String,
    ),
    'members': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'members',
      iterable: true,
      type: String,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    Cooperative instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `Cooperative` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Cooperative';
  @override
  Future<void> afterSave(instance, {required provider, repository}) async {
    if (instance.primaryKey != null) {
      final membersOldColumns = await provider.rawQuery(
        'SELECT `f_Profile_brick_id` FROM `_brick_Cooperative_members` WHERE `l_Cooperative_brick_id` = ?',
        [instance.primaryKey],
      );
      final membersOldIds = membersOldColumns.map(
        (a) => a['f_Profile_brick_id'],
      );
      final membersNewIds =
          instance.members?.map((s) => s.primaryKey).whereType<int>() ?? [];
      final membersIdsToDelete = membersOldIds.where(
        (id) => !membersNewIds.contains(id),
      );

      await Future.wait<void>(
        membersIdsToDelete.map((id) async {
          return await provider
              .rawExecute(
                'DELETE FROM `_brick_Cooperative_members` WHERE `l_Cooperative_brick_id` = ? AND `f_Profile_brick_id` = ?',
                [instance.primaryKey, id],
              )
              .catchError((e) => null);
        }),
      );

      await Future.wait<int?>(
        instance.members?.map((s) async {
              final id =
                  s.primaryKey ??
                  await provider.upsert<Profile>(s, repository: repository);
              return await provider.rawInsert(
                'INSERT OR IGNORE INTO `_brick_Cooperative_members` (`l_Cooperative_brick_id`, `f_Profile_brick_id`) VALUES (?, ?)',
                [instance.primaryKey, id],
              );
            }) ??
            [],
      );
    }
  }

  @override
  Future<Cooperative> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$CooperativeFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    Cooperative input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$CooperativeToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Cooperative> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$CooperativeFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    Cooperative input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$CooperativeToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
