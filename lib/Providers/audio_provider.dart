import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:goodali/models/audio_player_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioPlayerProvider with ChangeNotifier {
  int _position = 0;
  int get position => _position;

  List<int> _productsId = [];

  List<AudioPlayerModel> _audioItems = [];
  List<AudioPlayerModel> get audioItems => _audioItems;

  void _setPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(_audioItems.last.audioPosition);
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
    _position = _audioItems.last.audioPosition ?? 0;
    print("_position $_position");

    notifyListeners();
  }

  int getPosition(int productID) {
    _getPrefItems(productID);
    return _position;
  }
  // int getPosition(int productID) {
  // _getPrefItems(productID);
  // return _position;
  // }

  void addAudioPosition(AudioPlayerModel audio) {
    AudioPlayerModel audioItem = AudioPlayerModel(
        productID: audio.productID, audioPosition: audio.audioPosition);
    print("inProvider ${audio.audioPosition}");
    _audioItems.add(audioItem);
    _setPrefItems();
    notifyListeners();
  }
}
