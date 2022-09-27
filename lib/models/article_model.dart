class ArticleModel {
  String? body;
  int? id;
  String? title;
  String? banner;

  ArticleModel({this.body, this.id, this.title, this.banner});

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      body: json['body'],
      id: json['id'],
      title: json['title'],
      banner: json['banner'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["body"] = body;
    data["id"] = id;
    data["title"] = title;
    data["banner"] = banner;

    return data;
  }
}
