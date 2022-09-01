class GetMoodList {
  String? audio;
  String? banner;
  String? body;
  int? id;
  int? moodId;
  int? status;
  String? title;

  GetMoodList(
      {this.banner,
      this.id,
      this.audio,
      this.body,
      this.moodId,
      this.status,
      this.title});

  factory GetMoodList.fromJson(Map<String, dynamic> json) {
    return GetMoodList(
      banner: json['banner'],
      id: json['id'],
      audio: json['audio'],
      body: json['body'],
      moodId: json['moodId'],
      status: json['status'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["banner"] = banner;
    data["id"] = id;
    data["audio"] = audio;
    data["body"] = body;
    data["moodId"] = moodId;
    data["status"] = status;
    data["titl"] = title;

    return data;
  }
}
