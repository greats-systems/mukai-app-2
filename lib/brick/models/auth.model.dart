import 'dart:convert';

AuthDataResponse authResponseFromJson(String str) => 
    AuthDataResponse.fromJson(json.decode(str));

String authResponseToJson(AuthDataResponse data) => 
    json.encode(data.toJson());

class AuthDataResponse {
  final String status;
  final int statusCode;
  final String message;
  final String accessToken;
  final AuthUser user;
  final dynamic data;
  final dynamic error;

  AuthDataResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.accessToken,
    required this.user,
    this.data,
    this.error,
  });

  factory AuthDataResponse.fromJson(Map<String, dynamic> json) => AuthDataResponse(
        status: json["status"] ?? "",
        statusCode: json["statusCode"] ?? 0,
        message: json["message"] ?? "",
        accessToken: json["access_token"] ?? "",
        user: AuthUser.fromJson(json["user"] ?? {}),
        data: json["data"],
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "statusCode": statusCode,
        "message": message,
        "access_token": accessToken,
        "user": user.toJson(),
        "data": data,
        "error": error,
      };
}

class AuthUser {
  final String id;
  final String? email;
  final String firstName;
  final String lastName;
  final String accountType;
  final String? pushToken;
  final String? avatar;
  final String? nationalIdUrl;
  final String? passportUrl;

  AuthUser({
    required this.id,
    this.email,
    required this.firstName,
    required this.lastName,
    required this.accountType,
    this.pushToken,
    this.avatar,
    this.nationalIdUrl,
    this.passportUrl,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
        id: json["id"] ?? "",
        email: json["email"],
        firstName: json["first_name"] ?? "",
        lastName: json["last_name"] ?? "",
        accountType: json["account_type"] ?? "",
        pushToken: json["push_token"],
        avatar: json["avatar"],
        nationalIdUrl: json["national_id_url"],
        passportUrl: json["passport_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "account_type": accountType,
        "push_token": pushToken,
        "avatar": avatar,
        "national_id_url": nationalIdUrl,
        "passport_url": passportUrl,
      };
}