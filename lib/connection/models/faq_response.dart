import 'package:goodali/connection/models/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'faq_response.g.dart';

@JsonSerializable()
class FaqResponse extends BaseResponse {
  final List<FaqResponseData?>? data;

  FaqResponse({
    this.data,
    super.message,
    super.msg,
    super.status,
  });

  factory FaqResponse.fromJson(Map<String, dynamic> json) =>
      _$FaqResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FaqResponseToJson(this);
}

@JsonSerializable()
class FaqResponseData {
  final String? answer;
  final int? id;
  final String? question;
  final int? status;

  FaqResponseData({
    this.answer,
    this.id,
    this.question,
    this.status,
  });

  factory FaqResponseData.fromJson(Map<String, dynamic> json) =>
      _$FaqResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$FaqResponseDataToJson(this);
}
