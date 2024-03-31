import 'package:goodali/connection/models/base_response.dart';
import 'package:json_annotation/json_annotation.dart';
part 'product_response.g.dart';

@JsonSerializable()
class ProductResponse extends BaseResponse {
  List<ProductResponseData?>? data;

  ProductResponse({this.data, super.message, super.status, super.msg});

  factory ProductResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$ProductResponseToJson(this);
}

@JsonSerializable()
class ProductResponseData {
  final String? audio;
  @JsonKey(name: "audio_count")
  final int? audioCount;
  final String? banner;
  final String? body;
  final int? id;
  @JsonKey(name: "is_bought")
  bool? isBought;
  @JsonKey(name: "is_special")
  final int? isSpecial;
  final int? order;
  final int? price;
  @JsonKey(name: "product_id")
  final int? productId;
  @JsonKey(name: "created_at")
  final String? createdAt;
  @JsonKey(name: "expire_at")
  final String? expireAt;
  final int? status;
  final String? title;
  final String? name;
  @JsonKey(name: "lecture_title")
  final String? lectureTitle;
  final String? type;
  @JsonKey(name: "album_title")
  final String? albumTitle;
  @JsonKey(name: "mood_id")
  final int? moodId;
  int? albumId;
  @JsonKey(name: "total_time")
  int? totalTime;
  @JsonKey(name: "paused_time")
  int? pausedTime;
  ProductResponseData({
    required this.name,
    required this.audio,
    required this.audioCount,
    required this.banner,
    required this.body,
    required this.id,
    required this.moodId,
    required this.isBought,
    required this.isSpecial,
    required this.order,
    required this.price,
    required this.productId,
    required this.status,
    required this.title,
    required this.pausedTime,
    required this.totalTime,
    required this.createdAt,
    required this.expireAt,
    required this.lectureTitle,
    required this.albumTitle,
    required this.albumId,
    this.type,
  });

  factory ProductResponseData.fromJson(Map<String, dynamic> json) =>
      _$ProductResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$ProductResponseDataToJson(this);
}
