// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';
/*
Future<Wallet> _$WalletFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Wallet(
    category: data['category'] == null ? null : data['category'] as String?,
    purpose: data['purpose'] == null ? null : data['purpose'] as String?,
    id: data['id'] == null ? null : data['id'] as String?,
    wallet_adress:
        data['wallet_adress'] == null ? null : data['wallet_adress'] as String?,
    account_id:
        data['account_id'] == null ? null : data['account_id'] as String?,
    phone_number:
        data['phone_number'] == null ? null : data['phone_number'] as String?,
    status: data['status'] == null ? null : data['status'] as String?,
    createdAt:
        data['created_at'] == null ? null : data['created_at'] as String?,
    updatedAt:
        data['updated_at'] == null ? null : data['updated_at'] as String?,
    balance:
        data['balance'] == null
            ? null
            : data['balance'] as double?,
  );
}
*/

Future<Wallet> _$WalletFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Wallet(
    id: data['id'] == null ? null : data['id'] as String?,
    holding_account: data['holding_account'] == null
        ? null
        : data['holding_account'] as String?,
    address: data['address'] == null ? null : data['address'] as String?,
    status: data['status'] == null ? null : data['status'] as String?,
    balance: data['balance'] == null ? null : data['balance'] as double?,
    parent_wallet_id: data['parent_wallet_id'] == null
        ? null
        : data['parent_wallet_id'] as String?,
    provider: data['provider'] == null ? null : data['provider'] as String?,
    default_currency: data['default_currency'] == null
        ? null
        : data['default_currency'] as String?,
    business_id:
        data['business_id'] == null ? null : data['business_id'] as String?,
    is_shared: data['is_shared'] == null ? null : data['is_shared'] as bool?,
    is_active: data['is_active'] == null ? null : data['is_active'] as bool?,
    is_sub_wallet:
        data['is_sub_wallet'] == null ? null : data['is_sub_wallet'] as bool?,
    profile_id: data['profile_id'] == null ? null : data['profile_id'] as Uuid?,
    coop_id: data['coop_id'] == null ? null : data['coop_id'] as Uuid?,
    is_group_wallet: data['is_group_wallet'] == null
        ? null
        : data['is_group_wallet'] as bool?,
    children_wallets: data['business_id'] == null
        ? null
        : data['business_id'] as List<dynamic>?,
    group_id: data['group_id'] == null ? null : data['group_id'] as String?,
  );
}

/*
Future<Map<String, dynamic>> _$WalletToSupabase(
  Wallet instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'category': instance.category,
    'purpose': instance.purpose,
    'id': instance.id,
    'wallet_adress': instance.wallet_adress,
    'account_id': instance.account_id,
    'phone_number': instance.phone_number,
    'status': instance.status,
    'created_at': instance.createdAt,
    'updated_at': instance.updatedAt,
    'balance': instance.balance,
  };
}
*/

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
    'children_wallets': instance.children_wallets,
    'group_id': instance.group_id
  };
}

/*
Future<Wallet> _$WalletFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Wallet(
    category: data['category'] == null ? null : data['category'] as String?,
    purpose: data['purpose'] == null ? null : data['purpose'] as String?,
    id: data['id'] == null ? null : data['id'] as String?,
    wallet_adress:
        data['wallet_adress'] == null ? null : data['wallet_adress'] as String?,
    account_id:
        data['account_id'] == null ? null : data['account_id'] as String?,
    phone_number:
        data['phone_number'] == null ? null : data['phone_number'] as String?,
    status: data['status'] == null ? null : data['status'] as String?,
    createdAt:
        data['created_at'] == null ? null : data['created_at'] as String?,
    updatedAt:
        data['updated_at'] == null ? null : data['updated_at'] as String?,
    balance: data['balance'] == null ? null : data['balance'] as double?,
  )..primaryKey = data['_brick_id'] as int;
}
*/

Future<Wallet> _$WalletFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Wallet(
    id: data['id'] == null ? null : data['id'] as String?,
    holding_account: data['holding_account'] == null
        ? null
        : data['holding_account'] as String?,
    address: data['address'] == null ? null : data['address'] as String?,
    status: data['status'] == null ? null : data['status'] as String?,
    balance: data['balance'] == null ? null : data['balance'] as double?,
    parent_wallet_id: data['parent_wallet_id'] == null
        ? null
        : data['parent_wallet_id'] as String?,
    provider: data['provider'] == null ? null : data['provider'] as String?,
    default_currency: data['default_currency'] == null
        ? null
        : data['default_currency'] as String?,
    business_id:
        data['business_id'] == null ? null : data['business_id'] as String?,
    is_shared: data['is_shared'] == null ? null : data['is_shared'] as bool?,
    is_active: data['is_active'] == null ? null : data['is_active'] as bool?,
    is_sub_wallet:
        data['is_sub_wallet'] == null ? null : data['is_sub_wallet'] as bool?,
    profile_id: data['profile_id'] == null ? null : data['profile_id'] as Uuid?,
    coop_id: data['coop_id'] == null ? null : data['coop_id'] as Uuid?,
    is_group_wallet: data['is_group_wallet'] == null
        ? null
        : data['is_group_wallet'] as bool?,
    children_wallets: data['business_id'] == null
        ? null
        : data['business_id'] as List<dynamic>?,
    group_id: data['group_id'] == null ? null : data['group_id'] as String?,)..primaryKey = data['_brick_id'] as int;
}

/*
Future<Map<String, dynamic>> _$WalletToSqlite(
  Wallet instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'category': instance.category,
    'purpose': instance.purpose,
    'id': instance.id,
    'wallet_adress': instance.wallet_adress,
    'account_id': instance.account_id,
    'phone_number': instance.phone_number,
    'status': instance.status,
    'created_at': instance.createdAt,
    'updated_at': instance.updatedAt,
    'balance': instance.balance,
  };
}
*/

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
    'children_wallets': instance.children_wallets,
    'group_id': instance.group_id
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
    'category': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'category',
    ),
    'purpose': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'purpose',
    ),
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'wallet_adress': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'wallet_adress',
    ),
    'account_id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'account_id',
    ),
    'phone_number': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'phone_number',
    ),
    'status': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'status',
    ),
    'createdAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'created_at',
    ),
    'updatedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'updated_at',
    ),
    'balance': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'balance',
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
    'category': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'category',
      iterable: false,
      type: String,
    ),
    'purpose': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'purpose',
      iterable: false,
      type: String,
    ),
    'id': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'id',
      iterable: false,
      type: String,
    ),
    'wallet_adress': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'wallet_adress',
      iterable: false,
      type: String,
    ),
    'account_id': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'account_id',
      iterable: false,
      type: String,
    ),
    'phone_number': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'phone_number',
      iterable: false,
      type: String,
    ),
    'status': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'status',
      iterable: false,
      type: String,
    ),
    'createdAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'created_at',
      iterable: false,
      type: String,
    ),
    'updatedAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'updated_at',
      iterable: false,
      type: String,
    ),
    'balance': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'balance',
      iterable: false,
      type: double,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    Wallet instance,
    DatabaseExecutor executor,
  ) async =>
      instance.primaryKey;
  @override
  final String tableName = 'Wallet';

  @override
  Future<Wallet> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$WalletFromSupabase(
        input,
        provider: provider,
        repository: repository,
      );
  @override
  Future<Map<String, dynamic>> toSupabase(
    Wallet input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$WalletToSupabase(
        input,
        provider: provider,
        repository: repository,
      );
  @override
  Future<Wallet> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$WalletFromSqlite(
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
