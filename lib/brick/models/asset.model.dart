import 'dart:developer';
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(),
  sqliteConfig: SqliteSerializable(),
)
class Asset extends OfflineFirstWithSupabaseModel {
  @Supabase(name: 'id')
  @Sqlite(name: 'id')
  String? id;

  @Supabase(name: 'holding_account')
  @Sqlite(name: 'holding_account')
  String? holdingAccount;

  @Supabase(name: 'valuation_currency')
  @Sqlite(name: 'valuation_currency')
  String? valuationCurrency;

  @Supabase(
    name: 'fiat_value',
  )
  @Sqlite(name: 'fiat_value', columnType: Column.Double)
  num? fiatValue;

  @Supabase(name: 'token_value')
  @Sqlite(name: 'token_value', columnType: Column.Double)
  num? tokenValue;

  @Supabase(name: 'governing_board')
  @Sqlite(name: 'governing_board')
  String? governingBoard;

  @Supabase(name: 'last_transaction_timestamp')
  @Sqlite(name: 'last_transaction_timestamp')
  String? lastTransactionTimestamp;

  @Supabase(name: 'verifiable_certificate_issuer_id')
  @Sqlite(name: 'verifiable_certificate_issuer_id')
  String? verifiableCertificateIssuerId;

  @Supabase(name: 'legal_documents')
  @Sqlite(name: 'legal_documents')
  List<dynamic>? legalDocuments;

  @Supabase(name: 'has_verifiable_certificate')
  @Sqlite(name: 'has_verifiable_certificate')
  bool? hasVerifiableCertificate;

  @Supabase(name: 'is_valuated')
  @Sqlite(name: 'is_valuated')
  bool? isValuated;

  @Supabase(name: 'is_minted')
  @Sqlite(name: 'is_minted')
  bool? isMinted;

  @Supabase(name: 'is_shared')
  @Sqlite(name: 'is_shared')
  bool? isShared;

  @Supabase(name: 'is_active')
  @Sqlite(name: 'is_active')
  bool? isActive;

  @Supabase(name: 'has_documents')
  @Sqlite(name: 'has_documents')
  bool? hasDocuments;

  @Supabase(name: 'status')
  @Sqlite(name: 'status')
  String? status;

  @Supabase(name: 'created_at')
  @Sqlite(name: 'created_at')
  String? createdAt;

  @Supabase(name: 'updated_at')
  @Sqlite(name: 'updated_at')
  String? updatedAt;

  @Supabase(name: 'profile_id')
  @Sqlite(name: 'profile_id')
  String? profileId;

  @Supabase(name: 'group_id')
  @Sqlite(name: 'group_id')
  String? groupId;

  @Supabase(name: 'asset_description')
  @Sqlite(name: 'asset_description')
  String? assetDescription;

  @Supabase(name: 'asset_images')
  @Sqlite(name: 'asset_images')
  List<dynamic>? assetImages;

  @Supabase(name: 'asset_descriptive_name')
  @Sqlite(name: 'asset_descriptive_name')
  String? assetDescriptiveName;

  @Supabase(name: 'category')
  @Sqlite(name: 'category')
  String? category;

  @Supabase(name: 'company_name')
  @Sqlite(name: 'company_name')
  String? companyName;

  @Supabase(name: 'email')
  @Sqlite(name: 'email')
  String? email;

  @Supabase(name: 'has_received_vote')
  @Sqlite(name: 'has_received_vote')
  bool? hasReceivedVote;

  @Supabase(name: 'ownership_type')
  @Sqlite(name: 'ownership_type')
  String? ownershipType;

  Asset({
    this.id,
    this.holdingAccount,
    this.valuationCurrency,
    this.fiatValue,
    this.tokenValue,
    this.governingBoard,
    this.lastTransactionTimestamp,
    this.verifiableCertificateIssuerId,
    this.legalDocuments,
    this.hasVerifiableCertificate,
    this.isValuated,
    this.isMinted,
    this.isShared,
    this.isActive,
    this.hasDocuments,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.profileId,
    this.groupId,
    this.assetDescription,
    this.assetImages,
    this.assetDescriptiveName,
    this.category,
    this.companyName,
    this.email,
    this.hasReceivedVote,
    this.ownershipType,
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    // Enhanced parsing methods
    log('json to parse: $json');
    double? parseDouble(dynamic value) {
      if (value == null) return null;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) {
        try {
          return double.parse(value);
        } catch (e) {
          log('Error parsing string to double: $value');
          return null;
        }
      }
      log('Unexpected type for double: ${value.runtimeType}');
      return null;
    }

    bool? parseBool(dynamic value) {
      if (value == null) return null;
      if (value is bool) return value;
      if (value is int) return value != 0;
      if (value is String) {
        return value.toLowerCase() == 'true';
      }
      log('Unexpected type for bool: ${value.runtimeType}');
      return null;
    }

    List<dynamic>? parseList(dynamic value) {
      if (value == null) return null;
      if (value is List) return value;
      log('Unexpected type for list: ${value.runtimeType}');
      return null;
    }

    return Asset(
      id: json['id']?.toString(),
      createdAt: json['created_at']?.toString() ?? DateTime.now().toString(),
      holdingAccount: json['holding_account']?.toString(),
      valuationCurrency: json['valuation_currency']?.toString(),
      fiatValue: json['fiat_value'],
      tokenValue: json['token_value'],
      governingBoard: json['governing_board']?.toString(),
      lastTransactionTimestamp: json['last_transaction_timestamp']?.toString(),
      verifiableCertificateIssuerId:
          json['verifiable_certificate_issuer_id']?.toString(),
      legalDocuments: parseList(json['legal_documents']),
      hasVerifiableCertificate: parseBool(json['has_verifiable_certificate']),
      isValuated: parseBool(json['is_valuated']),
      isMinted: parseBool(json['is_minted']),
      isShared: parseBool(json['is_shared']),
      isActive: parseBool(json['is_active']),
      hasDocuments: parseBool(json['has_documents']),
      status: json['status']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      profileId: json['profile_id']?.toString(),
      groupId: json['group_id']?.toString(),
      assetDescription: json['asset_description']?.toString(),
      assetImages: parseList(json['asset_images']),
      assetDescriptiveName: json['asset_descriptive_name']?.toString(),
      category: json['category']?.toString(),
      companyName: json['company_name']?.toString(),
      email: json['email']?.toString(),
      hasReceivedVote: parseBool(json['has_received_vote']),
      ownershipType: json['ownership_type']?.toString(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'holding_account': holdingAccount,
      'valuation_currency': valuationCurrency,
      'fiat_value': fiatValue?.toDouble() ?? 0.0,
      'token_value': tokenValue?.toDouble() ?? 0.0,
      'governing_board': governingBoard,
      'last_transaction_timestamp': lastTransactionTimestamp,
      'verifiable_certificate_issuer_id': verifiableCertificateIssuerId,
      'legal_documents': legalDocuments,
      'has_verifiable_certificate': hasVerifiableCertificate,
      'is_valuated': isValuated,
      'is_minted': isMinted,
      'is_shared': isShared,
      'is_active': isActive,
      'has_documents': hasDocuments,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'profile_id': profileId,
      'group_id': groupId,
      'asset_description': assetDescription,
      'asset_images': assetImages,
      'asset_descriptive_name': assetDescriptiveName,
      'category': category,
      'company_name': companyName,
      'email': email,
      'has_received_vote': hasReceivedVote,
      'ownership_type': ownershipType,
    };
  }
}
