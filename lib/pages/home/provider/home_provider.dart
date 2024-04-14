import 'package:flutter/foundation.dart';
import 'package:goodali/connection/dio_client.dart';
import 'package:goodali/connection/models/banner_response.dart';
import 'package:goodali/connection/models/article_response.dart';
import 'package:goodali/connection/models/product_response.dart';
import 'package:goodali/connection/models/video_response.dart';

class HomeProvider extends ChangeNotifier {
  final _dioClient = DioClient();

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
  List<ProductResponseData?> specialList = [];

  getHomeData({
    required bool? isAuth,
  }) async {
    if (isAuth == true) {
      getBoughtLectures();
    }
    getArticle();
    getSpecialList();
    getBanners();
    getLesson();
    getPodcasts();
    getlecture();
    getVideos();
    getMoodMain();
    getMoonList();
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
    notifyListeners();
    List<ProductResponseData?> response = await _dioClient.getLectureList(data?.id);
    await getBoughtLectures();
    if (response.isNotEmpty == true) {
      for (var element in boughtDatas) {
        response = response.map((e) {
          if (element?.productId == e?.productId) {
            e?.isBought = true;
            print("asdad");
          } else {
            e?.isBought = false;
          }
          e?.albumId = data?.productId;

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
    notifyListeners();
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
    notifyListeners();
    return [];
  }

  getPodcasts() async {
    final response = await _dioClient.getPodcasts();
    if (response.isNotEmpty == true) {
      podcasts = response;
    }
    notifyListeners();
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

    notifyListeners();
  }

  getArticle() async {
    final response = await _dioClient.getArticle();
    if (response.isNotEmpty == true) {
      articles = response;
    }
    notifyListeners();
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
    notifyListeners();
  }

  getSpecialList() async {
    final response = await _dioClient.getSpecialList();
    if (response.data?.isNotEmpty == true) {
      specialList = response.data ?? [];
    }
    notifyListeners();
  }
}
