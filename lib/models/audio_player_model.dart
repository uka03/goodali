import 'package:audio_service/audio_service.dart';

class AudioPlayerModel {
  int? productID;
  int? audioPosition;

  AudioPlayerModel({this.productID, this.audioPosition});

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
