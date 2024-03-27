import 'package:flutter/material.dart';
import 'package:goodali/connection/dio_client.dart';
import 'package:goodali/connection/models/video_response.dart';
import 'package:goodali/utils/globals.dart';

class VideoProvider extends ChangeNotifier {
  final _dioclient = DioClient();

  List<VideoResponseData?> videos = List.empty(growable: true);
  List<VideoResponseData?>? similarVideos = List.empty(growable: true);

  Future<void> getVideos() async {
    final response = await _dioclient.getVideo();
    if (response.isNotEmpty == true) {
      videos = response;
    }
    notifyListeners();
  }

  Future<void> getVideosSimilar(String id) async {
    showLoader();
    final response = await _dioclient.getVideosSimilar(id);
    if (response.data?.isNotEmpty == true) {
      similarVideos = response.data;
    }
    dismissLoader();
    notifyListeners();
  }
}
