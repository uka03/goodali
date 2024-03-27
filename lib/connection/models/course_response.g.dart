// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseItemResponse _$CourseItemResponseFromJson(Map<String, dynamic> json) =>
    CourseItemResponse(
      allTasks: json['all_task'] as int?,
      banner: json['banner'] as String?,
      done: json['done'] as int?,
      id: json['id'] as int?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$CourseItemResponseToJson(CourseItemResponse instance) =>
    <String, dynamic>{
      'all_task': instance.allTasks,
      'banner': instance.banner,
      'done': instance.done,
      'id': instance.id,
      'name': instance.name,
    };

LessonResponse _$LessonResponseFromJson(Map<String, dynamic> json) =>
    LessonResponse(
      allTasks: json['all_task'] as int?,
      banner: json['banner'] as String?,
      done: json['done'] as int?,
      id: json['id'] as int?,
      name: json['name'] as String?,
      opened: json['opened'] as bool?,
      expiry: json['expiry'] as bool?,
      isBought: json['is_bought'] as int?,
    );

Map<String, dynamic> _$LessonResponseToJson(LessonResponse instance) =>
    <String, dynamic>{
      'all_task': instance.allTasks,
      'banner': instance.banner,
      'done': instance.done,
      'id': instance.id,
      'name': instance.name,
      'opened': instance.opened,
      'expiry': instance.expiry,
      'is_bought': instance.isBought,
    };

TaskResponse _$TaskResponseFromJson(Map<String, dynamic> json) => TaskResponse(
      answerData: json['answer_data'] as String?,
      banner: json['banner'] as String?,
      body: json['body'] as String?,
      id: json['id'] as int?,
      isAnswer: json['is_answer'] as int?,
      isAnswered: json['is_answered'] as int?,
      lessonId: json['lesson_id'] as int?,
      listenAudio: json['listen_audio'] as String?,
      question: json['question'] as String?,
      type: json['type'] as int?,
      videoUrl: json['video_url'] as String?,
      watchVideo: json['watchVideo'] as bool?,
    );

Map<String, dynamic> _$TaskResponseToJson(TaskResponse instance) =>
    <String, dynamic>{
      'answer_data': instance.answerData,
      'banner': instance.banner,
      'body': instance.body,
      'id': instance.id,
      'is_answer': instance.isAnswer,
      'is_answered': instance.isAnswered,
      'lesson_id': instance.lessonId,
      'listen_audio': instance.listenAudio,
      'question': instance.question,
      'type': instance.type,
      'video_url': instance.videoUrl,
      'watchVideo': instance.watchVideo,
    };
