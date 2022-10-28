class PostListModel {
  int? id;
  String? title;

  List<PostReplys>? replys;
  String? body;
  int? likes;
  int? postType;

  PostListModel(
      {this.title, this.id, this.body, this.likes, this.postType, this.replys});

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
    title = json['title'];
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
