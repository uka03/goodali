class SearchModel {
  String? title;
  String? module;
  int? id;
  String? body;
  int? album;

  SearchModel({this.body, this.id, this.module, this.title, this.album});

  SearchModel.fromJson(Map<String, dynamic> json) {
    body = json['body'];
    id = json['id'];
    title = json['title'];
    module = json['module'];
    album = json['album'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['body'] = body;
    data['module'] = module;
    data['title'] = title;
    data['id'] = id;
    data['album'] = album;
    return data;
  }
}
