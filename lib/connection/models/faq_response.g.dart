// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faq_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FaqResponse _$FaqResponseFromJson(Map<String, dynamic> json) => FaqResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : FaqResponseData.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String?,
      msg: json['msg'] as String?,
      status: json['status'] as int?,
    );

Map<String, dynamic> _$FaqResponseToJson(FaqResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'message': instance.message,
      'data': instance.data,
    };

FaqResponseData _$FaqResponseDataFromJson(Map<String, dynamic> json) =>
    FaqResponseData(
      answer: json['answer'] as String?,
      id: json['id'] as int?,
      question: json['question'] as String?,
      status: json['status'] as int?,
    );

Map<String, dynamic> _$FaqResponseDataToJson(FaqResponseData instance) =>
    <String, dynamic>{
      'answer': instance.answer,
      'id': instance.id,
      'question': instance.question,
      'status': instance.status,
    };
