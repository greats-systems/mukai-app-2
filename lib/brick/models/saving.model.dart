import 'dart:developer';
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:mukai/src/apps/home/apps/savings/set_milestone.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(),
  sqliteConfig: SqliteSerializable(),
)
class Saving extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  String? id;
  String? createdAt;
  String? profileWalletId;
  num? lockamount;
  String? lockDate;
  String? status;
  num? remainingBalance;
  num? currentAmount;
  String? lastDepositDate;
  String? nextDepositDate;
  String? purpose;
  String? description;
  List<Milestone>? milestones;
  String? profileId;
  String? updatedAt;
  bool? hasEndorser;

  Saving({
    this.id,
    this.createdAt,
    this.profileWalletId,
    this.lockamount,
    this.lockDate,
    this.status,
    this.remainingBalance,
    this.lastDepositDate,
    this.nextDepositDate,
    this.purpose,
    this.milestones,
    this.description,
    this.profileId,
    this.updatedAt,
    this.hasEndorser,
  });

  factory Saving.fromMap(Map<String, dynamic> json) {
    log('Saving.fromMap json $json');
    try {
      return Saving(
          id: json["id"],
          createdAt: json['created_at'],
          milestones:
              (json['milestones'])?.map((e) => Milestone.fromMap(e)).toList(),
          profileWalletId: json['profile_wallet_id'],
          lockamount: json['lockamount'],
          lockDate: json['lock_date'],
          status: json['status'],
          remainingBalance: json['remaining_balance'],
          lastDepositDate: json['last_deposit_date'],
          nextDepositDate: json['next_deposit_date'],
          purpose: json['purpose'],
          description: json['description'],
          profileId: json['profile_id'],
          updatedAt: json['updated_at'],
          hasEndorser: json['has_endorser']);
    } catch (error, st) {
      log('Saving.fromMap error: $error\n$st');
      return Saving(id: null);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt,
      'profile_wallet_id': profileWalletId,
      'lockamount': lockamount,
      'lock_date': lockDate,
      'status': status,
      'remaining_balance': remainingBalance,
      'last_deposit_date': lastDepositDate,
      'next_deposit_date': nextDepositDate,
      'purpose': purpose,
      'milestones': milestones?.map((e) => e).toList(),
      'description': description,
      'profile_id': profileId,
      'updated_at': updatedAt,
      'has_endorser': hasEndorser
    };
  }
}

// 1. Define the Milestone class
class Milestone {
  String name;
  String amount;
  Milestone({required this.name, required this.amount});

  static fromMap(Map<String, dynamic> json) {
    return Milestone(
      name: json['name'],
      amount: json['amount'],
    );
  }

  static Map<String, dynamic> toMap(Milestone milestone) {
    return {
      'name': milestone.name,
      'amount': milestone.amount,
    };
  }
}
