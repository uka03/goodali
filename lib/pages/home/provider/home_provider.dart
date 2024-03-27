import 'package:flutter/foundation.dart';
import 'package:goodali/connection/dio_client.dart';
import 'package:goodali/connection/models/banner_response.dart';
import 'package:goodali/connection/models/article_response.dart';
import 'package:goodali/connection/models/product_response.dart';
import 'package:goodali/connection/models/video_response.dart';
import 'package:goodali/pages/profile/provider/profile_provider.dart';
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
  List<BoughtDatas> boughtDatas = [];

  getHomeData({
    bool refresh = false,
    required bool? isAuth,
  }) async {
    if (loading || refresh) {
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
    }
    notifyListeners();
  }

  Future<void> getBoughtLectures() async {
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

  getLectureList(ProductResponseData? data) async {
    print("object");
    albumLectures = [];
    final response = await _dioClient.getLectureList(data?.id);

    if (response.isNotEmpty == true) {
      for (var element in boughtDatas) {
        if (data?.title == element.lectureName) {
          for (var item in element.items) {
            for (var resItem in response) {
              if (item?.productId == resItem?.productId) {
                albumLectures?.add(item);
              } else {
                albumLectures?.add(resItem);
              }
            }
          }
          notifyListeners();
          return;
        }
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
    if (response.isNotEmpty == true) {
      lectures = response.map((e) {
        BoughtDatas? matchRes;
        for (var element in boughtDatas) {
          if (element.lectureName == e?.title) {
            matchRes = element;
            break;
          }
        }
        if (matchRes?.items.length == e?.audioCount) {
          e?.isBought = true;
        } else {
          e?.isBought = false;
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
      final element = boughtDatas
          .where((element) => element.lectureName == "Онлайн сургалт")
          .toList();
      if (element.isNotEmpty == true) {
        for (var item in element.first.items) {
          response = response.map((e) {
            if (item?.productId == e?.productId) {
              e?.isBought = true;
            } else {
              e?.isBought = false;
            }
            return e;
          }).toList();
        }
        lessons = response;
        if (id != null) {
          return response.where((e) => e?.id == id).toList().firstOrNull;
        }
        notifyListeners();
        return null;
      } else {
        lessons = response;
        if (id != null) {
          return response.where((e) => e?.id == id).toList().firstOrNull;
        }
        notifyListeners();
        return null;
      }
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
