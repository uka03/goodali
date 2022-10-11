import 'package:audio_service/audio_service.dart';
import 'package:goodali/Utils/urls.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/main.dart';
import 'package:goodali/models/products_model.dart';
import 'package:http/http.dart' as http;

class PodcastRepository {
  Future<List<Products>> getPodcastList() async {
    var url = Uri.parse(Urls.podcastList);
    var response =
        await http.post(url, headers: {'Content-Type': 'application/json'});

    return (response.body as List).map((e) => Products.fromJson(e)).toList();
  }

  void init() async {
    await _loadPodcast();
  }

  _loadPodcast() async {
    final podcastList = await getPodcastList();
  }
}
