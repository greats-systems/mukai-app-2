class CooperativeMemberApproval {
  String? id;
  String? createdAt;
  String? profileId;
  String? groupId;
  int? numberOfMembers;
  List<String>? supportingVotes;
  List<String>? opposingVotes;
  String? pollDescription;
  String? assetId;
  String? loanId;
  String? updatedAt;
  dynamic additionalInfo;
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
