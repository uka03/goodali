import 'package:goodali/models/products_model.dart';

class CourseLessonsTasksModel {
  String? body;
  int? id;
  int? lessonId;
  String? listenAudio;
  String? question;
  int? type;
  String? videoUrl;
  int? isAnswer;
  String? answerData;
  int? isAnswered;
  int? duration;
  int? position;
  String? banner;
  Products? products;

  CourseLessonsTasksModel(
      {this.body,
      this.id,
      this.lessonId,
      this.listenAudio,
      this.question,
      this.type,
      this.isAnswer,
      this.videoUrl,
      this.isAnswered,
      this.answerData,
      this.banner});

  CourseLessonsTasksModel.fromJson(Map<String, dynamic> json) {
    body = json['body'];
    id = json['id'];
    lessonId = json['lesson_id'];
    listenAudio = json['listen_audio'];
    question = json['question'];
    type = json['type'];
    videoUrl = json['video_url'];
    isAnswer = json['is_answer'];
    answerData = json['answer_data'];
    banner = json['banner'];
    isAnswered = json['is_answered'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['body'] = body;
    data['id'] = id;
    data['lesson_id'] = lessonId;
    data['listen_audio'] = listenAudio;
    data['question'] = question;
    data['type'] = type;
    data['video_url'] = videoUrl;
    data['is_answer'] = isAnswer;
    data['answer_data'] = answerData;
    data['banner'] = banner;
    data['is_answered'] = isAnswered;
    return data;
  }
}
