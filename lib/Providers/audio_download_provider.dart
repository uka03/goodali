import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:goodali/models/podcast_list_model.dart';
import 'package:goodali/models/products_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioDownloadProvider with ChangeNotifier {
  List<Products> _items = [];
  List<Products> get items => _items;

  List<Products> _podcastItem = [];
  List<Products> get podcastItem => _podcastItem;

  void _setPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedProducts =
        _items.map((res) => json.encode(res.toJson())).toList();

    prefs.setStringList("audio_items", encodedProducts);

    notifyListeners();
  }

  void _getPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> decodedProductsString =
        prefs.getStringList("audio_items") ?? [];
    List<Products> decodedProduct = decodedProductsString
        .map((res) => Products.fromJson(json.decode(res)))
        .toList();
    _items = decodedProduct;

    notifyListeners();
  }

  void addAudio(Products cartItem) {
    _items.add(cartItem);
    _setPrefItems();
    // notifyListeners();
  }

  void removeAudio(Products cartItem) {
    _items.remove(cartItem);
    _items.removeWhere((element) => element.productId == cartItem.productId);
    _setPrefItems();
    notifyListeners();
  }

  List<Products> get downloadedItem {
    _getPrefItems();
    return _items;
  }

  // Podcast download and save

  void _setPrefPodcastItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedProducts =
        _podcastItem.map((res) => json.encode(res.toJson())).toList();

    prefs.setStringList("podcast_item", encodedProducts);

    notifyListeners();
  }

  void _getPrefPodcastItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> decodedProductsString =
        prefs.getStringList("podcast_item") ?? [];
    List<Products> decodedProduct = decodedProductsString
        .map((res) => Products.fromJson(json.decode(res)))
        .toList();
    _podcastItem = decodedProduct;

    notifyListeners();
  }

  Future<void> addPodcast(Products cartItem) async {
    _podcastItem.add(cartItem);
    _setPrefPodcastItems();
    notifyListeners();
  }

  void removePodcast(Products item) {
    _podcastItem.remove(item);
    _podcastItem.removeWhere((element) => element.id == item.id);
    _setPrefPodcastItems();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  List<Products> get downloadedPodcast {
    _getPrefPodcastItems();
    return _podcastItem;
  }

  // List<String> get downloadedPodcastPath {
  //   _getPrefPodcastItems();
  //   return _podcastPath;
  // }
}
