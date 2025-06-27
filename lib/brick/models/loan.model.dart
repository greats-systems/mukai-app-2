import 'dart:developer';
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(),
  sqliteConfig: SqliteSerializable(),
)
class Loan extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  String? id;
  String? createdAt;
  String? borrowerWalletId;
  String? lenderWalletId;
  num? principalAmount;
  num? interestRate;
  num? loanTermMonths;
  String? dueDate;
  String? status;
  num? remainingBalance;
  String? lastPaymentDate;
  String? nextPaymentDate;
  num? paymentAmount;
  String? loanPurpose;
  String? collateralDescription;
  String? profileId;
  String? cooperativeId;
  String? updatedAt;

  Loan({
    this.id,
    this.createdAt,
    this.borrowerWalletId,
    this.lenderWalletId,
    this.principalAmount,
    this.interestRate,
    this.loanTermMonths,
    this.dueDate,
    this.status,
    this.remainingBalance,
    this.lastPaymentDate,
    this.nextPaymentDate,
    this.paymentAmount,
    this.loanPurpose,
    this.collateralDescription,
    this.profileId,
    this.cooperativeId,
    this.updatedAt,
  });

  factory Loan.fromMap(Map<String, dynamic> json) {
    try {
      return Loan(
        id: json["id"],
        createdAt: json['created_at'],
        borrowerWalletId: json['borrower_wallet_id'],
        lenderWalletId: json['lender_wallet_id'],
        principalAmount: json['principal_amount'],
        interestRate: json['interest_rate'],
        loanTermMonths: json['loan_term_months'],
        dueDate: json['due_date'],
        status: json['status'],
        remainingBalance: json['remaining_balance'],
        lastPaymentDate: json['last_payment_date'],
        nextPaymentDate: json['next_payment_date'],
        paymentAmount: json['payment_amount'],
        loanPurpose: json['loan_purpose'],
        collateralDescription: json['collateral_description'],
        profileId: json['profile_id'],
        cooperativeId: json['cooperative_id'],
        updatedAt: json['updated_at'],
      );
    } catch (error, st) {
      log('Loan.fromMap error: $error\n$st');
      return Loan(id: null);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt,
      'borrower_wallet_id': borrowerWalletId,
      'lender_wallet_id': lenderWalletId,
      'principal_amount': principalAmount,
      'interest_rate': interestRate,
      'loan_term_months': loanTermMonths,
      'due_date': dueDate,
      'status': status,
      'remaining_balance': remainingBalance,
      'last_payment_date': lastPaymentDate,
      'next_payment_date': nextPaymentDate,
      'payment_amount': paymentAmount,
      'loan_purpose': loanPurpose,
      'collateral_description': collateralDescription,
      'profile_id': profileId,
      'cooperative_id': cooperativeId,
      'updated_at': updatedAt,
    };
  }
}
