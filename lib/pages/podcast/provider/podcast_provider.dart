import 'package:flutter/material.dart';
import 'package:goodali/connection/dio_client.dart';
import 'package:goodali/connection/models/product_response.dart';
import 'package:goodali/utils/globals.dart';

class PodcastProvider extends ChangeNotifier {
  final _dioClient = DioClient();
  List<ProductResponseData?> podcasts = List.empty(growable: true);
  List<ProductResponseData?> listen = List.empty(growable: true);

  Future<void> getPodcasts() async {
    showLoader();
    final response = await _dioClient.getPodcasts();

    podcasts = response;
    dismissLoader();
    notifyListeners();
  }
}
