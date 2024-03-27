// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mood_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MoodResponseData _$MoodResponseDataFromJson(Map<String, dynamic> json) =>
    MoodResponseData(
      audio: json['audio'] as String?,
      banner: json['banner'] as String?,
      body: json['body'] as String?,
      id: json['id'] as int?,
      moodId: json['mood_id'] as int?,
      status: json['status'] as int?,
      title: json['title'] as String?,
    );

Map<String, dynamic> _$MoodResponseDataToJson(MoodResponseData instance) =>
    <String, dynamic>{
      'audio': instance.audio,
      'banner': instance.banner,
      'body': instance.body,
      'id': instance.id,
      'mood_id': instance.moodId,
      'status': instance.status,
      'title': instance.title,
    };
