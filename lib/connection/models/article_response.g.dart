// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleResponse _$ArticleResponseFromJson(Map<String, dynamic> json) =>
    ArticleResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ArticleResponseData.fromJson(e as Map<String, dynamic>))
          .toList(),
      msg: json['msg'] as String?,
      status: json['status'] as int?,
    );

Map<String, dynamic> _$ArticleResponseToJson(ArticleResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'data': instance.data,
    };

ArticleResponseData _$ArticleResponseDataFromJson(Map<String, dynamic> json) =>
    ArticleResponseData(
      banner: json['banner'] as String?,
      body: json['body'] as String?,
      createdAt: json['created_at'] as String?,
      id: json['id'] as int?,
      status: json['status'] as int?,
      title: json['title'] as String?,
      isSpecial: json['is_special'] as int?,
    );

Map<String, dynamic> _$ArticleResponseDataToJson(
        ArticleResponseData instance) =>
    <String, dynamic>{
      'banner': instance.banner,
      'body': instance.body,
      'created_at': instance.createdAt,
      'is_special': instance.isSpecial,
      'id': instance.id,
      'status': instance.status,
      'title': instance.title,
    };
