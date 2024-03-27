import 'package:goodali/connection/models/base_response.dart';
import 'package:json_annotation/json_annotation.dart';
part 'search_response.g.dart';

@JsonSerializable()
class SearchResponse extends BaseResponse {
  List<SearchResponseData?>? data;

  SearchResponse({
    this.data,
    super.message,
    super.msg,
    super.status,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$SearchResponseToJson(this);
}

@JsonSerializable()
class SearchResponseData {
  final int? album;
  final String? body;
  final int? id;
  final String? module;
  final String? title;

  SearchResponseData({
    this.album,
    this.body,
    this.id,
    this.module,
    this.title,
  });
  factory SearchResponseData.fromJson(Map<String, dynamic> json) =>
      _$SearchResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResponseDataToJson(this);
}
