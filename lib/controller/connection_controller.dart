import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:goodali/Utils/constans.dart';

import 'package:goodali/Utils/urls.dart';
import 'package:goodali/models/article_model.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/models/get_mood_list.dart';
import 'package:goodali/models/mood_item.dart';
import 'package:goodali/models/mood_main.dart';
import 'package:goodali/models/qpay.dart';
import 'package:goodali/controller/http.dart';

class Connection {
  static Future<Map<String, dynamic>> userRegister(
      BuildContext context, dynamic data) async {
    try {
      final response = await Http()
          .getDio(context, headerTypeNone)
          .post(Urls.signup, data: data);

      if (response.data["status"] == 1) {
        return {"success": true};
      } else {
        return {"success": false, "message": response.data['msg']};
      }
    } catch (error) {
      print("error $error");
      return {"status": false, "message": error.toString()};
    }
  }

  static Future<List<Products>> getProducts(
      BuildContext context, String id) async {
    try {
      final response = await Http()
          .getDio(context, headerTypeNone)
          .get(Urls.getProducts + id);

      if (response.data != null) {
        return (response.data as List)
            .map((e) => Products.fromJson(e))
            .toList();
      } else {
        return [];
      }
    } catch (error) {
      print("error $error");
      return [];
    }
  }

  static Future<List<Products>> getTrainingDetail(
      BuildContext context, String id) async {
    try {
      final response = await Http()
          .getDio(context, headerTypeNone)
          .post(Urls.getTrainingDetail, data: {"training_id": id});

      if (response.data != null) {
        return (response.data as List)
            .map((e) => Products.fromJson(e))
            .toList();
      } else {
        return [];
      }
    } catch (error) {
      print("error $error");
      return [];
    }
  }

  static Future<List<GetMoodList>> getMoodList(
      BuildContext context, String id) async {
    try {
      final response = await Http()
          .getDio(context, headerTypeNone)
          .post(Urls.getMoodList, data: {"mood_id": id});

      if (response.data != null) {
        return (response.data as List)
            .map((e) => GetMoodList.fromJson(e))
            .toList();
      } else {
        return [];
      }
    } catch (error) {
      print("error $error");
      return [];
    }
  }

  static Future<List<MoodMain>> getMoodMain(BuildContext context) async {
    try {
      final response =
          await Http().getDio(context, headerTypeNone).post(Urls.getMoodMain);

      if (response.data != null) {
        return (response.data as List)
            .map((e) => MoodMain.fromJson(e))
            .toList();
      } else {
        return [];
      }
    } catch (error) {
      print("error $error");
      return [];
    }
  }

  static Future<List<MoodItem>> getMoodItem(
      BuildContext context, String id) async {
    try {
      final response = await Http()
          .getDio(context, headerTypeNone)
          .post(Urls.getMoodItem, data: {"mood_list_id": id});

      if (response.data != null) {
        return (response.data as List)
            .map((e) => MoodItem.fromJson(e))
            .toList();
      } else {
        return [];
      }
    } catch (error) {
      print("error $error");
      return [];
    }
  }

  static Future<Map<String, dynamic>> createOrderRequest(
      BuildContext context, int invoiceType, List<int> productIDs) async {
    var data = {"invoice_type": invoiceType, "product_ids": productIDs};
    print("data $data");
    try {
      final response = await Http()
          .getDio(context, headerTypebearer)
          .post(Urls.orderRequest, data: data);

      if (response.statusCode == 200) {
        print("success");
        print(response.data);
        return {
          "success": true,
          "data": invoiceType == 0
              ? (response.data['urls'] as List)
                  .map((e) => QpayURLS.fromJson(e))
                  .toList()
              : response.data
        };
      } else {
        print("error");
        return {"success": false};
      }
    } catch (error) {
      print("error $error");
      return {"success": false};
    }
  }

  static Future<Map<String, dynamic>> resetPassword(
      BuildContext context, dynamic data) async {
    try {
      final response = await Http()
          .getDio(context, headerTypebearer)
          .post(Urls.passwordChange, data: data);
      print(response.data);
      if (response.statusCode == 200 && response.data['status'] == 1) {
        return {"success": true};
      } else {
        print("error");
        return {"success": false, "message": response.data["message"]};
      }
    } catch (error) {
      print("error $error");

      return {"success": false};
    }
  }

  static Future<List<ArticleModel>> getArticle(BuildContext context) async {
    try {
      final response =
          await Http().getDio(context, headerTypebearer).post(Urls.getArticle);
      print(response.data);
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((e) => ArticleModel.fromJson(e))
            .toList();
      } else {
        print("error");
        return [];
      }
    } catch (error) {
      print("error $error");

      return [];
    }
  }

  static Future<Map<String, dynamic>> editUserData(
      BuildContext context, String nickname) async {
    try {
      final response = await Http()
          .getDio(context, headerTypebearer)
          .post(Urls.editUserData, data: {"nickname": nickname});

      if (response.data['status'] == 1) {
        return {
          'succes': true,
          'name': response.data['name']['data'],
          'avatar': response.data['name']["avatar"]
        };
      } else {
        print("error");
        return {'succes': false};
      }
    } catch (error) {
      print("error $error");

      return {'succes': false};
    }
  }

  static Future<List<Products>> getAlbumLectures(
      BuildContext context, String albumId) async {
    try {
      final response = await Http()
          .getDio(context, headerTypeNone)
          .post(Urls.lectureList, data: {"album_id": albumId});

      if (response.statusCode == 200) {
        return (response.data as List)
            .map((e) => Products.fromJson(e))
            .toList();
      } else {
        print("error");
        return [];
      }
    } catch (error) {
      print("error $error");

      return [];
    }
  }

  static Future<Map<String, dynamic>> uploadUserAvatar(
      BuildContext context, File imageFile) async {
    try {
      String imagePath = imageFile.path.split('/').last;
      print("imagePath $imagePath");

      FormData data = FormData.fromMap({
        "image":
            await MultipartFile.fromFile(imageFile.path, filename: imagePath)
      });
      final response = await Http()
          .getDio(context, headerTypebearer)
          .post(Urls.uploadUserAvatar, data: data);
      print(response.data);
      if (response.data['status'] == 1) {
        return {
          'success': true,
        };
      } else {
        print("error");
        return {'success': false};
      }
    } catch (error) {
      print("error $error");

      return {'succes': false};
    }
  }
}
