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
