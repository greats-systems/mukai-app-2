import 'dart:developer';

import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(),
  sqliteConfig: SqliteSerializable(),
)
class Wallet extends OfflineFirstWithSupabaseModel {
  @Supabase(name: 'id')
  @Sqlite()
  String? id;

  @Supabase(name: 'holding_account')
  @Sqlite()
  String? holding_account;

  @Supabase(name: 'address')
  @Sqlite()
  String? address;

  @Supabase(name: 'status')
  @Sqlite()
  String? status;

  @Supabase(name: 'balance')
  @Sqlite()
  double? balance;

  @Supabase(name: 'last_transaction_timestamp')
  @Sqlite()
  String? last_transaction_timestamp;

  @Supabase(name: 'parent_wallet_id')
  @Sqlite()
  String? parent_wallet_id;

  @Supabase(name: 'provider')
  @Sqlite()
  String? provider;

  @Supabase(name: 'default_currency')
  @Sqlite()
  String? default_currency;

  @Supabase(name: 'business_id')
  @Sqlite()
  String? business_id;

  @Supabase(name: 'is_shared')
  @Sqlite()
  bool? is_shared;

  @Supabase(name: 'is_active')
  @Sqlite()
  bool? is_active;

  @Supabase(name: 'is_sub_wallet')
  @Sqlite()
  bool? is_sub_wallet;

  @Supabase(name: 'profile_id')
  @Sqlite()
  String? profile_id;

  @Supabase(name: 'coop_id')
  @Sqlite()
  String? coop_id;

  @Supabase(name: 'is_group_wallet')
  @Sqlite()
  bool? is_group_wallet;

  @Supabase(name: 'children_wallets')
  @Sqlite()
  List<dynamic>? children_wallets;

  @Supabase(name: 'group_id')
  @Sqlite()
  String? group_id;
  /*
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
  */

  Wallet({
    this.id,
    this.holding_account,
    this.address,
    this.status,
    this.balance,
    this.parent_wallet_id,
    this.provider,
    this.default_currency,
    this.business_id,
    this.is_shared,
    this.is_active,
    this.is_sub_wallet,
    this.profile_id,
    this.coop_id,
    this.is_group_wallet,
    this.children_wallets,
    this.group_id,
    this.last_transaction_timestamp,
  });

  // Factory method to create an Wallet from a JSON map
  factory Wallet.fromJson(Map<String, dynamic> json) {
    // log('Wallet.fromJson raw data $json');
    // final uuid = Uuid();
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
      holding_account: json['holding_account'],
      address: json['address'],
      status: json['status'],
      balance: parseDouble(json['balance'], 0.0),
      parent_wallet_id: json['parent_wallet_id'],
      provider: json['provider'],
      default_currency: json['default_currency'],
      business_id: json['business_id'],
      is_shared: json['is_shared'],
      is_active: json['is_active'],
      is_sub_wallet: json['is_sub_wallet'],
      profile_id: json['profile_id'],
      coop_id: json['coop_id'],
      is_group_wallet: json['is_group_wallet'],
      children_wallets: json['children_wallets'],
      group_id: json['group_id'],
      last_transaction_timestamp: json['last_transaction_timestamp'],
    );
    /*
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
        */
  }
  /*
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
  */
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'holding_account': holding_account,
      'address': address,
      'status': status,
      'balance': balance,
      'parent_wallet_id': parent_wallet_id,
      'provider': provider,
      'default_currency': default_currency,
      'business_id': business_id,
      'is_shared': is_shared,
      'is_active': is_active,
      'is_sub_wallet': is_sub_wallet,
      'profile_id': profile_id,
      'coop_id': coop_id,
      'is_group_wallet': is_group_wallet,
      'children_wallets': children_wallets,
      'group_id': group_id,
      'last_transaction_timestamp': last_transaction_timestamp,
    };
  }
}
