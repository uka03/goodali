class VideoModel {
  String? banner;
  String? body;
  int? id;
  int? status;
  String? title;
  String? videoUrl;

  VideoModel(
      {this.banner,
      this.body,
      this.id,
      this.status,
      this.title,
      this.videoUrl});

  VideoModel.fromJson(Map<String, dynamic> json) {
    banner = json['banner'];
    body = json['body'];
    id = json['id'];
    status = json['status'];
    title = json['title'];
    videoUrl = json['video_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['banner'] = banner;
    data['id'] = id;
    data['status'] = status;
    data['title'] = title;
    data['video_url'] = videoUrl;
    return data;
  }
}
