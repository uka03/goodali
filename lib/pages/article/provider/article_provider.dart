import 'package:flutter/material.dart';
import 'package:goodali/connection/dio_client.dart';
import 'package:goodali/connection/models/article_response.dart';
import 'package:goodali/utils/globals.dart';

class ArticleProvider extends ChangeNotifier {
  final _dioClient = DioClient();

  List<ArticleResponseData?> articles = List.empty(growable: true);
  List<ArticleResponseData?> articleList = List.empty(growable: true);

  Future<void> getArticles({int? id}) async {
    showLoader();
    final response = await _dioClient.getArticle();
    if (response.isNotEmpty == true) {
      print(id);
      if (id != null) {
        articles = response.where((element) => element?.id == id).toList();
      } else {
        articles = response;
      }
    }
    dismissLoader();
    notifyListeners();
  }

  Future<void> getArticleList(String id) async {
    showLoader();
    final response = await _dioClient.getPostSimilar(id);
    if (response.data?.isNotEmpty == true) {
      articleList = response.data ?? [];
    }
    dismissLoader();
    notifyListeners();
  }
}
