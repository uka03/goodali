class AudioModel {
  String? banner;
  int? id;
  String? title;
  String? audio;
  String? albumName;

  AudioModel({
    this.banner,
    this.id,
    this.title,
    this.audio,
    this.albumName,
  });

  AudioModel.fromJson(Map<String, dynamic> json) {
    banner = json['banner'];

    id = json['id'];

    title = json['title'];
    audio = json['audio'];

    albumName = json['albumName'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['banner'] = banner;

    data['id'] = id;

    data['title'] = title;
    data['audio'] = audio;

    data['albumName'] = albumName;
    return data;
  }
}
