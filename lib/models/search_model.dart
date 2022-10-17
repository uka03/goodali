class SearchModel {
  String? title;
  String? module;
  int? id;
  String? body;

  SearchModel({this.body, this.id, this.module, this.title});

  SearchModel.fromJson(Map<String, dynamic> json) {
    body = json['body'];
    id = json['id'];
    title = json['title'];
    module = json['module'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['body'] = body;
    data['module'] = module;
    data['title'] = title;
    data['id'] = id;
    return data;
  }
}
