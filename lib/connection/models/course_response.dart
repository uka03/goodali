import 'package:json_annotation/json_annotation.dart';
part 'course_response.g.dart';

@JsonSerializable()
class CourseItemResponse {
  @JsonKey(name: "all_task")
  final int? allTasks;
  final String? banner;
  final int? done;
  final int? id;
  final String? name;

  CourseItemResponse({
    this.allTasks,
    this.banner,
    this.done,
    this.id,
    this.name,
  });
  factory CourseItemResponse.fromJson(Map<String, dynamic> json) =>
      _$CourseItemResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CourseItemResponseToJson(this);
}

@JsonSerializable()
class LessonResponse {
  @JsonKey(name: "all_task")
  final int? allTasks;
  final String? banner;
  final int? done;
  final int? id;
  final String? name;
  final bool? opened;
  final bool? expiry;
  @JsonKey(name: "is_bought")
  final int? isBought;
  LessonResponse({
    this.allTasks,
    this.banner,
    this.done,
    this.id,
    this.name,
    this.opened,
    this.expiry,
    this.isBought,
  });
  factory LessonResponse.fromJson(Map<String, dynamic> json) =>
      _$LessonResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LessonResponseToJson(this);
}

@JsonSerializable()
class TaskResponse {
  @JsonKey(name: "answer_data")
  String? answerData;
  final String? banner;
  final String? body;
  final int? id;
  @JsonKey(name: "is_answer")
  final int? isAnswer;
  @JsonKey(name: "is_answered")
  int? isAnswered;
  @JsonKey(name: "lesson_id")
  final int? lessonId;
  @JsonKey(name: "listen_audio")
  final String? listenAudio;
  final String? question;
  final int? type;
  @JsonKey(name: "video_url")
  final String? videoUrl;
  bool? watchVideo;

  TaskResponse({
    this.answerData,
    this.banner,
    this.body,
    this.id,
    this.isAnswer,
    this.isAnswered,
    this.lessonId,
    this.listenAudio,
    this.question,
    this.type,
    this.videoUrl,
    this.watchVideo,
  });
  factory TaskResponse.fromJson(Map<String, dynamic> json) =>
      _$TaskResponseFromJson(json);
  Map<String, dynamic> toJson() => _$TaskResponseToJson(this);
}
