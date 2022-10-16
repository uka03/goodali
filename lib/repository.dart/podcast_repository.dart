import 'dart:convert';
import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:goodali/Utils/urls.dart';

import 'package:goodali/models/products_model.dart';
import 'package:http/http.dart' as http;

class PodcastRepository {
  static Future<List<MediaItem>> getPodcastList() async {
    var url = Uri.parse(Urls.podcastList);
    var response =
        await http.post(url, headers: {'Content-Type': 'application/json'});

    List<Products> podcastList = (jsonDecode(response.body) as List)
        .map((e) => Products.fromJson(e))
        .toList();

    return podcastList.map((e) => e.toMediaItem()).toList();
  }
}
