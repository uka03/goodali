import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:goodali/models/audio_player_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioPlayerProvider with ChangeNotifier {
  int _position = 0;
  int get position => _position;

  int _duration = 0;
  int get duration => _duration;

  List<int> _productsId = [];

  List<AudioPlayerModel> _audioItems = [];
  List<AudioPlayerModel> get audioItems => _audioItems;

  void _setPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedProducts =
        _audioItems.map((res) => json.encode(res.toJson())).toList();
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

    _position =
        _audioItems.isNotEmpty ? _audioItems.last.audioPosition ?? 0 : 0;
    _duration =
        _audioItems.isNotEmpty ? _audioItems.last.audioDuration ?? 0 : 0;

    notifyListeners();
  }

  int getPosition(int productID) {
    _getPrefItems(productID);
    return _position;
  }

  int getDuration(int productID) {
    _getPrefItems(productID);
    return _duration;
  }

  void addAudioPosition(AudioPlayerModel audio) {
    AudioPlayerModel audioItem = AudioPlayerModel(
        productID: audio.productID,
        audioPosition: audio.audioPosition,
        audioDuration: audio.audioDuration);
    print("inProvider ${audio.audioPosition}");
    _audioItems.add(audioItem);
    print(_audioItems);
    _setPrefItems();
    notifyListeners();
  }
}
