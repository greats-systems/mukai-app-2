import 'dart:developer';

import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(),
  sqliteConfig: SqliteSerializable(),
)
class Wallet extends OfflineFirstWithSupabaseModel {
  String? category;
  String? purpose;
  String? id;
  String? wallet_adress;
  String? account_id;
  String? phone_number;
  String? status;
  String? createdAt;
  String? updatedAt;
  bool? isGroupWallet;
  List<dynamic>? childrenWallets;

  double? balance;

  Wallet(
      {this.category,
      this.purpose,
      this.id,
      this.account_id,
      this.wallet_adress,
      this.phone_number,
      this.status,
      this.balance,
      this.createdAt,
      this.updatedAt,
      this.isGroupWallet,
      this.childrenWallets});

  // Factory method to create an Wallet from a JSON map
  factory Wallet.fromJson(Map<String, dynamic> json) {
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

    // log('Wallet.fromJson balance: ${json['balance']}');

    return Wallet(
        id: json['id'],
        wallet_adress: json['wallet_adress'],
        category: json['category'],
        purpose: json['purpose'],
        status: json['status'],
        balance: parseDouble(json['balance'], 0.0),
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        isGroupWallet: json['is_group_wallet'],
        childrenWallets: json['children_wallets']);
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'account_id': account_id,
      'phone_number': phone_number,
      'wallet_adress': wallet_adress,
      'category': category,
      'purpose': purpose,
      'status': status,
      'balance': balance,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'is_group_wallet': isGroupWallet,
      'children_wallets': childrenWallets,
    };
  }
}
