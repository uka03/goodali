// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TagResponse _$TagResponseFromJson(Map<String, dynamic> json) => TagResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : TagResponseData.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String?,
      status: json['status'] as int?,
      msg: json['msg'] as String?,
    );

Map<String, dynamic> _$TagResponseToJson(TagResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'message': instance.message,
      'data': instance.data,
    };

TagResponseData _$TagResponseDataFromJson(Map<String, dynamic> json) =>
    TagResponseData(
      banner: json['banner'] as String?,
      description: json['description'] as String?,
      id: json['id'] as int?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$TagResponseDataToJson(TagResponseData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'banner': instance.banner,
      'description': instance.description,
      'name': instance.name,
    };
