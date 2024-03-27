// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      avatar: json['avatar'] as String?,
      email: json['email'] as String?,
      expiry: json['expiry'] as int?,
      hasTraing: json['has_traing'] as bool?,
      message: json['message'] as String?,
      nickname: json['nickname'] as String?,
      token: json['token'] as String?,
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'email': instance.email,
      'avatar': instance.avatar,
      'has_traing': instance.hasTraing,
      'nickname': instance.nickname,
      'token': instance.token,
      'expiry': instance.expiry,
    };
