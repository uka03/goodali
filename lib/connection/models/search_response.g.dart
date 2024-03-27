// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResponse _$SearchResponseFromJson(Map<String, dynamic> json) =>
    SearchResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : SearchResponseData.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String?,
      msg: json['msg'] as String?,
      status: json['status'] as int?,
    );

Map<String, dynamic> _$SearchResponseToJson(SearchResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'message': instance.message,
      'data': instance.data,
    };

SearchResponseData _$SearchResponseDataFromJson(Map<String, dynamic> json) =>
    SearchResponseData(
      album: json['album'] as int?,
      body: json['body'] as String?,
      id: json['id'] as int?,
      module: json['module'] as String?,
      title: json['title'] as String?,
    );

Map<String, dynamic> _$SearchResponseDataToJson(SearchResponseData instance) =>
    <String, dynamic>{
      'album': instance.album,
      'body': instance.body,
      'id': instance.id,
      'module': instance.module,
      'title': instance.title,
    };
