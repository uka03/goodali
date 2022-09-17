class CourseLessonsTasks {
  String? body;
  int? id;
  int? lessonId;
  String? listenAudio;
  String? question;
  int? type;
  String? videoUrl;

  CourseLessonsTasks(
      {this.body,
      this.id,
      this.lessonId,
      this.listenAudio,
      this.question,
      this.type,
      this.videoUrl});

  CourseLessonsTasks.fromJson(Map<String, dynamic> json) {
    body = json['body'];
    id = json['id'];
    lessonId = json['lesson_id'];
    listenAudio = json['listen_audio'];
    question = json['question'];
    type = json['type'];
    videoUrl = json['video_url'];
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
    return data;
  }
}
