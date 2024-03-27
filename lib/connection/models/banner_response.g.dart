// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BannerResponse _$BannerResponseFromJson(Map<String, dynamic> json) =>
    BannerResponse(
      status: json['status'] as int?,
      msg: json['msg'] as String?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => BannerResponseData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BannerResponseToJson(BannerResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'message': instance.message,
      'data': instance.data,
    };

BannerResponseData _$BannerResponseDataFromJson(Map<String, dynamic> json) =>
    BannerResponseData(
      id: json['id'] as int?,
      banner: json['banner'] as String?,
      productType: json['product_type'] as int?,
      productId: json['product_id'] as int?,
      status: json['status'] as int?,
      title: json['title'] as String?,
    );

Map<String, dynamic> _$BannerResponseDataToJson(BannerResponseData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'banner': instance.banner,
      'product_id': instance.productId,
      'product_type': instance.productType,
      'title': instance.title,
      'status': instance.status,
    };
