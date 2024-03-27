import 'package:flutter/material.dart';
import 'package:goodali/connection/dio_client.dart';
import 'package:goodali/connection/models/product_response.dart';

class ProfileProvider extends ChangeNotifier {
  final _dioClient = DioClient();
  List<BoughtDatas> boughtDatas = [];

  Future<void> getLectures() async {
    boughtDatas = [];
    final response = await _dioClient.getTraining();
    if (response.isNotEmpty == true) {
      boughtDatas.add(BoughtDatas(
        lectureName: "Онлайн сургалт",
        items: response,
        isOnline: true,
      ));
    }
    final responseBought = await _dioClient.getBoughtLectures();
    if (responseBought.isNotEmpty == true) {
      final Map<String, List<ProductResponseData?>> result = {};
      for (var item in responseBought) {
        if (result[item?.albumTitle] == null) {
          result[item?.albumTitle ?? ""] = [item];
        } else {
          result[item?.albumTitle]?.add(item);
        }
      }
      for (var i = 0; i < result.keys.length; i++) {
        boughtDatas.add(BoughtDatas(
          lectureName: result.keys.toList()[i],
          items: result.values.toList()[i],
          isOnline: false,
        ));
      }
    }
    notifyListeners();
  }
}

class BoughtDatas {
  String lectureName;
  List<ProductResponseData?> items;
  bool isOnline;

  BoughtDatas({
    required this.lectureName,
    required this.items,
    this.isOnline = false,
  });
}
