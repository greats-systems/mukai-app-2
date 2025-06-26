import 'dart:developer';

import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(),
  sqliteConfig: SqliteSerializable(),
)

class GroupMembers extends OfflineFirstWithSupabaseModel {
  String? id;
  String? memberId;  
  String? createdAt;
  String? role;
  String? cooperativeId;
  String? updatedAt;

  GroupMembers({
    this.id,
    this.memberId,
    this.createdAt,
    this.role,
    this.cooperativeId,
    this.updatedAt,
  });

  // Factory method to create an Wallet from a JSON map
  factory GroupMembers.fromJson(Map<String, dynamic> json) {
    return GroupMembers(
      id: json['id'],
      memberId: json['member_id'],
      createdAt: json['created_at'],
      role: json['role'],
      cooperativeId: json['cooperative_id'],
      updatedAt: json['updated_at'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'member_id': memberId,
      'created_at': createdAt,
      'role': role,
      'cooperative_id': cooperativeId,
      'updated_at': updatedAt,
    };
  }
}
