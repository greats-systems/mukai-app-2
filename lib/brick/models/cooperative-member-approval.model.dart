class CooperativeMemberApproval {
  final String? id;
  final String? createdAt;
  final String? groupId;
  final String? numberOfMembers;
  final String? supportingVotes;
  final String? opposingVotes;
  final String? pollDescription;
  final String? assetId;
  final String? loanId;
  final String? updatedAt;

  CooperativeMemberApproval({
    this.id,
    this.createdAt,
    this.groupId,
    this.numberOfMembers,
    this.supportingVotes,
    this.opposingVotes,
    this.pollDescription,
    this.assetId,
    this.loanId,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'created_at': createdAt,
        'group_id': groupId,
        'number_of_members': numberOfMembers,
        'supporting_votes': supportingVotes,
        'opposing_votes': opposingVotes,
        'poll_description': pollDescription,
        'asset_id': assetId,
        'loan_id': loanId,
        'updated_at': updatedAt,
      };

  factory CooperativeMemberApproval.fromJson(Map<String, dynamic> json) =>
      CooperativeMemberApproval(
        id: 'id',
        createdAt: 'created_at',
        groupId: 'group_id',
        numberOfMembers: 'number_of_members',
        supportingVotes: 'supporting_votes',
        opposingVotes: 'opposing_votes',
        pollDescription: 'poll_description',
        assetId: 'asset_id',
        loanId: 'loan_id',
        updatedAt: 'updated_at',
      );
}