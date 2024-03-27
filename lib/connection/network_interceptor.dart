import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NetworkInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    const storage = FlutterSecureStorage();
    try {
      final accessToken = await storage.read(key: 'token');
      if (accessToken != null) {
        // print(accessToken);
        options.headers['Authorization'] = "Bearer $accessToken";
      }
    } on PlatformException catch (_) {
      await storage.deleteAll();
    }

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );
    return super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    debugPrint(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );
    debugPrint("error message:  ${err.response?.data['message']}");

    if (err.response?.statusCode == 401) {
      return handler.reject(err);
    }
    return handler.next(err);
  }
}
