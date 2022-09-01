class MoodMain {
  String? banner;
  String? body;
  int? id;
  String? title;

  MoodMain({this.banner, this.body, this.id, this.title});

  factory MoodMain.fromJson(Map<String, dynamic> json) {
    return MoodMain(
      banner: json['banner'],
      body: json['body'],
      id: json['id'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["banner"] = banner;
    data["body"] = body;
    data["id"] = id;
    data["title"] = title;

    return data;
  }
}
