import 'package:goodali/connection/models/base_response.dart';
import 'package:json_annotation/json_annotation.dart';
part 'video_response.g.dart';

@JsonSerializable()
class VideoResponse extends BaseResponse {
  final List<VideoResponseData?>? data;

  VideoResponse({
    super.status,
    super.msg,
    this.data,
  });

  factory VideoResponse.fromJson(Map<String, dynamic> json) =>
      _$VideoResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$VideoResponseToJson(this);
}

@JsonSerializable()
class VideoResponseData {
  final String? banner;
  final String? body;
  @JsonKey(name: "created_at")
  final String? createdAt;
  final int? id;
  final int? status;
  final String? title;
  @JsonKey(name: "video_url")
  final String? videoUrl;

  VideoResponseData({
    required this.banner,
    required this.body,
    required this.createdAt,
    required this.id,
    required this.status,
    required this.title,
    required this.videoUrl,
  });
  factory VideoResponseData.fromJson(Map<String, dynamic> json) =>
      _$VideoResponseDataFromJson(json);
  Map<String, dynamic> toJson() => _$VideoResponseDataToJson(this);
}
