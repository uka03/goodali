// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_respone.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditResponse _$EditResponseFromJson(Map<String, dynamic> json) => EditResponse(
      status: json['status'] as int?,
      msg: json['msg'] as String?,
      message: json['message'] as String?,
      name: json['name'] == null
          ? null
          : EditResponseData.fromJson(json['name'] as Map<String, dynamic>),
      resp: json['resp'] as String?,
    );

Map<String, dynamic> _$EditResponseToJson(EditResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'message': instance.message,
      'name': instance.name,
      'resp': instance.resp,
    };

EditResponseData _$EditResponseDataFromJson(Map<String, dynamic> json) =>
    EditResponseData(
      data: json['data'] as String?,
    );

Map<String, dynamic> _$EditResponseDataToJson(EditResponseData instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
