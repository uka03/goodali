import 'package:json_annotation/json_annotation.dart';
part 'membership_response.g.dart';

@JsonSerializable()
class MemberShipResponse {
  final String? banner;
  final String? body;
  final int? id;
  @JsonKey(name: "is_bought")
  final bool? isBought;
  @JsonKey(name: "is_special")
  final int? isSpecial;
  final String? name;
  @JsonKey(name: "openned_date")
  final String? opennedDate;
  final int? order;
  final int? price;
  @JsonKey(name: "product_id")
  final int? productId;
  final int? status;
  @JsonKey(name: "t_banner")
  final String? tBanner;
  @JsonKey(name: "t_name")
  final String? tName;

  MemberShipResponse({
    this.banner,
    this.body,
    this.id,
    this.isBought,
    this.isSpecial,
    this.name,
    this.opennedDate,
    this.order,
    this.price,
    this.productId,
    this.status,
    this.tBanner,
    this.tName,
  });

  factory MemberShipResponse.fromJson(Map<String, dynamic> json) =>
      _$MemberShipResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MemberShipResponseToJson(this);
}
