import 'dart:developer';

import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(),
  sqliteConfig: SqliteSerializable(),
)
class Transaction extends OfflineFirstWithSupabaseModel {
  String? category;
  String? purpose;
  String? id;
  String? sending_wallet;
  String? account_id;
  String? sending_phone;
  String? receiving_wallet;
  String? receiving_phone;
  // String? receiving_account_number;
  String? recieving_profile_avatar;
  String? sending_profile_avatar;
  String? status;
  String? transferMode;
  String? transactionType;
  String? transferCategory;
  double? amount;
  // String? currency;
  String? createdAt;
  String? updatedAt;
  String? currency;
  String? narrative;

  Transaction({
    // this.currency,
    this.category,
    this.purpose,
    this.id,
    this.account_id,
    this.transactionType,
    this.sending_wallet,
    this.sending_phone,
    this.receiving_phone,
    this.receiving_wallet,
    this.recieving_profile_avatar,
    this.sending_profile_avatar,
    this.status,
    this.transferMode,
    this.transferCategory,
    this.amount,
    // this.receiving_account_number,
    this.createdAt,
    this.updatedAt,
    this.currency,
    this.narrative,
  });

  // Factory method to create an Transaction from a JSON map
  factory Transaction.fromJson(Map<String, dynamic> json) {
    // log('Transaction.fromJson ${json}');

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

    Transaction transaction = Transaction(
      id: json['id'],
      // currency: json['currency'],
      sending_wallet: json['sending_wallet'],
      receiving_wallet: json['receiving_wallet'],
      transactionType: json['transaction_type'],
      recieving_profile_avatar: json['recieving_profile_avatar'],
      sending_profile_avatar: json['sending_profile_avatar'],
      transferMode: json['transfer_mode'],
      category: json['category'],
      purpose: json['purpose'],
      status: json['status'],
      // receiving_account_number: json['receiving_account_number'],
      amount: parseDouble(json['amount'], 0.0),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      currency: json['currency'],
      narrative: json['narrative'],
    );
    return transaction;
  }
  Map<String, dynamic> toJson() {
    return {
      'account_id': account_id,
      // 'currency': currency,
      'sending_phone': sending_phone,
      'transaction_type': transactionType,
      'receiving_phone': receiving_phone,
      'sending_wallet': sending_wallet,
      'receiving_wallet': receiving_wallet,
      // 'receiving_account_number': receiving_account_number,
      'transfer_mode': transferMode,
      'transfer_category': transferCategory,
      'category': category,
      'purpose': purpose,
      'status': status,
      'amount': amount,
      'currency': currency,
      'narrative': narrative,
    };
  }
}
