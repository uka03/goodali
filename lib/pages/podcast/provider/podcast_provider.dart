import 'package:flutter/material.dart';
import 'package:goodali/connection/dio_client.dart';
import 'package:goodali/connection/models/product_response.dart';
import 'package:goodali/utils/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PodcastProvider extends ChangeNotifier {
  final _dioClient = DioClient();
  List<ProductResponseData?> podcasts = List.empty(growable: true);
  List<ProductResponseData?> listen = List.empty(growable: true);

  Future<void> getPodcasts() async {
    showLoader();
    final response = await _dioClient.getPodcasts();

    podcasts = response;
    await getListen();
    dismissLoader();
    notifyListeners();
  }

  Future<void> getListen() async {
    listen = [];
    final prefs = await SharedPreferences.getInstance();
    final values = prefs.getStringList('listen_podcasts') ?? [];

    for (var i = 0; i < values.length; i++) {
      final response =
          podcasts.where((e) => e?.id.toString() == values[i]).toList();
      listen.addAll(response);
    }
    listen = listen.reversed.toList();
  }
}
