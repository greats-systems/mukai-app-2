// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<GroupMembers> _$GroupMembersFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return GroupMembers(
    id: data['id'] == null ? null : data['id'] as String?,
    memberId: data['member_id'] == null ? null : data['member_id'] as String?,
    createdAt:
        data['created_at'] == null ? null : data['created_at'] as String?,
    role: data['role'] == null ? null : data['role'] as String?,
    cooperativeId:
        data['cooperative_id'] == null
            ? null
            : data['cooperative_id'] as String?,
    updatedAt:
        data['updated_at'] == null ? null : data['updated_at'] as String?,
  );
}

Future<Map<String, dynamic>> _$GroupMembersToSupabase(
  GroupMembers instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'member_id': instance.memberId,
    'created_at': instance.createdAt,
    'role': instance.role,
    'cooperative_id': instance.cooperativeId,
    'updated_at': instance.updatedAt,
  };
}

Future<GroupMembers> _$GroupMembersFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return GroupMembers(
    id: data['id'] == null ? null : data['id'] as String?,
    memberId: data['member_id'] == null ? null : data['member_id'] as String?,
    createdAt:
        data['created_at'] == null ? null : data['created_at'] as String?,
    role: data['role'] == null ? null : data['role'] as String?,
    cooperativeId:
        data['cooperative_id'] == null
            ? null
            : data['cooperative_id'] as String?,
    updatedAt:
        data['updated_at'] == null ? null : data['updated_at'] as String?,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$GroupMembersToSqlite(
  GroupMembers instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'member_id': instance.memberId,
    'created_at': instance.createdAt,
    'role': instance.role,
    'cooperative_id': instance.cooperativeId,
    'updated_at': instance.updatedAt,
  };
}

/// Construct a [GroupMembers]
class GroupMembersAdapter
    extends OfflineFirstWithSupabaseAdapter<GroupMembers> {
  GroupMembersAdapter();

  @override
  final supabaseTableName = 'group_memberss';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'memberId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'member_id',
    ),
    'createdAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'created_at',
    ),
    'role': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'role',
    ),
    'cooperativeId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'cooperative_id',
    ),
    'updatedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'updated_at',
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
    'memberId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'member_id',
      iterable: false,
      type: String,
    ),
    'createdAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'created_at',
      iterable: false,
      type: String,
    ),
    'role': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'role',
      iterable: false,
      type: String,
    ),
    'cooperativeId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'cooperative_id',
      iterable: false,
      type: String,
    ),
    'updatedAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'updated_at',
      iterable: false,
      type: String,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    GroupMembers instance,
    DatabaseExecutor executor,
  ) async => instance.primaryKey;
  @override
  final String tableName = 'GroupMembers';

  @override
  Future<GroupMembers> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$GroupMembersFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    GroupMembers input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$GroupMembersToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<GroupMembers> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$GroupMembersFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    GroupMembers input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$GroupMembersToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
