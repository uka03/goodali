class ArticleModel {
  String? banner;
  String? body;
  String? createdAt;
  int? id;
  List<Tags>? tags;
  String? title;

  ArticleModel(
      {this.banner, this.body, this.createdAt, this.id, this.tags, this.title});

  ArticleModel.fromJson(Map<String, dynamic> json) {
    banner = json['banner'];
    body = json['body'];
    createdAt = json['created_at'];
    id = json['id'];
    if (json['tags'] != null) {
      tags = <Tags>[];
      json['tags'].forEach((v) {
        tags!.add(Tags.fromJson(v));
      });
    }
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['banner'] = banner;
    data['body'] = body;
    data['created_at'] = createdAt;
    data['id'] = id;
    if (tags != null) {
      data['tags'] = tags!.map((v) => v.toJson()).toList();
    }
    data['title'] = title;
    return data;
  }
}

class Tags {
  String? banner;
  String? description;
  int? id;
  String? name;

  Tags({this.banner, this.description, this.id, this.name});

  Tags.fromJson(Map<String, dynamic> json) {
    banner = json['banner'];
    description = json['description'];
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['banner'] = banner;
    data['description'] = description;
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
