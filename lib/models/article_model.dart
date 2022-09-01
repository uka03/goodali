class ArticleModel {
  String? body;
  int? id;
  String? title;

  ArticleModel({this.body, this.id, this.title});

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      body: json['body'],
      id: json['id'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["body"] = body;
    data["id"] = id;
    data["title"] = title;

    return data;
  }
}
