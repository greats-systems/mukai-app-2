// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Profile> _$ProfileFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Profile(
    password: data['password'] == null ? null : data['password'] as String?,
    profile_image_url:
        data['profile_image_url'] == null
            ? null
            : data['profile_image_url'] as String?,
    profile_image_id:
        data['profile_image_id'] == null
            ? null
            : data['profile_image_id'] as String?,
    gender: data['gender'] == null ? null : data['gender'] as String?,
    first_name:
        data['first_name'] == null ? null : data['first_name'] as String?,
    last_name: data['last_name'] == null ? null : data['last_name'] as String?,
    full_name: data['full_name'] == null ? null : data['full_name'] as String?,
    profile_picture_id:
        data['profile_picture_id'] == null
            ? null
            : data['profile_picture_id'] as String?,
    account_type:
        data['account_type'] == null ? null : data['account_type'] as String?,
    email: data['email'] == null ? null : data['email'] as String?,
    phone: data['phone'] == null ? null : data['phone'] as String?,
    city: data['city'] == null ? null : data['city'] as String?,
    country: data['country'] == null ? null : data['country'] as String?,
    neighbourhood:
        data['neighbourhood'] == null ? null : data['neighbourhood'] as String?,
    province_state:
        data['province_state'] == null
            ? null
            : data['province_state'] as String?,
    id: data['id'] == null ? null : data['id'] as String?,
    wallet_balance:
        data['wallet_balance'] == null
            ? null
            : data['wallet_balance'] as double?,
    wallet_address:
        data['wallet_address'] == null
            ? null
            : data['wallet_address'] as String?,
    push_token:
        data['push_token'] == null ? null : data['push_token'] as String?,
    business:
        data['business'] == null
            ? null
            : data['business']?.toList().cast<String>(),
    last_access:
        data['last_access'] == null
            ? null
            : data['last_access'] == null
            ? null
            : DateTime.tryParse(data['last_access'] as String),
    createdAt:
        data['created_at'] == null
            ? null
            : data['created_at'] == null
            ? null
            : DateTime.tryParse(data['created_at'] as String),
    updatedAt:
        data['updated_at'] == null
            ? null
            : data['updated_at'] == null
            ? null
            : DateTime.tryParse(data['updated_at'] as String),
    permissions:
        data['permissions'] == null
            ? null
            : data['permissions']?.toList().cast<String>(),
  );
}

Future<Map<String, dynamic>> _$ProfileToSupabase(
  Profile instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'password': instance.password,
    'profile_image_url': instance.profile_image_url,
    'profile_image_id': instance.profile_image_id,
    'gender': instance.gender,
    'first_name': instance.first_name,
    'last_name': instance.last_name,
    'full_name': instance.full_name,
    'profile_picture_id': instance.profile_picture_id,
    'account_type': instance.account_type,
    'email': instance.email,
    'phone': instance.phone,
    'city': instance.city,
    'country': instance.country,
    'neighbourhood': instance.neighbourhood,
    'province_state': instance.province_state,
    'id': instance.id,
    'wallet_balance': instance.wallet_balance,
    'wallet_address': instance.wallet_address,
    'push_token': instance.push_token,
    'business': instance.business,
    'last_access': instance.last_access?.toIso8601String(),
    'created_at': instance.createdAt?.toIso8601String(),
    'updated_at': instance.updatedAt?.toIso8601String(),
    'permissions': instance.permissions,
  };
}

Future<Profile> _$ProfileFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Profile(
    password: data['password'] == null ? null : data['password'] as String?,
    profile_image_url:
        data['profile_image_url'] == null
            ? null
            : data['profile_image_url'] as String?,
    profile_image_id:
        data['profile_image_id'] == null
            ? null
            : data['profile_image_id'] as String?,
    gender: data['gender'] == null ? null : data['gender'] as String?,
    first_name:
        data['first_name'] == null ? null : data['first_name'] as String?,
    last_name: data['last_name'] == null ? null : data['last_name'] as String?,
    full_name: data['full_name'] == null ? null : data['full_name'] as String?,
    profile_picture_id:
        data['profile_picture_id'] == null
            ? null
            : data['profile_picture_id'] as String?,
    account_type:
        data['account_type'] == null ? null : data['account_type'] as String?,
    email: data['email'] == null ? null : data['email'] as String?,
    phone: data['phone'] == null ? null : data['phone'] as String?,
    city: data['city'] == null ? null : data['city'] as String?,
    country: data['country'] == null ? null : data['country'] as String?,
    neighbourhood:
        data['neighbourhood'] == null ? null : data['neighbourhood'] as String?,
    province_state:
        data['province_state'] == null
            ? null
            : data['province_state'] as String?,
    id: data['id'] == null ? null : data['id'] as String?,
    wallet_balance:
        data['wallet_balance'] == null
            ? null
            : data['wallet_balance'] as double?,
    wallet_address:
        data['wallet_address'] == null
            ? null
            : data['wallet_address'] as String?,
    push_token:
        data['push_token'] == null ? null : data['push_token'] as String?,
    business:
        data['business'] == null
            ? null
            : jsonDecode(data['business']).toList().cast<String>(),
    last_access:
        data['last_access'] == null
            ? null
            : data['last_access'] == null
            ? null
            : DateTime.tryParse(data['last_access'] as String),
    createdAt:
        data['created_at'] == null
            ? null
            : data['created_at'] == null
            ? null
            : DateTime.tryParse(data['created_at'] as String),
    updatedAt:
        data['updated_at'] == null
            ? null
            : data['updated_at'] == null
            ? null
            : DateTime.tryParse(data['updated_at'] as String),
    permissions:
        data['permissions'] == null
            ? null
            : jsonDecode(data['permissions']).toList().cast<String>(),
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$ProfileToSqlite(
  Profile instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'password': instance.password,
    'profile_image_url': instance.profile_image_url,
    'profile_image_id': instance.profile_image_id,
    'gender': instance.gender,
    'first_name': instance.first_name,
    'last_name': instance.last_name,
    'full_name': instance.full_name,
    'profile_picture_id': instance.profile_picture_id,
    'account_type': instance.account_type,
    'email': instance.email,
    'phone': instance.phone,
    'city': instance.city,
    'country': instance.country,
    'neighbourhood': instance.neighbourhood,
    'province_state': instance.province_state,
    'id': instance.id,
    'wallet_balance': instance.wallet_balance,
    'wallet_address': instance.wallet_address,
    'push_token': instance.push_token,
    'business':
        instance.business == null ? null : jsonEncode(instance.business),
    'last_access': instance.last_access?.toIso8601String(),
    'created_at': instance.createdAt?.toIso8601String(),
    'updated_at': instance.updatedAt?.toIso8601String(),
    'permissions':
        instance.permissions == null ? null : jsonEncode(instance.permissions),
  };
}

/// Construct a [Profile]
class ProfileAdapter extends OfflineFirstWithSupabaseAdapter<Profile> {
  ProfileAdapter();

  @override
  final supabaseTableName = 'profiles';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'password': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'password',
    ),
    'profile_image_url': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'profile_image_url',
    ),
    'profile_image_id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'profile_image_id',
    ),
    'gender': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'gender',
    ),
    'first_name': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'first_name',
    ),
    'last_name': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'last_name',
    ),
    'full_name': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'full_name',
    ),
    'profile_picture_id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'profile_picture_id',
    ),
    'account_type': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'account_type',
    ),
    'email': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'email',
    ),
    'phone': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'phone',
    ),
    'city': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'city',
    ),
    'country': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'country',
    ),
    'neighbourhood': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'neighbourhood',
    ),
    'province_state': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'province_state',
    ),
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'wallet_balance': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'wallet_balance',
    ),
    'wallet_address': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'wallet_address',
    ),
    'push_token': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'push_token',
    ),
    'business': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'business',
    ),
    'last_access': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'last_access',
    ),
    'createdAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'created_at',
    ),
    'updatedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'updated_at',
    ),
    'permissions': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'permissions',
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
    'password': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'password',
      iterable: false,
      type: String,
    ),
    'profile_image_url': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'profile_image_url',
      iterable: false,
      type: String,
    ),
    'profile_image_id': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'profile_image_id',
      iterable: false,
      type: String,
    ),
    'gender': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'gender',
      iterable: false,
      type: String,
    ),
    'first_name': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'first_name',
      iterable: false,
      type: String,
    ),
    'last_name': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'last_name',
      iterable: false,
      type: String,
    ),
    'full_name': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'full_name',
      iterable: false,
      type: String,
    ),
    'profile_picture_id': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'profile_picture_id',
      iterable: false,
      type: String,
    ),
    'account_type': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'account_type',
      iterable: false,
      type: String,
    ),
    'email': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'email',
      iterable: false,
      type: String,
    ),
    'phone': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'phone',
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
    'neighbourhood': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'neighbourhood',
      iterable: false,
      type: String,
    ),
    'province_state': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'province_state',
      iterable: false,
      type: String,
    ),
    'id': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'id',
      iterable: false,
      type: String,
    ),
    'wallet_balance': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'wallet_balance',
      iterable: false,
      type: double,
    ),
    'wallet_address': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'wallet_address',
      iterable: false,
      type: String,
    ),
    'push_token': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'push_token',
      iterable: false,
      type: String,
    ),
    'business': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'business',
      iterable: true,
      type: String,
    ),
    'last_access': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'last_access',
      iterable: false,
      type: DateTime,
    ),
    'createdAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'created_at',
      iterable: false,
      type: DateTime,
    ),
    'updatedAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'updated_at',
      iterable: false,
      type: DateTime,
    ),
    'permissions': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'permissions',
      iterable: true,
      type: String,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    Profile instance,
    DatabaseExecutor executor,
  ) async => instance.primaryKey;
  @override
  final String tableName = 'Profile';

  @override
  Future<Profile> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ProfileFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    Profile input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ProfileToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Profile> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ProfileFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    Profile input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ProfileToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
