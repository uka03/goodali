import 'package:goodali/connection/models/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

part "banner_response.g.dart";

@JsonSerializable()
class BannerResponse extends BaseResponse {
  final List<BannerResponseData>? data;
  BannerResponse({
    super.status,
    super.msg,
    super.message,
    this.data,
  });

  factory BannerResponse.fromJson(Map<String, dynamic> json) =>
      _$BannerResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BannerResponseToJson(this);
}

@JsonSerializable()
class BannerResponseData {
  final int? id;
  final String? banner;
  @JsonKey(name: "product_id")
  final int? productId;
  @JsonKey(name: "product_type")
  final int? productType;
  final String? title;
  final int? status;

  BannerResponseData({
    required this.id,
    required this.banner,
    required this.productType,
    required this.productId,
    required this.status,
    required this.title,
  });

  factory BannerResponseData.fromJson(Map<String, dynamic> json) =>
      _$BannerResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$BannerResponseDataToJson(this);
}
