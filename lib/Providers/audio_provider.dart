import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:goodali/models/audio_player_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioPlayerProvider with ChangeNotifier {
  double _position = 0.0;
  double get position => _position;

  List<int> _productsId = [];

  List<AudioPlayerModel> _audioItems = [];
  List<AudioPlayerModel> get audioItems => _audioItems;

  void _setPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> encodedProducts =
        _audioItems.map((res) => json.encode(res.toJson())).toList();
    print(encodedProducts);
    prefs.setStringList("save_audio", encodedProducts);

    notifyListeners();
  }

  void _getPrefItems(int productID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> decodedAudioString = prefs.getStringList("save_audio") ?? [];
    List<AudioPlayerModel> decodedProduct = decodedAudioString
        .map((res) => AudioPlayerModel.fromJson(json.decode(res)))
        .toList();
    _audioItems = decodedProduct;
    int audioIndex = _audioItems.indexWhere((f) => f.productID == productID);
    _position = _audioItems[audioIndex].audioPosition;

    notifyListeners();
  }

  double getPosition(int productID) {
    _getPrefItems(productID);
    return _position;
  }

  void addAudioPosition(AudioPlayerModel audio) {
    AudioPlayerModel audioItem =
        AudioPlayerModel(productID: audio.productID, audioPosition: position);
    print("inProvider ${audio.audioPosition}");
    _audioItems.add(audioItem);
    _setPrefItems();
    notifyListeners();
  }
}
