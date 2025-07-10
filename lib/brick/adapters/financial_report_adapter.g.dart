// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<FinancialReport> _$FinancialReportFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return FinancialReport(
    transactionId:
        data['transaction_id'] == null
            ? null
            : data['transaction_id'] as String?,
    amount: data['amount'] == null ? null : data['amount'] as double?,
    currency: data['currency'] == null ? null : data['currency'] as String?,
    narrative: data['narrative'] == null ? null : data['narrative'] as String?,
    createdAt:
        data['created_at'] == null ? null : data['created_at'] as String?,
    periodType:
        data['period_type'] == null ? null : data['period_type'] as String?,
    periodStart:
        data['period_start'] == null ? null : data['period_start'] as String?,
    periodEnd:
        data['period_end'] == null ? null : data['period_end'] as String?,
  );
}

Future<Map<String, dynamic>> _$FinancialReportToSupabase(
  FinancialReport instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'transaction_id': instance.transactionId,
    'amount': instance.amount,
    'currency': instance.currency,
    'narrative': instance.narrative,
    'created_at': instance.createdAt,
    'period_type': instance.periodType,
    'period_start': instance.periodStart,
    'period_end': instance.periodEnd,
  };
}

Future<FinancialReport> _$FinancialReportFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return FinancialReport(
    transactionId:
        data['transaction_id'] == null
            ? null
            : data['transaction_id'] as String?,
    amount: data['amount'] == null ? null : data['amount'] as double?,
    currency: data['currency'] == null ? null : data['currency'] as String?,
    narrative: data['narrative'] == null ? null : data['narrative'] as String?,
    createdAt:
        data['created_at'] == null ? null : data['created_at'] as String?,
    periodType:
        data['period_type'] == null ? null : data['period_type'] as String?,
    periodStart:
        data['period_start'] == null ? null : data['period_start'] as String?,
    periodEnd:
        data['period_end'] == null ? null : data['period_end'] as String?,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$FinancialReportToSqlite(
  FinancialReport instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'transaction_id': instance.transactionId,
    'amount': instance.amount,
    'currency': instance.currency,
    'narrative': instance.narrative,
    'created_at': instance.createdAt,
    'period_type': instance.periodType,
    'period_start': instance.periodStart,
    'period_end': instance.periodEnd,
  };
}

/// Construct a [FinancialReport]
class FinancialReportAdapter
    extends OfflineFirstWithSupabaseAdapter<FinancialReport> {
  FinancialReportAdapter();

  @override
  final supabaseTableName = 'financial_reports';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'transactionId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'transaction_id',
    ),
    'amount': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'amount',
    ),
    'currency': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'currency',
    ),
    'narrative': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'narrative',
    ),
    'createdAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'created_at',
    ),
    'periodType': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'period_type',
    ),
    'periodStart': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'period_start',
    ),
    'periodEnd': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'period_end',
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
    'transactionId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'transaction_id',
      iterable: false,
      type: String,
    ),
    'amount': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'amount',
      iterable: false,
      type: double,
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
    'createdAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'created_at',
      iterable: false,
      type: String,
    ),
    'periodType': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'period_type',
      iterable: false,
      type: String,
    ),
    'periodStart': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'period_start',
      iterable: false,
      type: String,
    ),
    'periodEnd': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'period_end',
      iterable: false,
      type: String,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    FinancialReport instance,
    DatabaseExecutor executor,
  ) async => instance.primaryKey;
  @override
  final String tableName = 'FinancialReport';

  @override
  Future<FinancialReport> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$FinancialReportFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    FinancialReport input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$FinancialReportToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<FinancialReport> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$FinancialReportFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    FinancialReport input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$FinancialReportToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
