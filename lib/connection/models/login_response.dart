import 'package:json_annotation/json_annotation.dart';
part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  final String? message;
  final String? email;
  final String? avatar;
  @JsonKey(name: "has_traing")
  final bool? hasTraing;
  final String? nickname;
  final String? token;
  final int? expiry;

  LoginResponse({
    required this.avatar,
    required this.email,
    required this.expiry,
    required this.hasTraing,
    required this.message,
    required this.nickname,
    required this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
