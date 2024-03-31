// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductResponse _$ProductResponseFromJson(Map<String, dynamic> json) =>
    ProductResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : ProductResponseData.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String?,
      status: json['status'] as int?,
      msg: json['msg'] as String?,
    );

Map<String, dynamic> _$ProductResponseToJson(ProductResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'message': instance.message,
      'data': instance.data,
    };

ProductResponseData _$ProductResponseDataFromJson(Map<String, dynamic> json) =>
    ProductResponseData(
      name: json['name'] as String?,
      audio: json['audio'] as String?,
      audioCount: json['audio_count'] as int?,
      banner: json['banner'] as String?,
      body: json['body'] as String?,
      id: json['id'] as int?,
      moodId: json['mood_id'] as int?,
      isBought: json['is_bought'] as bool?,
      isSpecial: json['is_special'] as int?,
      order: json['order'] as int?,
      price: json['price'] as int?,
      productId: json['product_id'] as int?,
      status: json['status'] as int?,
      title: json['title'] as String?,
      pausedTime: json['paused_time'] as int?,
      totalTime: json['total_time'] as int?,
      createdAt: json['created_at'] as String?,
      expireAt: json['expire_at'] as String?,
      lectureTitle: json['lecture_title'] as String?,
      albumTitle: json['album_title'] as String?,
      albumId: json['albumId'] as int?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$ProductResponseDataToJson(
        ProductResponseData instance) =>
    <String, dynamic>{
      'audio': instance.audio,
      'audio_count': instance.audioCount,
      'banner': instance.banner,
      'body': instance.body,
      'id': instance.id,
      'is_bought': instance.isBought,
      'is_special': instance.isSpecial,
      'order': instance.order,
      'price': instance.price,
      'product_id': instance.productId,
      'created_at': instance.createdAt,
      'expire_at': instance.expireAt,
      'status': instance.status,
      'title': instance.title,
      'name': instance.name,
      'lecture_title': instance.lectureTitle,
      'type': instance.type,
      'album_title': instance.albumTitle,
      'mood_id': instance.moodId,
      'albumId': instance.albumId,
      'total_time': instance.totalTime,
      'paused_time': instance.pausedTime,
    };
