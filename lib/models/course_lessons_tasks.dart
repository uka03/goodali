class CourseLessonsTasksModel {
  String? body;
  int? id;
  int? lessonId;
  String? listenAudio;
  String? question;
  int? type;
  String? videoUrl;
  int? isAnswer;

  CourseLessonsTasksModel(
      {this.body,
      this.id,
      this.lessonId,
      this.listenAudio,
      this.question,
      this.type,
      this.isAnswer,
      this.videoUrl});

  CourseLessonsTasksModel.fromJson(Map<String, dynamic> json) {
    body = json['body'];
    id = json['id'];
    lessonId = json['lesson_id'];
    listenAudio = json['listen_audio'];
    question = json['question'];
    type = json['type'];
    videoUrl = json['video_url'];
    isAnswer = json['is_answer'];
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
    return data;
  }
}
