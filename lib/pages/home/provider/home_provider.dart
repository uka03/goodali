import 'package:flutter/foundation.dart';
import 'package:goodali/connection/dio_client.dart';
import 'package:goodali/connection/models/banner_response.dart';
import 'package:goodali/connection/models/article_response.dart';
import 'package:goodali/connection/models/product_response.dart';
import 'package:goodali/connection/models/video_response.dart';
import 'package:goodali/utils/globals.dart';

class HomeProvider extends ChangeNotifier {
  final _dioClient = DioClient();
  bool loading = true;

  List<BannerResponseData>? banners = List.empty(growable: true);
  List<ProductResponseData?>? lectures = List.empty(growable: true);
  List<ProductResponseData?>? albumLectures = List.empty(growable: true);
  List<ProductResponseData?>? podcasts = List.empty(growable: true);
  List<ProductResponseData?>? lessons = List.empty(growable: true);
  List<VideoResponseData?>? videos = List.empty(growable: true);
  List<ArticleResponseData?>? articles = List.empty(growable: true);
  List<ProductResponseData?>? moodMain = List.empty(growable: true);
  List<ProductResponseData?>? moodList = List.empty(growable: true);
  List<ProductResponseData?> boughtDatas = [];

  getHomeData({
    bool refresh = false,
    required bool? isAuth,
  }) async {
    showLoader();
    if (isAuth == true) {
      await getBoughtLectures();
    }
    await getArticle();
    await getBanners();
    await getLesson();
    await getPodcasts();
    await getlecture();
    await getVideos();
    await getMoodMain();
    await getMoonList();
    loading = false;
    dismissLoader();
    notifyListeners();
  }

  Future<void> getBoughtLectures() async {
    boughtDatas = [];
    final response = await _dioClient.getTraining();
    if (response.isNotEmpty == true) {
      boughtDatas.addAll(response);
    }
    final responseBought = await _dioClient.getBoughtLectures();
    if (responseBought.isNotEmpty == true) {
      boughtDatas.addAll(responseBought);
    }
    notifyListeners();
  }

  getLectureList(ProductResponseData? data) async {
    albumLectures = [];
    List<ProductResponseData?> response =
        await _dioClient.getLectureList(data?.id);

    if (response.isNotEmpty == true) {
      for (var element in boughtDatas) {
        response = response.map((e) {
          if (element?.productId == e?.productId) {
            element?.isBought = true;
          }
          return e;
        }).toList();
      }
      albumLectures = response;
      notifyListeners();
      return;
    }
  }

  getBanners() async {
    final response = await _dioClient.getBanner();

    if (response.data?.isNotEmpty == true) {
      banners = response.data;
    }
  }

  Future<List<ProductResponseData?>> getlecture({int? id}) async {
    final response = await _dioClient.getProduct("0");
    final boughtResponse = await _dioClient.getBoughtAlbums();
    if (response.isNotEmpty == true) {
      lectures = response.map((e) {
        for (var element in boughtResponse) {
          if (element?.productId == e?.productId) {
            e?.isBought = true;
            break;
          }
        }
        return e;
      }).toList();
      if (id != null) {
        return lectures?.where((element) => element?.id == id).toList() ?? [];
      }
    }
    return [];
  }

  getPodcasts() async {
    final response = await _dioClient.getPodcasts();
    if (response.isNotEmpty == true) {
      podcasts = response;
    }
  }

  Future<ProductResponseData?> getLesson({int? id}) async {
    lessons = [];
    List<ProductResponseData?> response = await _dioClient.getProduct("2");
    if (response.isNotEmpty == true) {
      lessons = response;
      if (id != null) {
        return response.where((e) => e?.id == id).toList().firstOrNull;
      }
      notifyListeners();
      return null;
    }
    return null;
  }

  getVideos() async {
    final response = await _dioClient.getVideo();
    if (response.isNotEmpty == true) {
      videos = response;
    }
  }

  getArticle() async {
    final response = await _dioClient.getArticle();
    if (response.isNotEmpty == true) {
      articles = response;
    }
  }

  getMoodMain() async {
    final response = await _dioClient.getMoodMain();
    if (response.isNotEmpty == true) {
      moodMain = response;
    }
  }

  getMoonList() async {
    final response = await _dioClient.getMoodList();
    if (response.isNotEmpty == true) {
      moodList = response;
    }
  }
}