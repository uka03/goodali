import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:goodali/models/podcast_list_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PodcastProvider with ChangeNotifier {
  List<PodcastListModel> _listenedPodcastList = [];
  List<PodcastListModel> get listenedPodcastList => _listenedPodcastList;

  List<PodcastListModel> _unListenedPodcastList = [];
  List<PodcastListModel> get unListenedPodcastList => _unListenedPodcastList;

  List<int> _podcastID = [];
  List<int> get podcastID => _podcastID;

  bool _sameItemCheck = false;
  bool get sameItemCheck => _sameItemCheck;

  void _setPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> encodedProducts =
        _listenedPodcastList.map((res) => json.encode(res.toJson())).toList();
    prefs.setStringList("listened_podcast", encodedProducts);

    List<String> podCastIdString =
        _podcastID.map((el) => el.toString()).toList();
    prefs.setStringList("podcast_listened_id", podCastIdString);

    List<String> encodedPodcast =
        _unListenedPodcastList.map((res) => json.encode(res.toJson())).toList();
    prefs.setStringList("unlistened_podcast", encodedPodcast);

    notifyListeners();
  }

  void _getPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> decodedProductsString =
        prefs.getStringList("listened_podcast") ?? [];
    List<PodcastListModel> decodedProduct = decodedProductsString
        .map((res) => PodcastListModel.fromJson(json.decode(res)))
        .toList();
    _listenedPodcastList = decodedProduct;

    List<String> stringId = prefs.getStringList('podcast_listened_id') ?? [];
    _podcastID = stringId.map(int.parse).toList();

    List<String> unListenedPodcast =
        prefs.getStringList("unlistened_podcast") ?? [];
    List<PodcastListModel> unListened = unListenedPodcast
        .map((res) => PodcastListModel.fromJson(json.decode(res)))
        .toList();
    _unListenedPodcastList = unListened;

    notifyListeners();
  }

  void addPodcastID(int index) {
    if (_listenedPodcastList.any((element) => element.id == index)) {
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

  void addListenedPodcast(
      PodcastListModel item, List<PodcastListModel> podcastList) {
    _listenedPodcastList.add(item);
    for (var podcast in podcastList) {
      if (podcast.id == item.id) {
        print("what the heekkk");
      } else {
        _unListenedPodcastList.add(podcast);
      }
    }
    _setPrefItems();
    notifyListeners();
  }

  List<PodcastListModel> get listenedPodcast {
    _getPrefItems();
    return _listenedPodcastList;
  }

  List<PodcastListModel> get unListenedPodcast {
    _getPrefItems();
    return _unListenedPodcastList;
  }
}
