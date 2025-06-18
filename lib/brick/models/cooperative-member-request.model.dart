class CooperativeMemberRequest {
  final String? id;
  final String? updatedAt;
  final String? coopId;
  final String? memberId;
  final String? requestType;
  String? status;
  final String? resolvedBy;
  final String? message;
  final String? profileFirstName;
  final String? profileLastName;
  final String? mostRecentContent;
  final String? mostRecentContentFormat;
  final String? groupId;

  CooperativeMemberRequest({
    this.id,
    this.updatedAt,
    this.coopId,
    this.memberId,
    this.requestType,
    this.status,
    this.resolvedBy,
    this.message,
    this.profileFirstName,
    this.profileLastName,
    this.mostRecentContent,
    this.mostRecentContentFormat,
    this.groupId,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'updated_at': updatedAt,
        'coop_id': coopId,
        'member_id': memberId,
        'request_type': requestType,
        'status': status,
        'resolved_by': resolvedBy,
        'message': message,
        'profile_first_name': profileFirstName,
        'profile_last_name': profileLastName,
        'most_recent_content': mostRecentContent,
        'most_recent_content_format': mostRecentContentFormat,
        'group_id': groupId,
      };

  factory CooperativeMemberRequest.fromJson(Map<String, dynamic> json) =>
      CooperativeMemberRequest(
        id: json['id'] as String?,
        updatedAt: json['updated_at'] as String?,
        coopId: json['coop_id'] as String?,
        memberId: json['member_id'] as String?,
        requestType: json['request_type'] as String?,
        status: json['status'] as String?,
        resolvedBy: json['resolved_by'] as String?,
        message: json['message'] as String?,
        profileFirstName: json['profile_first_name'] as String?,
        profileLastName: json['profile_last_name'] as String?,
        mostRecentContent: json['most_recent_content'] as String?,
        mostRecentContentFormat: json['most_recent_content_format'] as String?,
        groupId: json['group_id'] as String?,
      );
}
