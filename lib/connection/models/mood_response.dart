import 'package:json_annotation/json_annotation.dart';
part 'mood_response.g.dart';

@JsonSerializable()
class MoodResponseData {
  final String? audio;
  final String? banner;
  final String? body;
  final int? id;
  @JsonKey(name: "mood_id")
  final int? moodId;
  final int? status;
  final String? title;

  MoodResponseData({
    required this.audio,
    required this.banner,
    required this.body,
    required this.id,
    required this.moodId,
    required this.status,
    required this.title,
  });
  factory MoodResponseData.fromJson(Map<String, dynamic> json) =>
      _$MoodResponseDataFromJson(json);
  Map<String, dynamic> toJson() => _$MoodResponseDataToJson(this);
}
