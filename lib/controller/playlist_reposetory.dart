import 'package:dio/dio.dart';
import 'package:goodali/Utils/urls.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/models/products_model.dart';

abstract class PlaylistRepository {
  Future<List<Products>> fetchInitialPlaylist(List<Products> productsList);
  // Future<Map<String, String>> fetchAnotherSong();
}

class Playlist extends PlaylistRepository {
  @override
  Future<List<Products>> fetchInitialPlaylist(
      List<Products> productsList) async {
    try {
      print(productsList.length);
      return productsList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  // @override
  // Future<Map<String, String>> fetchAnotherSong() async {
  //   return _nextSong();
  // }

  // var _songIndex = 0;
  // static const _maxSongNumber = 16;

  // Map<String, String> _nextSong() {
  //   _songIndex = (_songIndex % _maxSongNumber) + 1;
  //   return {
  //     'id': _songIndex.toString().padLeft(3, '0'),
  //     'title': 'Song $_songIndex',
  //     'album': 'SoundHelix',
  //     'url':
  //         'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-$_songIndex.mp3',
  //   };
  // }
}
