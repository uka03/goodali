class AudioPlayerModel {
  int? productID;
  String? title;
  String? audioUrl;
  int? audioPosition;
  String? banner;

  AudioPlayerModel(
      {this.productID,
      this.audioPosition,
      this.audioUrl,
      this.banner,
      this.title});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productID'] = productID;
    data['audioPosition'] = audioPosition ?? 0;
    data['audioUrl'] = audioUrl;
    data['banner'] = banner;
    data['title'] = title;

    return data;
  }

  factory AudioPlayerModel.fromJson(Map<String, dynamic> json) {
    return AudioPlayerModel(
      productID: json['productID'],
      audioPosition: json['audioPosition'],
      audioUrl: json['audioUrl'],
      banner: json['banner'],
      title: json['title'],
    );
  }
}
