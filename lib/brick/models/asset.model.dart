import 'dart:developer';

import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(),
  sqliteConfig: SqliteSerializable(),
)
class Asset extends OfflineFirstWithSupabaseModel {
  String? category;
  String? purpose;
  String? id;
  String? title;
  String? walletAddress;
  String? coopId;
  String? country;
  String? city;
  String? province;
  String? neighborhood;
  String? status;
  String? imageUrl;
  String? createdAt;
  String? updatedAt;
  bool? isGroupWallet;
  String? assetDescriptiveName;
  String? assetDescription;
  String? valuationCurrency;
  double? fiatValue;
  double? tokenValue;
  List<dynamic>? assetImages;
  String? lastTransactionTimestamp;
  String? verifiableCertificateIssuerId;
  String? governingBoard;
  String? holdingAccount;
  List<dynamic>? legalDocuments;
  bool? hasVerifiableCertificate;
  bool? isValuated;
  bool? isMinted;
  bool? isShared;
  bool? isActive;
  bool? hasDocuments;
  String? profileId;
  String? groupId;
  bool? hasReceivedVote;

  List<dynamic>? childrenWallets;

  double? amountValue;

  Asset({
    this.id,
    this.assetDescriptiveName,
    this.assetDescription,
    this.valuationCurrency,
    this.fiatValue,
    this.tokenValue,
    this.assetImages,
    this.lastTransactionTimestamp,
    this.verifiableCertificateIssuerId,
    this.governingBoard,
    this.holdingAccount,
    this.legalDocuments,
    this.hasVerifiableCertificate,
    this.isValuated,
    this.isMinted,
    this.isShared,
    this.isActive,
    this.hasDocuments,
    this.profileId,
    this.groupId,
    this.country,
    this.city,
    this.province,
    this.neighborhood,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.hasReceivedVote
  });

  // Factory method to create an Wallet from a JSON map
  factory Asset.fromJson(Map<String, dynamic> json) {
    // log('Wallet.fromJson raw data $json');
    double parseDouble(dynamic value, double defaultValue) {
      if (value == null) {
        return defaultValue;
      }
      try {
        return double.parse(value.toString());
      } catch (e) {
        log('Error parsing double: $value');
        return defaultValue;
      }
    }

    // log('Wallet.fromJson amount_value: ${json['amount_value']}');

    return Asset(
      id: json['id'],
      assetDescriptiveName: json['asset_descriptive_name'],
      assetDescription: json['asset_description'],
      valuationCurrency: json['valuation_currency'],
      fiatValue: parseDouble(json['fiat_value'], 0.0),
      tokenValue: parseDouble(json['token_value'], 0.0),
      assetImages: json['asset_images'],
      lastTransactionTimestamp: json['last_transaction_timestamp'],
      verifiableCertificateIssuerId: json['verifiable_certificate_issuer_id'],
      governingBoard: json['governing_board'],
      holdingAccount: json['holding_account'],
      legalDocuments: json['legal_documents'],
      hasVerifiableCertificate: json['has_verifiable_certificate'],
      isValuated: json['is_valuated'],
      isMinted: json['is_minted'],
      isShared: json['is_shared'],
      isActive: json['is_active'],
      hasDocuments: json['has_documents'],
      profileId: json['profile_id'],
      groupId: json['group_id'],
      country: json['country'],
      city: json['city'],
      province: json['province'],
      neighborhood: json['neighborhood'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      hasReceivedVote: json['has_received_vote']
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'asset_descriptive_name': assetDescriptiveName,
      'asset_description': assetDescription,
      'valuation_currency': valuationCurrency,
      'fiat_value': fiatValue,
      'token_value': tokenValue,
      'asset_images': assetImages,
      'last_transaction_timestamp': lastTransactionTimestamp,
      'verifiable_certificate_issuer_id': verifiableCertificateIssuerId,
      'governing_board': governingBoard,
      'holding_account': holdingAccount,
      'legal_documents': legalDocuments,
      'has_verifiable_certificate': hasVerifiableCertificate,
      'is_valuated': isValuated,
      'is_minted': isMinted,
      'is_shared': isShared,
      'is_active': isActive,
      'has_documents': hasDocuments,
      'profile_id': profileId,
      'group_id': groupId,
      'status': status,
      'country': country,
      'city': city,
      'province': province,
      'neighborhood': neighborhood,
      'image_url': imageUrl,
      'title': title,
      'wallet_adress': walletAddress,
      'category': category,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'has_received_vote': hasReceivedVote,
    };
  }
}
