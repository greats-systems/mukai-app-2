import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(),
  sqliteConfig: SqliteSerializable(),
)
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

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'amount': amount,
    };
  }
}
