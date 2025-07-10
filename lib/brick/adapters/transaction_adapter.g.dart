// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Transaction> _$TransactionFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Transaction(
    category: data['category'] == null ? null : data['category'] as String?,
    purpose: data['purpose'] == null ? null : data['purpose'] as String?,
    id: data['id'] == null ? null : data['id'] as String?,
    sending_wallet:
        data['sending_wallet'] == null
            ? null
            : data['sending_wallet'] as String?,
    account_id:
        data['account_id'] == null ? null : data['account_id'] as String?,
    sending_phone:
        data['sending_phone'] == null ? null : data['sending_phone'] as String?,
    receiving_wallet:
        data['receiving_wallet'] == null
            ? null
            : data['receiving_wallet'] as String?,
    receiving_phone:
        data['receiving_phone'] == null
            ? null
            : data['receiving_phone'] as String?,
    recieving_profile_avatar:
        data['recieving_profile_avatar'] == null
            ? null
            : data['recieving_profile_avatar'] as String?,
    sending_profile_avatar:
        data['sending_profile_avatar'] == null
            ? null
            : data['sending_profile_avatar'] as String?,
    status: data['status'] == null ? null : data['status'] as String?,
    transferMode:
        data['transfer_mode'] == null ? null : data['transfer_mode'] as String?,
    transactionType:
        data['transaction_type'] == null
            ? null
            : data['transaction_type'] as String?,
    transferCategory:
        data['transfer_category'] == null
            ? null
            : data['transfer_category'] as String?,
    amount: data['amount'] == null ? null : data['amount'] as double?,
    createdAt:
        data['created_at'] == null ? null : data['created_at'] as String?,
    updatedAt:
        data['updated_at'] == null ? null : data['updated_at'] as String?,
    currency: data['currency'] == null ? null : data['currency'] as String?,
    narrative: data['narrative'] == null ? null : data['narrative'] as String?,
  );
}

Future<Map<String, dynamic>> _$TransactionToSupabase(
  Transaction instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'category': instance.category,
    'purpose': instance.purpose,
    'id': instance.id,
    'sending_wallet': instance.sending_wallet,
    'account_id': instance.account_id,
    'sending_phone': instance.sending_phone,
    'receiving_wallet': instance.receiving_wallet,
    'receiving_phone': instance.receiving_phone,
    'recieving_profile_avatar': instance.recieving_profile_avatar,
    'sending_profile_avatar': instance.sending_profile_avatar,
    'status': instance.status,
    'transfer_mode': instance.transferMode,
    'transaction_type': instance.transactionType,
    'transfer_category': instance.transferCategory,
    'amount': instance.amount,
    'created_at': instance.createdAt,
    'updated_at': instance.updatedAt,
    'currency': instance.currency,
    'narrative': instance.narrative,
  };
}

Future<Transaction> _$TransactionFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Transaction(
    category: data['category'] == null ? null : data['category'] as String?,
    purpose: data['purpose'] == null ? null : data['purpose'] as String?,
    id: data['id'] == null ? null : data['id'] as String?,
    sending_wallet:
        data['sending_wallet'] == null
            ? null
            : data['sending_wallet'] as String?,
    account_id:
        data['account_id'] == null ? null : data['account_id'] as String?,
    sending_phone:
        data['sending_phone'] == null ? null : data['sending_phone'] as String?,
    receiving_wallet:
        data['receiving_wallet'] == null
            ? null
            : data['receiving_wallet'] as String?,
    receiving_phone:
        data['receiving_phone'] == null
            ? null
            : data['receiving_phone'] as String?,
    recieving_profile_avatar:
        data['recieving_profile_avatar'] == null
            ? null
            : data['recieving_profile_avatar'] as String?,
    sending_profile_avatar:
        data['sending_profile_avatar'] == null
            ? null
            : data['sending_profile_avatar'] as String?,
    status: data['status'] == null ? null : data['status'] as String?,
    transferMode:
        data['transfer_mode'] == null ? null : data['transfer_mode'] as String?,
    transactionType:
        data['transaction_type'] == null
            ? null
            : data['transaction_type'] as String?,
    transferCategory:
        data['transfer_category'] == null
            ? null
            : data['transfer_category'] as String?,
    amount: data['amount'] == null ? null : data['amount'] as double?,
    createdAt:
        data['created_at'] == null ? null : data['created_at'] as String?,
    updatedAt:
        data['updated_at'] == null ? null : data['updated_at'] as String?,
    currency: data['currency'] == null ? null : data['currency'] as String?,
    narrative: data['narrative'] == null ? null : data['narrative'] as String?,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$TransactionToSqlite(
  Transaction instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'category': instance.category,
    'purpose': instance.purpose,
    'id': instance.id,
    'sending_wallet': instance.sending_wallet,
    'account_id': instance.account_id,
    'sending_phone': instance.sending_phone,
    'receiving_wallet': instance.receiving_wallet,
    'receiving_phone': instance.receiving_phone,
    'recieving_profile_avatar': instance.recieving_profile_avatar,
    'sending_profile_avatar': instance.sending_profile_avatar,
    'status': instance.status,
    'transfer_mode': instance.transferMode,
    'transaction_type': instance.transactionType,
    'transfer_category': instance.transferCategory,
    'amount': instance.amount,
    'created_at': instance.createdAt,
    'updated_at': instance.updatedAt,
    'currency': instance.currency,
    'narrative': instance.narrative,
  };
}

/// Construct a [Transaction]
class TransactionAdapter extends OfflineFirstWithSupabaseAdapter<Transaction> {
  TransactionAdapter();

  @override
  final supabaseTableName = 'transactions';
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
    'sending_wallet': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'sending_wallet',
    ),
    'account_id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'account_id',
    ),
    'sending_phone': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'sending_phone',
    ),
    'receiving_wallet': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'receiving_wallet',
    ),
    'receiving_phone': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'receiving_phone',
    ),
    'recieving_profile_avatar': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'recieving_profile_avatar',
    ),
    'sending_profile_avatar': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'sending_profile_avatar',
    ),
    'status': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'status',
    ),
    'transferMode': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'transfer_mode',
    ),
    'transactionType': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'transaction_type',
    ),
    'transferCategory': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'transfer_category',
    ),
    'amount': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'amount',
    ),
    'createdAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'created_at',
    ),
    'updatedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'updated_at',
    ),
    'currency': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'currency',
    ),
    'narrative': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'narrative',
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
    'sending_wallet': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'sending_wallet',
      iterable: false,
      type: String,
    ),
    'account_id': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'account_id',
      iterable: false,
      type: String,
    ),
    'sending_phone': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'sending_phone',
      iterable: false,
      type: String,
    ),
    'receiving_wallet': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'receiving_wallet',
      iterable: false,
      type: String,
    ),
    'receiving_phone': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'receiving_phone',
      iterable: false,
      type: String,
    ),
    'recieving_profile_avatar': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'recieving_profile_avatar',
      iterable: false,
      type: String,
    ),
    'sending_profile_avatar': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'sending_profile_avatar',
      iterable: false,
      type: String,
    ),
    'status': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'status',
      iterable: false,
      type: String,
    ),
    'transferMode': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'transfer_mode',
      iterable: false,
      type: String,
    ),
    'transactionType': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'transaction_type',
      iterable: false,
      type: String,
    ),
    'transferCategory': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'transfer_category',
      iterable: false,
      type: String,
    ),
    'amount': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'amount',
      iterable: false,
      type: double,
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
    'currency': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'currency',
      iterable: false,
      type: String,
    ),
    'narrative': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'narrative',
      iterable: false,
      type: String,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    Transaction instance,
    DatabaseExecutor executor,
  ) async => instance.primaryKey;
  @override
  final String tableName = 'Transaction';

  @override
  Future<Transaction> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$TransactionFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    Transaction input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$TransactionToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Transaction> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$TransactionFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    Transaction input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$TransactionToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
