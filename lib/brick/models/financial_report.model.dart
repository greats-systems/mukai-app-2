import 'dart:developer';

import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(),
  sqliteConfig: SqliteSerializable(),
)

/**
 * 
"transaction_id": "07f3b2c6-14eb-4027-ae73-e42a0e15729d",
"amount": 100,
"currency": "usd",
"narrative": "credit",
"created_at": "2025-06-20T18:10:53.783577",
"period_type": "monthly",
"period_start": "2025-06-01T00:00:00+02:00",
"period_end": "2025-07-01T00:00:00+02:00"
  
 */
class FinancialReport extends OfflineFirstWithSupabaseModel {
  String? transactionId;
  double? amount;
  String? currency;
  String? narrative;
  String? createdAt;
  String? periodType;
  String? periodStart;
  String? periodEnd;

  FinancialReport({
    this.transactionId,
    this.amount,
    this.currency,
    this.narrative,
    this.createdAt,
    this.periodType,
    this.periodStart,
    this.periodEnd,
  });

  // Factory method to create an Wallet from a JSON map
  factory FinancialReport.fromJson(Map<String, dynamic> json) {
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

    return FinancialReport(
      transactionId: json['transaction_id'],
      amount: parseDouble(json['amount'], 0.0),
      currency: json['currency'],
      narrative: json['narrative'],
      createdAt: json['created_at'],
      periodType: json['period_type'],
      periodStart: json['period_start'],
      periodEnd: json['period_end'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'transaction_id': transactionId,
      'amount': amount,
      'currency': currency,
      'narrative': narrative,
      'created_at': createdAt,
      'period_type': periodType,
      'period_start': periodStart,
      'period_end': periodEnd,
    };
  }
}
