import 'dart:developer';

import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:mukai/brick/models/profile.model.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(),
  sqliteConfig: SqliteSerializable(),
)
class Cooperative extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  final String? id;
  final String? name;
  final String? wallet_id;

  final String? category;
  final String? city;
  final String? county;
  final String? province_state;
  final String? admin_id;
  final List<Profile>? members;
  final double? monthly_sub;

  Cooperative({
    this.id,
    this.name,
    this.wallet_id,
    this.category,
    this.monthly_sub,
    this.members,
    this.city,
    this.county,
    this.province_state,
    this.admin_id,
  });

  factory Cooperative.fromMap(Map<String, dynamic> json) {
    try {
      var coop = Cooperative(
        id: json["id"],
        admin_id: json['admin_id'],
        wallet_id: json['wallet_id'],
        name: json['name'],
        category: json['category'],
        monthly_sub: json['monthly_sub'],
        county: json['county'],
        province_state: json['province_state'],
        city: json['city'],
      );
      return coop;
    } catch (error, st) {
      log('coop.fromMap error $error $st');
      return Cooperative(id: null);
    }
  }
}
