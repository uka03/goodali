// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoResponse _$VideoResponseFromJson(Map<String, dynamic> json) =>
    VideoResponse(
      status: json['status'] as int?,
      msg: json['msg'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : VideoResponseData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VideoResponseToJson(VideoResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'data': instance.data,
    };

VideoResponseData _$VideoResponseDataFromJson(Map<String, dynamic> json) =>
    VideoResponseData(
      banner: json['banner'] as String?,
      body: json['body'] as String?,
      createdAt: json['created_at'] as String?,
      id: json['id'] as int?,
      status: json['status'] as int?,
      title: json['title'] as String?,
      videoUrl: json['video_url'] as String?,
    );

Map<String, dynamic> _$VideoResponseDataToJson(VideoResponseData instance) =>
    <String, dynamic>{
      'banner': instance.banner,
      'body': instance.body,
      'created_at': instance.createdAt,
      'id': instance.id,
      'status': instance.status,
      'title': instance.title,
      'video_url': instance.videoUrl,
    };
