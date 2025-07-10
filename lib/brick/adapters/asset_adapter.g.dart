// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Asset> _$AssetFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Asset(
    id: data['id'] == null ? null : data['id'] as String?,
    holdingAccount:
        data['holding_account'] == null
            ? null
            : data['holding_account'] as String?,
    valuationCurrency:
        data['valuation_currency'] == null
            ? null
            : data['valuation_currency'] as String?,
    fiatValue: data['fiat_value'] == null ? null : data['fiat_value'] as num?,
    tokenValue:
        data['token_value'] == null ? null : data['token_value'] as num?,
    governingBoard:
        data['governing_board'] == null
            ? null
            : data['governing_board'] as String?,
    lastTransactionTimestamp:
        data['last_transaction_timestamp'] == null
            ? null
            : data['last_transaction_timestamp'] as String?,
    verifiableCertificateIssuerId:
        data['verifiable_certificate_issuer_id'] == null
            ? null
            : data['verifiable_certificate_issuer_id'] as String?,
    hasVerifiableCertificate:
        data['has_verifiable_certificate'] == null
            ? null
            : data['has_verifiable_certificate'] as bool?,
    isValuated:
        data['is_valuated'] == null ? null : data['is_valuated'] as bool?,
    isMinted: data['is_minted'] == null ? null : data['is_minted'] as bool?,
    isShared: data['is_shared'] == null ? null : data['is_shared'] as bool?,
    isActive: data['is_active'] == null ? null : data['is_active'] as bool?,
    hasDocuments:
        data['has_documents'] == null ? null : data['has_documents'] as bool?,
    status: data['status'] == null ? null : data['status'] as String?,
    createdAt:
        data['created_at'] == null ? null : data['created_at'] as String?,
    updatedAt:
        data['updated_at'] == null ? null : data['updated_at'] as String?,
    profileId:
        data['profile_id'] == null ? null : data['profile_id'] as String?,
    groupId: data['group_id'] == null ? null : data['group_id'] as String?,
    assetDescription:
        data['asset_description'] == null
            ? null
            : data['asset_description'] as String?,
    assetDescriptiveName:
        data['asset_descriptive_name'] == null
            ? null
            : data['asset_descriptive_name'] as String?,
    category: data['category'] == null ? null : data['category'] as String?,
    companyName:
        data['company_name'] == null ? null : data['company_name'] as String?,
    email: data['email'] == null ? null : data['email'] as String?,
    hasReceivedVote:
        data['has_received_vote'] == null
            ? null
            : data['has_received_vote'] as bool?,
    ownershipType:
        data['ownership_type'] == null
            ? null
            : data['ownership_type'] as String?,
  );
}

Future<Map<String, dynamic>> _$AssetToSupabase(
  Asset instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'holding_account': instance.holdingAccount,
    'valuation_currency': instance.valuationCurrency,
    'fiat_value': instance.fiatValue,
    'token_value': instance.tokenValue,
    'governing_board': instance.governingBoard,
    'last_transaction_timestamp': instance.lastTransactionTimestamp,
    'verifiable_certificate_issuer_id': instance.verifiableCertificateIssuerId,
    'has_verifiable_certificate': instance.hasVerifiableCertificate,
    'is_valuated': instance.isValuated,
    'is_minted': instance.isMinted,
    'is_shared': instance.isShared,
    'is_active': instance.isActive,
    'has_documents': instance.hasDocuments,
    'status': instance.status,
    'created_at': instance.createdAt,
    'updated_at': instance.updatedAt,
    'profile_id': instance.profileId,
    'group_id': instance.groupId,
    'asset_description': instance.assetDescription,
    'asset_descriptive_name': instance.assetDescriptiveName,
    'category': instance.category,
    'company_name': instance.companyName,
    'email': instance.email,
    'has_received_vote': instance.hasReceivedVote,
    'ownership_type': instance.ownershipType,
  };
}

Future<Asset> _$AssetFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Asset(
    id: data['id'] == null ? null : data['id'] as String?,
    holdingAccount:
        data['holding_account'] == null
            ? null
            : data['holding_account'] as String?,
    valuationCurrency:
        data['valuation_currency'] == null
            ? null
            : data['valuation_currency'] as String?,
    fiatValue: data['fiat_value'] == null ? null : data['fiat_value'],
    tokenValue: data['token_value'] == null ? null : data['token_value'],
    governingBoard:
        data['governing_board'] == null
            ? null
            : data['governing_board'] as String?,
    lastTransactionTimestamp:
        data['last_transaction_timestamp'] == null
            ? null
            : data['last_transaction_timestamp'] as String?,
    verifiableCertificateIssuerId:
        data['verifiable_certificate_issuer_id'] == null
            ? null
            : data['verifiable_certificate_issuer_id'] as String?,
    hasVerifiableCertificate:
        data['has_verifiable_certificate'] == null
            ? null
            : data['has_verifiable_certificate'] == 1,
    isValuated: data['is_valuated'] == null ? null : data['is_valuated'] == 1,
    isMinted: data['is_minted'] == null ? null : data['is_minted'] == 1,
    isShared: data['is_shared'] == null ? null : data['is_shared'] == 1,
    isActive: data['is_active'] == null ? null : data['is_active'] == 1,
    hasDocuments:
        data['has_documents'] == null ? null : data['has_documents'] == 1,
    status: data['status'] == null ? null : data['status'] as String?,
    createdAt:
        data['created_at'] == null ? null : data['created_at'] as String?,
    updatedAt:
        data['updated_at'] == null ? null : data['updated_at'] as String?,
    profileId:
        data['profile_id'] == null ? null : data['profile_id'] as String?,
    groupId: data['group_id'] == null ? null : data['group_id'] as String?,
    assetDescription:
        data['asset_description'] == null
            ? null
            : data['asset_description'] as String?,
    assetDescriptiveName:
        data['asset_descriptive_name'] == null
            ? null
            : data['asset_descriptive_name'] as String?,
    category: data['category'] == null ? null : data['category'] as String?,
    companyName:
        data['company_name'] == null ? null : data['company_name'] as String?,
    email: data['email'] == null ? null : data['email'] as String?,
    hasReceivedVote:
        data['has_received_vote'] == null
            ? null
            : data['has_received_vote'] == 1,
    ownershipType:
        data['ownership_type'] == null
            ? null
            : data['ownership_type'] as String?,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$AssetToSqlite(
  Asset instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'holding_account': instance.holdingAccount,
    'valuation_currency': instance.valuationCurrency,
    'fiat_value': instance.fiatValue,
    'token_value': instance.tokenValue,
    'governing_board': instance.governingBoard,
    'last_transaction_timestamp': instance.lastTransactionTimestamp,
    'verifiable_certificate_issuer_id': instance.verifiableCertificateIssuerId,
    'has_verifiable_certificate':
        instance.hasVerifiableCertificate == null
            ? null
            : (instance.hasVerifiableCertificate! ? 1 : 0),
    'is_valuated':
        instance.isValuated == null ? null : (instance.isValuated! ? 1 : 0),
    'is_minted':
        instance.isMinted == null ? null : (instance.isMinted! ? 1 : 0),
    'is_shared':
        instance.isShared == null ? null : (instance.isShared! ? 1 : 0),
    'is_active':
        instance.isActive == null ? null : (instance.isActive! ? 1 : 0),
    'has_documents':
        instance.hasDocuments == null ? null : (instance.hasDocuments! ? 1 : 0),
    'status': instance.status,
    'created_at': instance.createdAt,
    'updated_at': instance.updatedAt,
    'profile_id': instance.profileId,
    'group_id': instance.groupId,
    'asset_description': instance.assetDescription,
    'asset_descriptive_name': instance.assetDescriptiveName,
    'category': instance.category,
    'company_name': instance.companyName,
    'email': instance.email,
    'has_received_vote':
        instance.hasReceivedVote == null
            ? null
            : (instance.hasReceivedVote! ? 1 : 0),
    'ownership_type': instance.ownershipType,
  };
}

/// Construct a [Asset]
class AssetAdapter extends OfflineFirstWithSupabaseAdapter<Asset> {
  AssetAdapter();

  @override
  final supabaseTableName = 'assets';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'holdingAccount': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'holding_account',
    ),
    'valuationCurrency': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'valuation_currency',
    ),
    'fiatValue': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'fiat_value',
    ),
    'tokenValue': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'token_value',
    ),
    'governingBoard': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'governing_board',
    ),
    'lastTransactionTimestamp': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'last_transaction_timestamp',
    ),
    'verifiableCertificateIssuerId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'verifiable_certificate_issuer_id',
    ),
    'hasVerifiableCertificate': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'has_verifiable_certificate',
    ),
    'isValuated': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'is_valuated',
    ),
    'isMinted': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'is_minted',
    ),
    'isShared': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'is_shared',
    ),
    'isActive': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'is_active',
    ),
    'hasDocuments': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'has_documents',
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
    'profileId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'profile_id',
    ),
    'groupId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'group_id',
    ),
    'assetDescription': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'asset_description',
    ),
    'assetDescriptiveName': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'asset_descriptive_name',
    ),
    'category': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'category',
    ),
    'companyName': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'company_name',
    ),
    'email': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'email',
    ),
    'hasReceivedVote': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'has_received_vote',
    ),
    'ownershipType': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'ownership_type',
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
    'holdingAccount': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'holding_account',
      iterable: false,
      type: String,
    ),
    'valuationCurrency': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'valuation_currency',
      iterable: false,
      type: String,
    ),
    'fiatValue': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'fiat_value',
      iterable: false,
      type: num,
    ),
    'tokenValue': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'token_value',
      iterable: false,
      type: num,
    ),
    'governingBoard': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'governing_board',
      iterable: false,
      type: String,
    ),
    'lastTransactionTimestamp': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'last_transaction_timestamp',
      iterable: false,
      type: String,
    ),
    'verifiableCertificateIssuerId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'verifiable_certificate_issuer_id',
      iterable: false,
      type: String,
    ),
    'hasVerifiableCertificate': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'has_verifiable_certificate',
      iterable: false,
      type: bool,
    ),
    'isValuated': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'is_valuated',
      iterable: false,
      type: bool,
    ),
    'isMinted': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'is_minted',
      iterable: false,
      type: bool,
    ),
    'isShared': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'is_shared',
      iterable: false,
      type: bool,
    ),
    'isActive': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'is_active',
      iterable: false,
      type: bool,
    ),
    'hasDocuments': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'has_documents',
      iterable: false,
      type: bool,
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
    'profileId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'profile_id',
      iterable: false,
      type: String,
    ),
    'groupId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'group_id',
      iterable: false,
      type: String,
    ),
    'assetDescription': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'asset_description',
      iterable: false,
      type: String,
    ),
    'assetDescriptiveName': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'asset_descriptive_name',
      iterable: false,
      type: String,
    ),
    'category': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'category',
      iterable: false,
      type: String,
    ),
    'companyName': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'company_name',
      iterable: false,
      type: String,
    ),
    'email': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'email',
      iterable: false,
      type: String,
    ),
    'hasReceivedVote': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'has_received_vote',
      iterable: false,
      type: bool,
    ),
    'ownershipType': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'ownership_type',
      iterable: false,
      type: String,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    Asset instance,
    DatabaseExecutor executor,
  ) async => instance.primaryKey;
  @override
  final String tableName = 'Asset';

  @override
  Future<Asset> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$AssetFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    Asset input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$AssetToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Asset> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$AssetFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    Asset input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$AssetToSqlite(input, provider: provider, repository: repository);
}
