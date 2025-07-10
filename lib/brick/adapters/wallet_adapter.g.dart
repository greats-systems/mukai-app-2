// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Wallet> _$WalletFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Wallet(
    id: data['id'] == null ? null : data['id'] as String?,
    holding_account:
        data['holding_account'] == null
            ? null
            : data['holding_account'] as String?,
    address: data['address'] == null ? null : data['address'] as String?,
    status: data['status'] == null ? null : data['status'] as String?,
    balance: data['balance'] == null ? null : data['balance'] as double?,
    last_transaction_timestamp:
        data['last_transaction_timestamp'] == null
            ? null
            : data['last_transaction_timestamp'] as String?,
    parent_wallet_id:
        data['parent_wallet_id'] == null
            ? null
            : data['parent_wallet_id'] as String?,
    provider: data['provider'] == null ? null : data['provider'] as String?,
    default_currency:
        data['default_currency'] == null
            ? null
            : data['default_currency'] as String?,
    business_id:
        data['business_id'] == null ? null : data['business_id'] as String?,
    is_shared: data['is_shared'] == null ? null : data['is_shared'] as bool?,
    is_active: data['is_active'] == null ? null : data['is_active'] as bool?,
    is_sub_wallet:
        data['is_sub_wallet'] == null ? null : data['is_sub_wallet'] as bool?,
    profile_id:
        data['profile_id'] == null ? null : data['profile_id'] as String?,
    coop_id: data['coop_id'] == null ? null : data['coop_id'] as String?,
    is_group_wallet:
        data['is_group_wallet'] == null
            ? null
            : data['is_group_wallet'] as bool?,
    group_id: data['group_id'] == null ? null : data['group_id'] as String?,
  );
}

Future<Map<String, dynamic>> _$WalletToSupabase(
  Wallet instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'holding_account': instance.holding_account,
    'address': instance.address,
    'status': instance.status,
    'balance': instance.balance,
    'last_transaction_timestamp': instance.last_transaction_timestamp,
    'parent_wallet_id': instance.parent_wallet_id,
    'provider': instance.provider,
    'default_currency': instance.default_currency,
    'business_id': instance.business_id,
    'is_shared': instance.is_shared,
    'is_active': instance.is_active,
    'is_sub_wallet': instance.is_sub_wallet,
    'profile_id': instance.profile_id,
    'coop_id': instance.coop_id,
    'is_group_wallet': instance.is_group_wallet,
    'group_id': instance.group_id,
  };
}

Future<Wallet> _$WalletFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Wallet(
    id: data['id'] == null ? null : data['id'] as String?,
    holding_account:
        data['holding_account'] == null
            ? null
            : data['holding_account'] as String?,
    address: data['address'] == null ? null : data['address'] as String?,
    status: data['status'] == null ? null : data['status'] as String?,
    balance: data['balance'] == null ? null : data['balance'] as double?,
    last_transaction_timestamp:
        data['last_transaction_timestamp'] == null
            ? null
            : data['last_transaction_timestamp'] as String?,
    parent_wallet_id:
        data['parent_wallet_id'] == null
            ? null
            : data['parent_wallet_id'] as String?,
    provider: data['provider'] == null ? null : data['provider'] as String?,
    default_currency:
        data['default_currency'] == null
            ? null
            : data['default_currency'] as String?,
    business_id:
        data['business_id'] == null ? null : data['business_id'] as String?,
    is_shared: data['is_shared'] == null ? null : data['is_shared'] == 1,
    is_active: data['is_active'] == null ? null : data['is_active'] == 1,
    is_sub_wallet:
        data['is_sub_wallet'] == null ? null : data['is_sub_wallet'] == 1,
    profile_id:
        data['profile_id'] == null ? null : data['profile_id'] as String?,
    coop_id: data['coop_id'] == null ? null : data['coop_id'] as String?,
    is_group_wallet:
        data['is_group_wallet'] == null ? null : data['is_group_wallet'] == 1,
    group_id: data['group_id'] == null ? null : data['group_id'] as String?,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$WalletToSqlite(
  Wallet instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'holding_account': instance.holding_account,
    'address': instance.address,
    'status': instance.status,
    'balance': instance.balance,
    'last_transaction_timestamp': instance.last_transaction_timestamp,
    'parent_wallet_id': instance.parent_wallet_id,
    'provider': instance.provider,
    'default_currency': instance.default_currency,
    'business_id': instance.business_id,
    'is_shared':
        instance.is_shared == null ? null : (instance.is_shared! ? 1 : 0),
    'is_active':
        instance.is_active == null ? null : (instance.is_active! ? 1 : 0),
    'is_sub_wallet':
        instance.is_sub_wallet == null
            ? null
            : (instance.is_sub_wallet! ? 1 : 0),
    'profile_id': instance.profile_id,
    'coop_id': instance.coop_id,
    'is_group_wallet':
        instance.is_group_wallet == null
            ? null
            : (instance.is_group_wallet! ? 1 : 0),
    'group_id': instance.group_id,
  };
}

/// Construct a [Wallet]
class WalletAdapter extends OfflineFirstWithSupabaseAdapter<Wallet> {
  WalletAdapter();

  @override
  final supabaseTableName = 'wallets';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'holding_account': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'holding_account',
    ),
    'address': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'address',
    ),
    'status': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'status',
    ),
    'balance': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'balance',
    ),
    'last_transaction_timestamp': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'last_transaction_timestamp',
    ),
    'parent_wallet_id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'parent_wallet_id',
    ),
    'provider': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'provider',
    ),
    'default_currency': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'default_currency',
    ),
    'business_id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'business_id',
    ),
    'is_shared': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'is_shared',
    ),
    'is_active': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'is_active',
    ),
    'is_sub_wallet': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'is_sub_wallet',
    ),
    'profile_id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'profile_id',
    ),
    'coop_id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'coop_id',
    ),
    'is_group_wallet': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'is_group_wallet',
    ),
    'group_id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'group_id',
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
    'holding_account': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'holding_account',
      iterable: false,
      type: String,
    ),
    'address': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'address',
      iterable: false,
      type: String,
    ),
    'status': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'status',
      iterable: false,
      type: String,
    ),
    'balance': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'balance',
      iterable: false,
      type: double,
    ),
    'last_transaction_timestamp': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'last_transaction_timestamp',
      iterable: false,
      type: String,
    ),
    'parent_wallet_id': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'parent_wallet_id',
      iterable: false,
      type: String,
    ),
    'provider': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'provider',
      iterable: false,
      type: String,
    ),
    'default_currency': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'default_currency',
      iterable: false,
      type: String,
    ),
    'business_id': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'business_id',
      iterable: false,
      type: String,
    ),
    'is_shared': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'is_shared',
      iterable: false,
      type: bool,
    ),
    'is_active': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'is_active',
      iterable: false,
      type: bool,
    ),
    'is_sub_wallet': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'is_sub_wallet',
      iterable: false,
      type: bool,
    ),
    'profile_id': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'profile_id',
      iterable: false,
      type: String,
    ),
    'coop_id': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'coop_id',
      iterable: false,
      type: String,
    ),
    'is_group_wallet': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'is_group_wallet',
      iterable: false,
      type: bool,
    ),
    'group_id': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'group_id',
      iterable: false,
      type: String,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    Wallet instance,
    DatabaseExecutor executor,
  ) async => instance.primaryKey;
  @override
  final String tableName = 'Wallet';

  @override
  Future<Wallet> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$WalletFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    Wallet input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$WalletToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Wallet> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$WalletFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    Wallet input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$WalletToSqlite(input, provider: provider, repository: repository);
}
