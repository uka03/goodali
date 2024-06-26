// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentResponse _$PaymentResponseFromJson(Map<String, dynamic> json) =>
    PaymentResponse(
      goodaliOrderId: json['goodali_order_id'] as String?,
      invoiceId: json['invoice_id'] as String?,
      qPayShortUrl: json['qPay_shortUrl'] as String?,
      qrImage: json['qr_image'] as String?,
      qrText: json['qr_text'] as String?,
      urls: (json['urls'] as List<dynamic>?)
          ?.map((e) =>
              e == null ? null : OrderUrls.fromJson(e as Map<String, dynamic>))
          .toList(),
      url: json['url'] as String?,
    );

Map<String, dynamic> _$PaymentResponseToJson(PaymentResponse instance) =>
    <String, dynamic>{
      'goodali_order_id': instance.goodaliOrderId,
      'invoice_id': instance.invoiceId,
      'qPay_shortUrl': instance.qPayShortUrl,
      'qr_image': instance.qrImage,
      'qr_text': instance.qrText,
      'urls': instance.urls,
      'url': instance.url,
    };

OrderUrls _$OrderUrlsFromJson(Map<String, dynamic> json) => OrderUrls(
      description: json['description'] as String?,
      link: json['link'] as String?,
      logo: json['logo'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$OrderUrlsToJson(OrderUrls instance) => <String, dynamic>{
      'description': instance.description,
      'link': instance.link,
      'logo': instance.logo,
      'name': instance.name,
    };

InvoiceResponse _$InvoiceResponseFromJson(Map<String, dynamic> json) =>
    InvoiceResponse(
      data: json['data'] == null
          ? null
          : InvoiceResponseData.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String?,
      status: json['status'] as int?,
      msg: json['msg'] as String?,
    );

Map<String, dynamic> _$InvoiceResponseToJson(InvoiceResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'message': instance.message,
      'data': instance.data,
    };

InvoiceResponseData _$InvoiceResponseDataFromJson(Map<String, dynamic> json) =>
    InvoiceResponseData(
      invoiceNumber: json['invoice_number'] as String?,
      status: json['status'] as bool?,
    );

Map<String, dynamic> _$InvoiceResponseDataToJson(
        InvoiceResponseData instance) =>
    <String, dynamic>{
      'invoice_number': instance.invoiceNumber,
      'status': instance.status,
    };
