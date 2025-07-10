import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(),
  sqliteConfig: SqliteSerializable(),
)
class CooperativeMemberApproval extends OfflineFirstWithSupabaseModel {
  @Supabase(name: 'id')
  @Sqlite(name: 'id')
  String? id;

  @Supabase(name: 'created_at')
  @Sqlite(name: 'created_at')
  String? createdAt;

  @Supabase(name: 'profile_id')
  @Sqlite(name: 'profile_id')
  String? profileId;

  @Supabase(name: 'group_id')
  @Sqlite(name: 'group_id')
  String? groupId;

  @Supabase(name: 'number_of_members')
  @Sqlite(name: 'number_of_members')
  int? numberOfMembers;

  @Supabase(name: 'supporting_votes')
  @Sqlite(name: 'supporting_votes')
  List<String>? supportingVotes;

  @Supabase(name: 'opposing_votes')
  @Sqlite(name: 'opposing_votes')
  List<String>? opposingVotes;

  @Supabase(name: 'poll_description')
  @Sqlite(name: 'poll_description')
  String? pollDescription;

  @Supabase(name: 'asset_id')
  @Sqlite(name: 'asset_id')
  String? assetId;

  @Supabase(name: 'loan_id')
  @Sqlite(name: 'loan_id')
  String? loanId;

  @Supabase(name: 'updated_at')
  @Sqlite(name: 'updated_at')
  String? updatedAt;

  @Supabase(name: 'additional_info')
  @Sqlite(name: 'additional_info')
  dynamic additionalInfo;

  @Supabase(name: 'consensus_reached')
  @Sqlite(name: 'consensus_reached')
  bool? consensusReached;

  CooperativeMemberApproval({
    this.id,
    this.createdAt,
    this.profileId,
    this.groupId,
    this.numberOfMembers,
    this.supportingVotes,
    this.opposingVotes,
    this.pollDescription,
    this.assetId,
    this.loanId,
    this.updatedAt,
    this.additionalInfo,
    this.consensusReached,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'created_at': createdAt,
        'profile_id': profileId,
        'group_id': groupId,
        'number_of_members': numberOfMembers,
        'supporting_votes': supportingVotes,
        'opposing_votes': opposingVotes,
        'poll_description': pollDescription,
        'asset_id': assetId,
        'loan_id': loanId,
        'updated_at': updatedAt,
        'consensus_reached': consensusReached,
        'additional_info': additionalInfo
      };

  factory CooperativeMemberApproval.fromJson(Map<String, dynamic> json) {
    // Helper function to parse votes list
    List<String> parseVotes(dynamic votes) {
      if (votes == null) return [];
      if (votes is List) {
        return votes.map((e) => e.toString()).toList();
      }
      return [votes.toString()];
    }

    return CooperativeMemberApproval(
        id: json['id'],
        createdAt: json['created_at'],
        profileId: json['profile_id'],
        groupId: json['group_id'],
        numberOfMembers: json['number_of_members'],
        supportingVotes: parseVotes(json['supporting_votes']),
        opposingVotes: parseVotes(json['opposing_votes']),
        pollDescription: json['poll_description'],
        assetId: json['asset_id'],
        loanId: json['loan_id'],
        updatedAt: json['updated_at'],
        additionalInfo: json['additional_info'],
        consensusReached: json['consensus_reached']);
  }
}
