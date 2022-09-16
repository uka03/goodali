import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:goodali/models/products_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioDownloadProvider with ChangeNotifier {
  List<Products> _items = [];
  List<Products> get items => _items;

  List<String> _audioPath = [];
  List<String> get audioPath => _audioPath;

  void _setPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedProducts =
        _items.map((res) => json.encode(res.toJson())).toList();
    prefs.setStringList("audio_path", _audioPath);

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

    _audioPath = prefs.getStringList("audio_path") ?? [];

    notifyListeners();
  }

  void addAudio(Products cartItem, String audioPath) {
    _audioPath.add(audioPath);
    _items.add(cartItem);
    _setPrefItems();
    notifyListeners();
  }

  void removeAudio(Products cartItem, String audioPath) {
    _audioPath.remove(audioPath);
    _items.remove(cartItem);
    _items.removeWhere((element) => element.productId == cartItem.productId);
    _setPrefItems();
    notifyListeners();
  }

  List<Products> get downloadedItem {
    _getPrefItems();
    return _items;
  }

  List<String> get downloadedPath {
    _getPrefItems();
    return _audioPath;
  }
}
