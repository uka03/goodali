import 'package:flutter/material.dart';
import 'package:goodali/connection/dio_client.dart';
import 'package:goodali/connection/models/product_response.dart';

class FeelProvider extends ChangeNotifier {
  final _dioClient = DioClient();
  List<ProductResponseData?> feelDetails = [];

  getFeelDetail(int? id) async {
    final response = await _dioClient.getMoodItem(id?.toString() ?? "");

    if (response.isNotEmpty == true) {
      feelDetails = response;
    }
    notifyListeners();
  }
}
