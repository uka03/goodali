import 'dart:io';

import 'package:dio/dio.dart';
import 'package:goodali/connection/models/banner_response.dart';
import 'package:goodali/connection/models/base_response.dart';
import 'package:goodali/connection/models/course_response.dart';
import 'package:goodali/connection/models/edit_respone.dart';
import 'package:goodali/connection/models/faq_response.dart';
import 'package:goodali/connection/models/login_response.dart';
import 'package:goodali/connection/models/article_response.dart';
import 'package:goodali/connection/models/membership_response.dart';
import 'package:goodali/connection/models/payment_response.dart';
import 'package:goodali/connection/models/post_response.dart';
import 'package:goodali/connection/models/product_response.dart';
import 'package:goodali/connection/models/search_response.dart';
import 'package:goodali/connection/models/tag_response.dart';
import 'package:goodali/connection/models/video_response.dart';
import 'package:goodali/connection/network_interceptor.dart';

class DioClient {
  final _dioClient = Dio()..interceptors.add(NetworkInterceptor());

  // String host = 'https://dev.goodali.mn/api';
  String host = 'https://goodali.visiontech.asia/api';

  static const loginUrl = "/signin";
  static const logupUrl = "/signup";
  static const recoveryUrl = "/password_recovery";
  static const passwordChangeUrl = "/password_change";
  static const updateUrl = "/edit_user_data";
  static const uploadAvatarUrl = "/upload_user_avatar";
  static const bannerUrl = "/banner_list";
  static const productUrl = "/products";
  static const videoUrl = "/video_list";
  static const podcastsUrl = "/podcast_list";
  static const similarVideoUrl = "/similar_video";
  static const similarPostUrl = "/similar_post";
  static const lectureListUrl = "/lecture_list";
  static const postUrl = "/post_list";
  static const moodMainUrl = "/get_mood_main";
  static const moodListUrl = "/get_mood_list";
  static const moodItemUrl = "/get_mood_item";
  static const postUserUrl = "/user_post_list";
  static const likeUrl = "/insert_post_like";
  static const disLikeUrl = "/insert_post_dislike";
  static const tagUrl = "/tag_list";
  static const trainingUrl = "/get_trainings";
  static const boughtLecturesUrl = "/all_lectures";
  static const boughtAlbumsUrl = "/get_albums";
  static const orderUrl = "/order";
  static const createPostUrl = "/insert_post";
  static const faqUrl = "/faq_list";
  static const postReplyUrl = "/insert_post_reply";
  static const coursesUrl = "/training_detail_logged";
  static const itemUrl = "/items";
  static const lessonUrl = "/lessons";
  static const tasksUrl = "/tasks";
  static const setAnswerUrl = "/set_answer_api";
  static const searchUrl = "/search_text";
  static const specialListUrl = "/special_list";
  static const accountDeletionUrl = "/account_deletion";
  static const invoiceUrl = "/invoice_detail";

  Future<LoginResponse> login(
      {required String email, required String password}) async {
    try {
      final data = {
        "email": email,
        "password": password,
      };
      final response = await _dioClient.post("$host$loginUrl", data: data);
      final model = LoginResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;
      final error = LoginResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<BaseResponse> logup({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final data = {
        "email": email,
        "nickname": name,
        "password": password,
      };
      final response = await _dioClient.post("$host$logupUrl", data: data);
      final model = BaseResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;
      final error = BaseResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<BaseResponse> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final data = {
        "new_password": newPassword,
        "old_password": oldPassword,
      };
      final response =
          await _dioClient.post("$host$passwordChangeUrl", data: data);
      final model = BaseResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;
      final error = BaseResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<EditResponse> updateMe({
    required String name,
  }) async {
    try {
      final data = {
        "nickname": name,
      };
      final response = await _dioClient.post("$host$updateUrl", data: data);
      final model = EditResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;
      final error = EditResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<EditResponse> uploadAvatar({
    required File image,
  }) async {
    try {
      String imagePath = image.path.split('/').last;
      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(image.path, filename: imagePath),
      });
      final response =
          await _dioClient.post("$host$uploadAvatarUrl", data: formData);
      final model = EditResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;
      final error = EditResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<BaseResponse> recovery({
    required String email,
  }) async {
    try {
      final data = {
        "email": email,
      };
      final response = await _dioClient.post("$host$recoveryUrl", data: data);
      final model = BaseResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;
      final error = BaseResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<BannerResponse> getBanner() async {
    try {
      final response = await _dioClient.post("$host$bannerUrl");
      final model = BannerResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;
      final error = BannerResponse.fromJson(dioFailure?.response?.data);
      return BannerResponse(msg: error.msg);
    }
  }

  Future<List<ProductResponseData?>> getBoughtAlbums() async {
    try {
      final response = await _dioClient.get("$host$boughtAlbumsUrl");
      if (response.statusCode == 200) {
        List<ProductResponseData?> productList = (response.data as List)
            .map((item) => ProductResponseData.fromJson(item))
            .toList();

        return productList;
      } else {
        print("Failed to fetch products: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error fetching products: $e");
      return [];
    }
  }

  Future<List<ProductResponseData?>> getProduct(String id) async {
    try {
      final response = await _dioClient.get("$host$productUrl/$id");
      if (response.statusCode == 200) {
        List<ProductResponseData?> productList = (response.data as List)
            .map((item) => ProductResponseData.fromJson(item))
            .toList();

        return productList;
      } else {
        print("Failed to fetch products: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error fetching products: $e");
      return [];
    }
  }

  Future<List<ProductResponseData?>> getPodcasts() async {
    try {
      final response = await _dioClient.post("$host$podcastsUrl");
      if (response.statusCode == 200) {
        List<ProductResponseData?> productList = (response.data as List)
            .map((item) => ProductResponseData.fromJson(item))
            .toList();

        return productList;
      } else {
        print("Failed to fetch products: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error fetching products: $e");
      return [];
    }
  }

  Future<List<ProductResponseData?>> getLectureList(int? id) async {
    try {
      final response =
          await _dioClient.post("$host$lectureListUrl", data: {"album_id": id});
      if (response.statusCode == 200) {
        List<ProductResponseData?> productList = (response.data as List)
            .map((item) => ProductResponseData.fromJson(item))
            .toList();

        return productList;
      } else {
        print("Failed to fetch products: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error fetching products: $e");
      return [];
    }
  }

  Future<List<VideoResponseData?>> getVideo() async {
    try {
      final response = await _dioClient.post("$host$videoUrl");
      if (response.statusCode == 200) {
        List<VideoResponseData?> productList = (response.data as List)
            .map((item) => VideoResponseData.fromJson(item))
            .toList();

        return productList;
      } else {
        print("Failed to fetch products: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error fetching products: $e");
      return [];
    }
  }

  Future<VideoResponse> getVideosSimilar(String id) async {
    try {
      final response = await _dioClient
          .post("$host$similarVideoUrl", data: {"video_id": id});
      final model = VideoResponse.fromJson(response.data);

      return model;
    } catch (e) {
      print(e);
      final dioFailure = e as DioException?;
      final error = VideoResponse.fromJson(dioFailure?.response?.data);
      return VideoResponse(msg: error.msg);
    }
  }

  Future<List<ArticleResponseData?>> getArticle() async {
    try {
      final response = await _dioClient.post("$host$postUrl");
      if (response.statusCode == 200) {
        List<ArticleResponseData?> productList = (response.data as List)
            .map((item) => ArticleResponseData.fromJson(item))
            .toList();

        return productList;
      } else {
        print("Failed to fetch products: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error fetching products: $e");
      return [];
    }
  }

  Future<ArticleResponse> getPostSimilar(String id) async {
    try {
      final response =
          await _dioClient.post("$host$similarPostUrl", data: {"post_id": id});
      final model = ArticleResponse.fromJson(response.data);

      return model;
    } catch (e) {
      print(e);
      final dioFailure = e as DioException?;
      final error = ArticleResponse.fromJson(dioFailure?.response?.data);
      return ArticleResponse(msg: error.msg, data: []);
    }
  }

  Future<List<ProductResponseData?>> getMoodMain() async {
    try {
      final response = await _dioClient.post("$host$moodMainUrl");
      if (response.statusCode == 200) {
        List<ProductResponseData?> productList = (response.data as List)
            .map((item) => ProductResponseData.fromJson(item))
            .toList();

        return productList;
      } else {
        print("Failed to fetch products: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error fetching products: $e");
      return [];
    }
  }

  Future<List<ProductResponseData?>> getMoodList() async {
    try {
      final response =
          await _dioClient.post("$host$moodListUrl", data: {"mood_id": "1"});
      if (response.statusCode == 200) {
        List<ProductResponseData?> productList = (response.data as List)
            .map((item) => ProductResponseData.fromJson(item))
            .toList();

        return productList;
      } else {
        print("Failed to fetch products: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error fetching products: $e");
      return [];
    }
  }

  Future<List<ProductResponseData?>> getMoodItem(String id) async {
    try {
      final response = await _dioClient
          .post("$host$moodItemUrl", data: {"mood_list_id": id});
      if (response.statusCode == 200) {
        List<ProductResponseData?> productList = (response.data as List)
            .map((item) => ProductResponseData.fromJson(item))
            .toList();

        return productList;
      } else {
        print("Failed to fetch products: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error fetching products: $e");
      return [];
    }
  }

  Future<PostResponse> getPost({required int id}) async {
    try {
      final data = {
        "post_type": id,
      };
      final response = await _dioClient.post("$host$postUserUrl", data: data);
      if (response.data["status"] == 1) {
        final model = PostResponse.fromJson(response.data);
        return model;
      }

      return PostResponse(data: []);
    } catch (e) {
      print(e);
      final dioFailure = e as DioException?;
      final error = PostResponse.fromJson(dioFailure?.response?.data);
      return PostResponse(msg: error.msg);
    }
  }

  Future<bool> postLike({required int id}) async {
    try {
      final data = {
        "post_id": id,
      };
      final response = await _dioClient.post("$host$likeUrl", data: data);
      if (response.data["status"] == 1) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> postDislike({required int id}) async {
    try {
      final data = {
        "post_id": id,
      };
      final response = await _dioClient.post("$host$disLikeUrl", data: data);
      if (response.data["status"] == 1) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<TagResponse> getTags() async {
    try {
      final response = await _dioClient.post("$host$tagUrl");
      final model = TagResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;
      final error = TagResponse.fromJson(dioFailure?.response?.data);
      return TagResponse(msg: error.msg, data: []);
    }
  }

  Future<List<ProductResponseData?>> getTraining() async {
    try {
      final response = await _dioClient.get("$host$trainingUrl");
      if (response.statusCode == 200) {
        List<ProductResponseData?> productList = (response.data as List)
            .map((item) => ProductResponseData.fromJson(item))
            .toList();

        return productList;
      } else {
        print("Failed to fetch products: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error fetching products: $e");
      return [];
    }
  }

  Future<List<ProductResponseData?>> getBoughtLectures() async {
    try {
      final response = await _dioClient.get("$host$boughtLecturesUrl");
      if (response.statusCode == 200) {
        List<ProductResponseData?> productList = (response.data as List)
            .map((item) => ProductResponseData.fromJson(item))
            .toList();

        return productList;
      } else {
        print("Failed to fetch products: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error fetching products: $e");
      return [];
    }
  }

  Future<PaymentResponse> createOrder(
      {required int invoiceType, required List<int?> productIDs}) async {
    try {
      final data = {
        "invoice_type": invoiceType,
        "product_ids": productIDs,
      };
      final response = await _dioClient.post("$host$orderUrl", data: data);
      final model = PaymentResponse.fromJson(response.data);

      return model;
    } catch (e) {
      print(e);
      return PaymentResponse();
    }
  }

  Future<InvoiceResponse> checkOrder({required String? id}) async {
    try {
      final data = {
        "invoice_number": id,
      };
      final response = await _dioClient.get("$host$invoiceUrl", data: data);
      final model = InvoiceResponse.fromJson(response.data);

      return model;
    } catch (e) {
      print(e);
      return InvoiceResponse();
    }
  }

  Future<BaseResponse> createPost({
    required String title,
    required String body,
    required int? postType,
    required List<int?> tags,
  }) async {
    try {
      final data = {
        "title": title,
        "body": body,
        "post_type": postType,
        "tags": tags
      };
      final response = await _dioClient.post("$host$createPostUrl", data: data);
      final model = BaseResponse.fromJson(response.data);

      return model;
    } catch (e) {
      print(e);
      return BaseResponse();
    }
  }

  Future<FaqResponse?> getFaq() async {
    try {
      final response = await _dioClient.post("$host$faqUrl");
      if (response.statusCode == 200) {
        final model = FaqResponse.fromJson(response.data);
        return model;
      } else {
        print("Failed to fetch products: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching products: $e");
      return null;
    }
  }

  Future<BaseResponse?> postReply(
      {required String? body, required int? postId}) async {
    final data = {
      "body": body,
      "post_id": postId,
    };
    try {
      final response = await _dioClient.post("$host$postReplyUrl", data: data);
      final model = BaseResponse.fromJson(response.data);
      return model;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<MemberShipResponse>> getCourses({int? id}) async {
    try {
      final data = {"training_id": id};
      final response = await _dioClient.post(
        "$host$coursesUrl",
        data: data,
      );
      if (response.statusCode == 200) {
        List<MemberShipResponse> productList = (response.data as List)
            .map((item) => MemberShipResponse.fromJson(item))
            .toList();

        return productList;
      } else {
        print("Failed to fetch products: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error fetching products: $e");
      return [];
    }
  }

  Future<List<CourseItemResponse>> getCourseItems({int? id}) async {
    try {
      final response = await _dioClient.get("$host$itemUrl/$id");
      if (response.statusCode == 200) {
        List<CourseItemResponse> productList = (response.data as List)
            .map((item) => CourseItemResponse.fromJson(item))
            .toList();

        return productList;
      } else {
        print("Failed to fetch products: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error fetching products: $e");
      return [];
    }
  }

  Future<List<LessonResponse>> getCoursesLessons({int? id}) async {
    try {
      final response = await _dioClient.get("$host$lessonUrl/$id");
      if (response.statusCode == 200) {
        List<LessonResponse> productList = (response.data as List)
            .map((item) => LessonResponse.fromJson(item))
            .toList();

        return productList;
      } else {
        print("Failed to fetch products: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error fetching products: $e");
      return [];
    }
  }

  Future<List<TaskResponse>> getCoursesTasks({int? id}) async {
    try {
      final response = await _dioClient.get("$host$tasksUrl/$id");
      if (response.statusCode == 200) {
        List<TaskResponse> productList = (response.data as List)
            .map((item) => TaskResponse.fromJson(item))
            .toList();

        return productList;
      } else {
        print("Failed to fetch products: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error fetching products: $e");
      return [];
    }
  }

  Future<BaseResponse> setAnswer({int? id, required String answer}) async {
    try {
      final data = {"task_id": id, "text_field_data": answer, "is_answered": 1};
      final response = await _dioClient.post("$host$setAnswerUrl", data: data);
      final model = BaseResponse.fromJson(response.data);
      return model;
    } catch (e) {
      print(e);
      return BaseResponse();
    }
  }

  Future<SearchResponse> search({String? text}) async {
    try {
      final data = {"value": text};
      final response = await _dioClient.post("$host$searchUrl", data: data);
      if (response.data["status"] == 1) {
        final model = SearchResponse.fromJson(response.data);
        return model;
      }
      return SearchResponse(data: []);
    } catch (e) {
      print(e);
      return SearchResponse();
    }
  }

  Future<ProductResponse> getSpecialList({String? text}) async {
    try {
      final data = {"value": text};
      final response =
          await _dioClient.post("$host$specialListUrl", data: data);
      final model = ProductResponse.fromJson(response.data);
      return model;
    } catch (e) {
      print(e);
      return ProductResponse(data: []);
    }
  }

  Future<BaseResponse> deleteAccount() async {
    try {
      final response = await _dioClient.post("$host$accountDeletionUrl");
      print(response);
      final model = BaseResponse.fromJson(response.data);
      return model;
    } catch (e) {
      print(e);
      return BaseResponse();
    }
  }
}
