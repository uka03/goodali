class PodcastListModel {
  String? banner;
  String? body;
  int? id;
  int? status;
  String? title;
  String? audio;

  PodcastListModel(
      {this.banner, this.body, this.id, this.status, this.title, this.audio});

  PodcastListModel.fromJson(Map<String, dynamic> json) {
    banner = json['banner'];
    body = json['body'];
    id = json['id'];
    status = json['status'];
    title = json['title'];
    audio = json['audio'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['banner'] = banner;
    data['body'] = body;
    data['id'] = id;
    data['status'] = status;
    data['title'] = title;
    data['audio'] = audio;
    return data;
  }
}
