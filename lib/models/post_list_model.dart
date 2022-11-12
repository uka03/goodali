import 'package:goodali/models/article_model.dart';

class PostListModel {
  int? id;
  String? title;
  List<PostReplys>? replys;
  String? body;
  int? likes;
  int? postType;
  List<Tags>? tags;
  String? createdAt;
  String? nickName;
  bool? selfLike;

  PostListModel(
      {this.title,
      this.id,
      this.body,
      this.likes,
      this.postType,
      this.replys,
      this.tags,
      this.createdAt,
      this.nickName,
      this.selfLike});

  PostListModel.fromJson(Map<String, dynamic> json) {
    body = json['body'];
    id = json['id'];
    likes = json['likes'];
    postType = json['post_type'];
    if (json['replys'] != null && json['replys'] != "") {
      replys = <PostReplys>[];
      json['replys'].forEach((v) {
        replys!.add(PostReplys.fromJson(v));
      });
    } else {
      json['replys'] = [];
    }
    if (json['tags'] != null && json['tags'] != "") {
      tags = <Tags>[];
      json['tags'].forEach((v) {
        tags!.add(Tags.fromJson(v));
      });
    }
    title = json['title'];
    createdAt = json['created_at'];
    nickName = json['nick_name'];
    selfLike = json['self_like'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["id"] = id;
    data["title"] = title;
    data["body"] = body;
    data["likes"] = likes;
    data["post_type"] = postType;
    if (replys != null) {
      data['replys'] = replys!.map((v) => v.toJson()).toList();
    }
    if (tags != null) {
      data['tags'] = tags!.map((v) => v.toJson()).toList();
    }
    data["created_at"] = createdAt;
    data["nick_name"] = nickName;
    data["self_like"] = selfLike;

    return data;
  }
}

class PostReplys {
  String? nickName;
  String? text;

  PostReplys({
    this.nickName,
    this.text,
  });

  PostReplys.fromJson(Map<String, dynamic> json) {
    nickName = json['nick_name'] ?? "";
    text = json['text'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nick_name'] = nickName;
    data['text'] = text;

    return data;
  }
}
