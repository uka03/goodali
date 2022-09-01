import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:goodali/Providers/auth_provider.dart';
import 'package:goodali/Utils/constans.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Http {
  late Dio _dio;
  late BuildContext context;
  int type = headerTypeNone;

  static Http? _instance;
  factory Http() => _instance ?? Http._();

  BaseOptions options = BaseOptions(receiveTimeout: 6000, connectTimeout: 6000);
  Http._() {
    try {
      _dio = Dio(options);
      _dio.interceptors
          .add(InterceptorsWrapper(onRequest: (options, handler) async {
        print("URL ${options.path} \n DATA : ${options.data}");
        options.headers = {'Content-Type': 'application/json'};
        if (type == headerTypebearer) {
          var prefs = await SharedPreferences.getInstance();
          var token = prefs.getString('token');
          if (token != null && token.isNotEmpty) {
            print("token $token");
            options.headers = {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            };
          } else {
            // _dio.interceptors.requestLock.lock();
            // //Token refresh
            // _dio.interceptors.requestLock.unlock();
          }
        }

        return handler.next(options); //
      }, onResponse: (response, handler) async {
        var prefs = await SharedPreferences.getInstance();
        var token = prefs.getString('token');
        // Do something with response data
        print("Response is: $response");
        // continue

        if (response.statusCode == 200) {
          return handler.next(response);
        } else if (response.statusCode == 401) {
          // print("error 40111");
          // Provider.of<Auth>(context, listen: false).changeStatus(false);
        } else {
          var message = 'Алдаа гарлаа';
          if (response.data != "") {
            final body = json.decode(response.data);
            message = body["message"];
          }
          return;
        }
      }, onError: (e, handler) async {
        if (e.response?.statusCode == 401) {
          print("error 401");

          //FOR REFRESH TOKEN-> Yawaanda bolwol uncomment
          // &&
          //   e.response.requestOptions.path != '/refresh-token-endpoint' &&
          //   _refreshToken != null) {
          // // Update the access token
          // _accessToken = null;
          // final RequestOptions options = e.response.requestOptions;
          // try {
          //   final Response<String> refreshResponse = await _dio.post<String>(
          //       '/refresh-token-endpoint',
          //       data: RefreshTokenRequest(refreshToken: _refreshToken).toJson());

          //   // Retry request
          //   options.headers['Authorization'] = 'Bearer $_accessToken';
          //   final Response response = await _dio.fetch(options);

          //   return handler.resolve(response);
          // } catch (e, s) {

          // Refresh token expired
          // Redirect user to login...
          // }

        }

        return handler.next(e);
      }));
    } on DioError catch (e) {
      print(e.message + "dioError");
    }

    // onError: (DioError error, handler) => erroInterceptor(error, context)));
  }

  dynamic erroInterceptor(DioError error, BuildContext context) async {
    if (error.response?.statusCode == 401) {}
    return error;
  }

  Dio getDio(BuildContext context, int headerType) {
    this.context = context;
    type = headerType;
    return _dio;
  }
}
