import 'dart:convert';
import 'dart:developer';

import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:mukai/brick/models/profile.model.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(),
  sqliteConfig: SqliteSerializable(),
)
class Group extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  String? id;
  String? admin_id;
  String? wallet_id;
  String? name;
  String? city;
  String? country;
  double monthly_sub;
  double interest_rate;
  // List<Profile>? members;

  Group({
    this.id,
    this.admin_id,
    this.wallet_id,
    this.name,
    // this.members,
    this.city,
    this.country,
    this.monthly_sub = 0.0,
    this.interest_rate = 0.0,
  });

  factory Group.fromMap(Map<String, dynamic> json) {
    try {
      // Handle members conversion
      List<Profile>? members;

      if (json['members'] != null) {
        if (json['members'] is List) {
          members = (json['members'] as List)
              .where((item) => item != null) // Filter out null items
              .map((item) => Profile.fromMap(item))
              .toList();
        } else if (json['members'] is String) {
          // Handle case where members might be stored as JSON string
          try {
            final parsed = jsonDecode(json['members']) as List;
            members = parsed
                .where((item) => item != null)
                .map((item) => Profile.fromMap(item))
                .toList();
          } catch (e) {
            log('Error parsing members JSON string: $e');
            members = null;
          }
        }
      }

      return Group(
        id: json["id"],
        name: json['name'],
        country: json['country'],
        wallet_id: json['wallet_id'],
        city: json['city'],
        monthly_sub: (json['monthly_sub'] as num?)?.toDouble() ?? 0.0,
        interest_rate: (json['interest_rate'] as num?)?.toDouble() ?? 0.0,
        // members: members,
        admin_id: json['admin_id'],
      );
    } catch (error, st) {
      log('Group.fromMap error: $error\n$st');
      return Group(id: null);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'country': country,
      'wallet_id': wallet_id,
      'city': city,
      'monthly_sub': monthly_sub,
      'interest_rate':interest_rate,
      // 'members': members,
      'admin_id': admin_id
    };
  }
}
