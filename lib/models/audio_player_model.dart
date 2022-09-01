class AudioPlayerModel {
  int? productID;
  double audioPosition;

  AudioPlayerModel({this.productID, this.audioPosition = 0.0});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productID'] = productID;
    data['audioPosition'] = audioPosition;

    return data;
  }

  factory AudioPlayerModel.fromJson(Map<String, dynamic> json) {
    return AudioPlayerModel(
      productID: json['productID'],
      audioPosition: json['audioPosition'],
    );
  }
}
