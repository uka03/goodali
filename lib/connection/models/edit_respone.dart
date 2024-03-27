import 'package:goodali/connection/models/base_response.dart';
import 'package:json_annotation/json_annotation.dart';
part 'edit_respone.g.dart';

@JsonSerializable()
class EditResponse extends BaseResponse {
  final EditResponseData? name;
  final String? resp;

  EditResponse({
    super.status,
    super.msg,
    super.message,
    this.name,
    this.resp,
  });

  factory EditResponse.fromJson(Map<String, dynamic> json) =>
      _$EditResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$EditResponseToJson(this);
}

@JsonSerializable()
class EditResponseData {
  final String? data;
  EditResponseData({
    this.data,
  });

  factory EditResponseData.fromJson(Map<String, dynamic> json) =>
      _$EditResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$EditResponseDataToJson(this);
}
