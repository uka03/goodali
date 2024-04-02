import 'package:goodali/connection/models/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment_response.g.dart';

@JsonSerializable()
class PaymentResponse {
  @JsonKey(name: "goodali_order_id")
  String? goodaliOrderId;
  @JsonKey(name: "invoice_id")
  String? invoiceId;
  @JsonKey(name: "qPay_shortUrl")
  String? qPayShortUrl;
  @JsonKey(name: "qr_image")
  String? qrImage;
  @JsonKey(name: "qr_text")
  String? qrText;
  List<OrderUrls?>? urls;
  String? url;

  PaymentResponse({
    this.goodaliOrderId,
    this.invoiceId,
    this.qPayShortUrl,
    this.qrImage,
    this.qrText,
    this.urls,
    this.url,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentResponseToJson(this);
}

@JsonSerializable()
class OrderUrls {
  String? description;
  String? link;
  String? logo;
  String? name;

  OrderUrls({
    this.description,
    this.link,
    this.logo,
    this.name,
  });

  factory OrderUrls.fromJson(Map<String, dynamic> json) =>
      _$OrderUrlsFromJson(json);
  Map<String, dynamic> toJson() => _$OrderUrlsToJson(this);
}

@JsonSerializable()
class InvoiceResponse extends BaseResponse {
  InvoiceResponseData? data;

  InvoiceResponse({
    this.data,
    super.message,
    super.status,
    super.msg,
  });

  factory InvoiceResponse.fromJson(Map<String, dynamic> json) =>
      _$InvoiceResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$InvoiceResponseToJson(this);
}

@JsonSerializable()
class InvoiceResponseData {
  @JsonKey(name: "invoice_number")
  String? invoiceNumber;
  bool? status;

  InvoiceResponseData({
    this.invoiceNumber,
    this.status,
  });

  factory InvoiceResponseData.fromJson(Map<String, dynamic> json) =>
      _$InvoiceResponseDataFromJson(json);
  Map<String, dynamic> toJson() => _$InvoiceResponseDataToJson(this);
}
