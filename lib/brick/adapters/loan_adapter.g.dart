// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Loan> _$LoanFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Loan(
    id: data['id'] == null ? null : data['id'] as String?,
    createdAt:
        data['created_at'] == null ? null : data['created_at'] as String?,
    borrowerWalletId:
        data['borrower_wallet_id'] == null
            ? null
            : data['borrower_wallet_id'] as String?,
    lenderWalletId:
        data['lender_wallet_id'] == null
            ? null
            : data['lender_wallet_id'] as String?,
    principalAmount:
        data['principal_amount'] == null
            ? null
            : data['principal_amount'] as num?,
    interestRate:
        data['interest_rate'] == null ? null : data['interest_rate'] as num?,
    loanTermMonths:
        data['loan_term_months'] == null
            ? null
            : data['loan_term_months'] as num?,
    dueDate: data['due_date'] == null ? null : data['due_date'] as String?,
    status: data['status'] == null ? null : data['status'] as String?,
    remainingBalance:
        data['remaining_balance'] == null
            ? null
            : data['remaining_balance'] as num?,
    lastPaymentDate:
        data['last_payment_date'] == null
            ? null
            : data['last_payment_date'] as String?,
    nextPaymentDate:
        data['next_payment_date'] == null
            ? null
            : data['next_payment_date'] as String?,
    paymentAmount:
        data['payment_amount'] == null ? null : data['payment_amount'] as num?,
    loanPurpose:
        data['loan_purpose'] == null ? null : data['loan_purpose'] as String?,
    collateralDescription:
        data['collateral_description'] == null
            ? null
            : data['collateral_description'] as String?,
    profileId:
        data['profile_id'] == null ? null : data['profile_id'] as String?,
    cooperativeId:
        data['cooperative_id'] == null
            ? null
            : data['cooperative_id'] as String?,
    updatedAt:
        data['updated_at'] == null ? null : data['updated_at'] as String?,
    hasReceivedVote:
        data['has_received_vote'] == null
            ? null
            : data['has_received_vote'] as bool?,
  );
}

Future<Map<String, dynamic>> _$LoanToSupabase(
  Loan instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'created_at': instance.createdAt,
    'borrower_wallet_id': instance.borrowerWalletId,
    'lender_wallet_id': instance.lenderWalletId,
    'principal_amount': instance.principalAmount,
    'interest_rate': instance.interestRate,
    'loan_term_months': instance.loanTermMonths,
    'due_date': instance.dueDate,
    'status': instance.status,
    'remaining_balance': instance.remainingBalance,
    'last_payment_date': instance.lastPaymentDate,
    'next_payment_date': instance.nextPaymentDate,
    'payment_amount': instance.paymentAmount,
    'loan_purpose': instance.loanPurpose,
    'collateral_description': instance.collateralDescription,
    'profile_id': instance.profileId,
    'cooperative_id': instance.cooperativeId,
    'updated_at': instance.updatedAt,
    'has_received_vote': instance.hasReceivedVote,
  };
}

Future<Loan> _$LoanFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Loan(
    id: data['id'] == null ? null : data['id'] as String?,
    createdAt:
        data['created_at'] == null ? null : data['created_at'] as String?,
    borrowerWalletId:
        data['borrower_wallet_id'] == null
            ? null
            : data['borrower_wallet_id'] as String?,
    lenderWalletId:
        data['lender_wallet_id'] == null
            ? null
            : data['lender_wallet_id'] as String?,
    principalAmount:
        data['principal_amount'] == null
            ? null
            : data['principal_amount'] as num?,
    interestRate:
        data['interest_rate'] == null ? null : data['interest_rate'] as num?,
    loanTermMonths:
        data['loan_term_months'] == null
            ? null
            : data['loan_term_months'] as num?,
    dueDate: data['due_date'] == null ? null : data['due_date'] as String?,
    status: data['status'] == null ? null : data['status'] as String?,
    remainingBalance:
        data['remaining_balance'] == null
            ? null
            : data['remaining_balance'] as num?,
    lastPaymentDate:
        data['last_payment_date'] == null
            ? null
            : data['last_payment_date'] as String?,
    nextPaymentDate:
        data['next_payment_date'] == null
            ? null
            : data['next_payment_date'] as String?,
    paymentAmount:
        data['payment_amount'] == null ? null : data['payment_amount'] as num?,
    loanPurpose:
        data['loan_purpose'] == null ? null : data['loan_purpose'] as String?,
    collateralDescription:
        data['collateral_description'] == null
            ? null
            : data['collateral_description'] as String?,
    profileId:
        data['profile_id'] == null ? null : data['profile_id'] as String?,
    cooperativeId:
        data['cooperative_id'] == null
            ? null
            : data['cooperative_id'] as String?,
    updatedAt:
        data['updated_at'] == null ? null : data['updated_at'] as String?,
    hasReceivedVote:
        data['has_received_vote'] == null
            ? null
            : data['has_received_vote'] == 1,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$LoanToSqlite(
  Loan instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'created_at': instance.createdAt,
    'borrower_wallet_id': instance.borrowerWalletId,
    'lender_wallet_id': instance.lenderWalletId,
    'principal_amount': instance.principalAmount,
    'interest_rate': instance.interestRate,
    'loan_term_months': instance.loanTermMonths,
    'due_date': instance.dueDate,
    'status': instance.status,
    'remaining_balance': instance.remainingBalance,
    'last_payment_date': instance.lastPaymentDate,
    'next_payment_date': instance.nextPaymentDate,
    'payment_amount': instance.paymentAmount,
    'loan_purpose': instance.loanPurpose,
    'collateral_description': instance.collateralDescription,
    'profile_id': instance.profileId,
    'cooperative_id': instance.cooperativeId,
    'updated_at': instance.updatedAt,
    'has_received_vote':
        instance.hasReceivedVote == null
            ? null
            : (instance.hasReceivedVote! ? 1 : 0),
  };
}

/// Construct a [Loan]
class LoanAdapter extends OfflineFirstWithSupabaseAdapter<Loan> {
  LoanAdapter();

  @override
  final supabaseTableName = 'loans';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'createdAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'created_at',
    ),
    'borrowerWalletId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'borrower_wallet_id',
    ),
    'lenderWalletId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'lender_wallet_id',
    ),
    'principalAmount': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'principal_amount',
    ),
    'interestRate': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'interest_rate',
    ),
    'loanTermMonths': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'loan_term_months',
    ),
    'dueDate': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'due_date',
    ),
    'status': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'status',
    ),
    'remainingBalance': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'remaining_balance',
    ),
    'lastPaymentDate': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'last_payment_date',
    ),
    'nextPaymentDate': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'next_payment_date',
    ),
    'paymentAmount': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'payment_amount',
    ),
    'loanPurpose': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'loan_purpose',
    ),
    'collateralDescription': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'collateral_description',
    ),
    'profileId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'profile_id',
    ),
    'cooperativeId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'cooperative_id',
    ),
    'updatedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'updated_at',
    ),
    'hasReceivedVote': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'has_received_vote',
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
    'createdAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'created_at',
      iterable: false,
      type: String,
    ),
    'borrowerWalletId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'borrower_wallet_id',
      iterable: false,
      type: String,
    ),
    'lenderWalletId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'lender_wallet_id',
      iterable: false,
      type: String,
    ),
    'principalAmount': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'principal_amount',
      iterable: false,
      type: num,
    ),
    'interestRate': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'interest_rate',
      iterable: false,
      type: num,
    ),
    'loanTermMonths': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'loan_term_months',
      iterable: false,
      type: num,
    ),
    'dueDate': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'due_date',
      iterable: false,
      type: String,
    ),
    'status': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'status',
      iterable: false,
      type: String,
    ),
    'remainingBalance': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'remaining_balance',
      iterable: false,
      type: num,
    ),
    'lastPaymentDate': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'last_payment_date',
      iterable: false,
      type: String,
    ),
    'nextPaymentDate': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'next_payment_date',
      iterable: false,
      type: String,
    ),
    'paymentAmount': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'payment_amount',
      iterable: false,
      type: num,
    ),
    'loanPurpose': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'loan_purpose',
      iterable: false,
      type: String,
    ),
    'collateralDescription': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'collateral_description',
      iterable: false,
      type: String,
    ),
    'profileId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'profile_id',
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
    'hasReceivedVote': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'has_received_vote',
      iterable: false,
      type: bool,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    Loan instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `Loan` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Loan';

  @override
  Future<Loan> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$LoanFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    Loan input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$LoanToSupabase(input, provider: provider, repository: repository);
  @override
  Future<Loan> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$LoanFromSqlite(input, provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSqlite(
    Loan input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$LoanToSqlite(input, provider: provider, repository: repository);
}
