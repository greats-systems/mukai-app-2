import 'dart:developer';
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:mukai/brick/models/milestones.model.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(),
  sqliteConfig: SqliteSerializable(),
)
class Saving extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  String? id;
  String? createdAt;
  String? walletId;
  String? profileId;
  String? groupId;
  String? purpose;
  String? lockEvent;
  num? currentBalance;
  String? lockFeature;
  List<Milestone>? lockMilestones;
  String? lockDate;
  num? lockAmount;
  List<String>? endorserId;
  String? unlockingCode;
  String? status;
  bool? isLocked;
  String? unlockKey;
  String? lastRecommendation;
  String? previousDepositDate;

  Saving({
    this.id,
    this.createdAt,
    this.walletId,
    this.profileId,
    this.groupId,
    this.purpose,
    this.currentBalance,
    this.lockEvent,
    this.lockFeature,
    this.lockMilestones,
    this.lockDate,
    this.lockAmount,
    this.endorserId,
    this.unlockingCode,
    this.status,
    this.isLocked,
    this.unlockKey,
    this.lastRecommendation,
    this.previousDepositDate,
  });

  factory Saving.fromMap(Map<String, dynamic> json) {
    log('Saving.fromMap json $json');
    try {
      return Saving(
        id: json["id"],
        createdAt: json['created_at'],
        walletId: json['wallet_id'],
        profileId: json['profile_id'],
        groupId: json['group_id'],
        purpose: json['purpose'],
        currentBalance: json['current_balance'] ?? 0.0,
        lockFeature: json['lock_feature'],
        lockEvent: json['lock_event'],
        lockMilestones: json['lock_milestones'] != null &&
                json['lock_milestones'].isNotEmpty
            ? (json['lock_milestones'] as List<dynamic>?)!.map((item) {
                return Milestone.fromMap(item) as Milestone;
              }).toList()
            : <Milestone>[],
        lockDate: json['lock_date'],
        lockAmount: json['lock_amount'],
        endorserId:
            (json['endoser_id'] as List?)?.map((e) => e.toString()).toList(),
        unlockingCode: json['unlocking_code'],
        status: json['status'],
        isLocked: json['is_locked'],
        lastRecommendation: json['last_recommendation'],
        previousDepositDate: json['previous_deposit_date'],
        unlockKey: json['unlock_key'],
      );
    } catch (error, st) {
      log('Saving.fromMap error: $error\n$st');
      return Saving(id: null);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt,
      'wallet_id': walletId,
      'profile_id': profileId,
      'group_id': groupId,
      'purpose': purpose,
      'current_balance': currentBalance,
      'lock_feature': lockFeature,
      'lock_event': lockEvent,
      'lock_milestones':
          lockMilestones?.map((milestone) => milestone.toMap()).toList(),
      'lock_date': lockDate?.split('T').first,
      'lock_amount': lockAmount,
      'endoser_id': endorserId,
      'unlocking_code': unlockingCode,
      'status': status,
      'is_locked': isLocked,
      'unlock_key': unlockKey,
      'last_recommendation': lastRecommendation,
      'previous_deposit_date': previousDepositDate,
    };
  }
}
