import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:goodali/models/podcast_list_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PodcastProvider with ChangeNotifier {
  List<PodcastListModel> _podcastList = [];
  List<PodcastListModel> get podcastList => _podcastList;

  List<int> _podcastID = [];
  List<int> get podcastID => _podcastID;

  bool _sameItemCheck = false;
  bool get sameItemCheck => _sameItemCheck;

  void _setPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedProducts =
        _podcastList.map((res) => json.encode(res.toJson())).toList();

    prefs.setStringList("listened_podcast", encodedProducts);

    List<String> podCastIdString =
        _podcastID.map((el) => el.toString()).toList();

    prefs.setStringList("podcast_listened_id", podCastIdString);

    notifyListeners();
  }

  void _getPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> decodedProductsString =
        prefs.getStringList("listened_podcast") ?? [];
    List<PodcastListModel> decodedProduct = decodedProductsString
        .map((res) => PodcastListModel.fromJson(json.decode(res)))
        .toList();
    _podcastList = decodedProduct;

    List<String> stringId = prefs.getStringList('podcast_listened_id') ?? [];
    _podcastID = stringId.map(int.parse).toList();

    notifyListeners();
  }

  void addPodcastID(int index) {
    if (_podcastList.any((element) => element.id == index)) {
      print("podcast sonsson bga");
      _sameItemCheck = true;
      notifyListeners();
    } else {
      _sameItemCheck = false;
      _podcastID.add(index);
      _setPrefItems();
      notifyListeners();
    }
  }

  void addListenedPodcast(PodcastListModel item) {
    _podcastList.add(item);
    _setPrefItems();
    notifyListeners();
  }

  List<PodcastListModel> get listenedPodcast {
    _getPrefItems();
    return _podcastList;
  }
}
