// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberShipResponse _$MemberShipResponseFromJson(Map<String, dynamic> json) =>
    MemberShipResponse(
      banner: json['banner'] as String?,
      body: json['body'] as String?,
      id: json['id'] as int?,
      isBought: json['is_bought'] as bool?,
      isSpecial: json['is_special'] as int?,
      name: json['name'] as String?,
      opennedDate: json['openned_date'] as String?,
      order: json['order'] as int?,
      price: json['price'] as int?,
      productId: json['product_id'] as int?,
      status: json['status'] as int?,
      tBanner: json['t_banner'] as String?,
      tName: json['t_name'] as String?,
    );

Map<String, dynamic> _$MemberShipResponseToJson(MemberShipResponse instance) =>
    <String, dynamic>{
      'banner': instance.banner,
      'body': instance.body,
      'id': instance.id,
      'is_bought': instance.isBought,
      'is_special': instance.isSpecial,
      'name': instance.name,
      'openned_date': instance.opennedDate,
      'order': instance.order,
      'price': instance.price,
      'product_id': instance.productId,
      'status': instance.status,
      't_banner': instance.tBanner,
      't_name': instance.tName,
    };
