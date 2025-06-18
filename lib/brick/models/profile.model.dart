// import 'dart:convert';
// import 'dart:developer';

import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(),
  sqliteConfig: SqliteSerializable(),
)
class Profile extends OfflineFirstWithSupabaseModel {
  Profile({
    this.status,
    this.password,
    this.first_name,
    this.last_name,
    this.profile_image_url,
    this.profile_image_id,
    this.id,
    this.full_name,
    this.gender,
    this.account_type,
    this.profile_picture_id,
    this.email,
    this.phone,
    this.business,
    this.city,
    this.country,
    this.neighbourhood,
    this.province_state,
    this.push_token,
    this.wallet_address,
    this.wallet_balance,
    this.createdAt,
    this.last_access,
    this.updatedAt,
    this.permissions = const [],
  });
  String? status;
  String? password;
  String? profile_image_url;
  String? profile_image_id;
  String? gender;
  String? first_name;
  String? last_name;
  String? full_name;
  String? profile_picture_id;
  String? account_type;
  String? email;
  String? phone;
  String? city;
  String? country;
  String? neighbourhood;
  String? province_state;
  String? id;
  double? wallet_balance;
  String? wallet_address;
  String? push_token;
  List<String>? business;
  DateTime? last_access;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<String>? permissions;
  factory Profile.fromMap(Map<String, dynamic> json) {
    // log('profile map ${json}');
    Profile profile = Profile(
      id: json["id"] ?? 'No id',
      last_access: json["last_sign_in_at"] != null
          ? DateTime.parse(json["last_sign_in_at"])
          : DateTime.now(),
      first_name: json['first_name'] ?? 'No first name',
      last_name: json['last_name'] ?? 'No last name',
      full_name: '${json['first_name']} ${json['last_name']}',
      profile_image_id: json['avatar'] ?? 'No avatar',
      profile_picture_id: json['avatar'] ?? 'No profile picture',
      profile_image_url: json['avatar'] ?? 'No profile image',
      wallet_balance: json["wallet_balance"] != null
          ? double.parse(json["wallet_balance"].toString())
          : 0.0,
      wallet_address: json["wallet_address"] ?? 'No wallet address',
      account_type: json["account_type"] ?? 'No account type',
      email: json["email"] ?? 'No email',
      push_token: json["push_token"] ?? 'No push token',
      phone: json["phone"] ?? 'No phone',
      country: json['country'] ?? 'No country',
      neighbourhood: json['neighbourhood'] ?? 'No neighbourhood',
      province_state: json['province_state'] ?? 'No province state',
      city: json['city'] ?? 'No city',
      status: json['status'] ?? 'No status',
    );
    // log('profile ${profile}');

    return profile;
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "full_name": full_name,
      "first_name": first_name,
      "last_name": last_name,
      "profile_image_id": profile_image_id,
      "profile_image_url": profile_image_url,
      "gender": gender,
      "account_type": account_type,
      "profile_picture_id": profile_picture_id,
      "email": email,
      "wallet_balance": wallet_balance,
      "wallet_address": wallet_address,
      "push_token": push_token,
      "phone": phone,
      'city': city,
      'country': country,
      'neighbourhood': neighbourhood,
      'province_state': province_state,
      "status": status,
    };
  }
}
