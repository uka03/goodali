import 'package:goodali/connection/models/base_response.dart';
import 'package:json_annotation/json_annotation.dart';
part 'tag_response.g.dart';

@JsonSerializable()
class TagResponse extends BaseResponse {
  final List<TagResponseData?>? data;

  TagResponse({
    required this.data,
    super.message,
    super.status,
    super.msg,
  });

  factory TagResponse.fromJson(Map<String, dynamic> json) =>
      _$TagResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TagResponseToJson(this);
}

@JsonSerializable()
class TagResponseData {
  final int? id;
  final String? banner;
  final String? description;
  final String? name;

  TagResponseData({
    required this.banner,
    required this.description,
    required this.id,
    required this.name,
  });

  factory TagResponseData.fromJson(Map<String, dynamic> json) =>
      _$TagResponseDataFromJson(json);
  Map<String, dynamic> toJson() => _$TagResponseDataToJson(this);
}
