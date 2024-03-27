import 'package:goodali/connection/models/base_response.dart';
import 'package:json_annotation/json_annotation.dart';
part 'article_response.g.dart';

@JsonSerializable()
class ArticleResponse extends BaseResponse {
  final List<ArticleResponseData>? data;

  ArticleResponse({
    required this.data,
    super.msg,
    super.status,
  });

  factory ArticleResponse.fromJson(Map<String, dynamic> json) =>
      _$ArticleResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$ArticleResponseToJson(this);
}

@JsonSerializable()
class ArticleResponseData {
  final String? banner;
  final String? body;
  @JsonKey(name: "created_at")
  final String? createdAt;
  @JsonKey(name: "is_special")
  final int? isSpecial;
  final int? id;
  final int? status;
  final String? title;

  ArticleResponseData({
    required this.banner,
    required this.body,
    required this.createdAt,
    required this.id,
    required this.status,
    required this.title,
    required this.isSpecial,
  });
  factory ArticleResponseData.fromJson(Map<String, dynamic> json) =>
      _$ArticleResponseDataFromJson(json);
  Map<String, dynamic> toJson() => _$ArticleResponseDataToJson(this);
}
