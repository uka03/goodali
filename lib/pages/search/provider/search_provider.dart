import 'package:flutter/material.dart';
import 'package:goodali/connection/dio_client.dart';
import 'package:goodali/connection/models/search_response.dart';

class SearchProvider extends ChangeNotifier {
  final _dioClient = DioClient();
  List<SearchResponseData?> items = List.empty(growable: true);
  bool loading = false;

  Future<void> searchItem(String? text) async {
    loading = true;
    notifyListeners();
    items = [];
    final response = await _dioClient.search(text: text);
    if (response.data?.isNotEmpty == true) {
      items = response.data!;
    }
    loading = false;
    notifyListeners();
  }
}
