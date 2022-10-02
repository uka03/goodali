class PodcastListModel {
  String? banner;
  String? body;
  int? id;
  int? status;
  String? title;
  String? audio;
  int? duration;
  int? position;
  String? albumName;

  PodcastListModel(
      {this.banner,
      this.body,
      this.id,
      this.status,
      this.title,
      this.audio,
      this.albumName,
      this.duration,
      this.position});

  PodcastListModel.fromJson(Map<String, dynamic> json) {
    banner = json['banner'];
    body = json['body'];
    id = json['id'];
    status = json['status'];
    title = json['title'];
    audio = json['audio'];
    duration = json['duration'] ?? 0;
    position = json['position'] ?? 0;
    albumName = json['albumName'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['banner'] = banner;
    data['body'] = body;
    data['id'] = id;
    data['status'] = status;
    data['title'] = title;
    data['audio'] = audio;
    data['duration'] = duration;
    data['position'] = position;
    data['albumName'] = albumName;
    return data;
  }
}
