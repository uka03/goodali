// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostResponse _$PostResponseFromJson(Map<String, dynamic> json) => PostResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : PostResponseData.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String?,
      msg: json['msg'] as String?,
      status: json['status'] as int?,
    );

Map<String, dynamic> _$PostResponseToJson(PostResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'message': instance.message,
      'data': instance.data,
    };

PostResponseData _$PostResponseDataFromJson(Map<String, dynamic> json) =>
    PostResponseData(
      avatar: json['avatar'] as String?,
      body: json['body'] as String?,
      createdAt: json['created_at'] as String?,
      id: json['id'] as int?,
      likes: json['likes'] as int?,
      nickname: json['nick_name'] as String?,
      postType: json['post_type'] as int?,
      replys: json['replys'],
      tags: (json['tags'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : TagResponseData.fromJson(e as Map<String, dynamic>))
          .toList(),
      title: json['title'] as String?,
      selfLike: json['self_like'] as bool?,
    );

Map<String, dynamic> _$PostResponseDataToJson(PostResponseData instance) =>
    <String, dynamic>{
      'avatar': instance.avatar,
      'body': instance.body,
      'created_at': instance.createdAt,
      'id': instance.id,
      'likes': instance.likes,
      'nick_name': instance.nickname,
      'post_type': instance.postType,
      'self_like': instance.selfLike,
      'tags': instance.tags,
      'title': instance.title,
      'replys': instance.replys,
    };

ReplyResponse _$ReplyResponseFromJson(Map<String, dynamic> json) =>
    ReplyResponse(
      nickname: json['nick_name'] as String?,
      text: json['text'] as String?,
    );

Map<String, dynamic> _$ReplyResponseToJson(ReplyResponse instance) =>
    <String, dynamic>{
      'nick_name': instance.nickname,
      'text': instance.text,
    };
