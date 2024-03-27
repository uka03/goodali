import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:goodali/connection/dio_client.dart';
import 'package:goodali/connection/models/base_response.dart';
import 'package:goodali/connection/models/faq_response.dart';
import 'package:goodali/connection/models/login_response.dart';
import 'package:goodali/utils/globals.dart';
import 'package:goodali/utils/toasts.dart';

class AuthProvider extends ChangeNotifier {
  final _dioClient = DioClient();
  String? token;
  LoginResponse? me;

  Future<LoginResponse> login(
      {required String email, required String password}) async {
    final storage = FlutterSecureStorage();
    final response = await _dioClient.login(email: email, password: password);

    if (response.token != null) {
      token = response.token;
      me = response;
      final meString = jsonEncode(response);
      await storage.write(key: 'token', value: response.token);
      await storage.write(key: 'user', value: meString);
      await storage.write(key: 'pincode', value: password);
    }
    notifyListeners();
    return response;
  }

  Future<BaseResponse> logup(
      {required String email,
      required String password,
      required String name}) async {
    final response =
        await _dioClient.logup(email: email, password: password, name: name);

    return response;
  }

  Future<BaseResponse> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final response = await _dioClient.changePassword(
        oldPassword: oldPassword, newPassword: newPassword);

    notifyListeners();
    return response;
  }

  Future<BaseResponse> recovery({required String email}) async {
    final response = await _dioClient.recovery(email: email);

    notifyListeners();
    return response;
  }

  Future<LoginResponse> recoveryConfirm(
      {required String email, required String password}) async {
    final storage = FlutterSecureStorage();
    final response = await _dioClient.login(email: email, password: password);

    if (response.token != null) {
      storage.write(key: 'token', value: response.token);
    }
    return response;
  }

  logout() async {
    showLoader();
    final storage = FlutterSecureStorage();
    me = null;
    token = null;
    await storage.delete(key: 'user');
    await storage.delete(key: 'pincode');
    await storage.delete(key: 'token');
    dismissLoader();
    notifyListeners();
  }

  Future<void> updateUser(BuildContext context,
      {required File? image, required String name}) async {
    final storage = FlutterSecureStorage();
    if (image != null) {
      final response = await _dioClient.uploadAvatar(image: image);
      if (response.status == 1 && context.mounted) {
        Toast.success(context, description: "Зураг aмжилттай солигдлоо.");
      } else {
        if (context.mounted) {
          Toast.error(context, description: "Зураг солиход алдаа гарлаа.");
        }
      }
    }
    if (name != me?.nickname) {
      final response = await _dioClient.updateMe(name: name);
      if (response.status == 1 && context.mounted) {
        Toast.success(context, description: "Нэр aмжилттай солигдлоо.");
      } else {
        if (context.mounted) {
          Toast.error(context, description: "Нэр солиход алдаа гарлаа.");
        }
      }
    }
    final userString = await storage.read(key: 'user');
    final pincode = await storage.read(key: 'pincode');
    final response = LoginResponse.fromJson(jsonDecode(userString ?? ""));
    login(email: response.email ?? "", password: pincode ?? "");
  }

  Future<LoginResponse?> getMe() async {
    final storage = FlutterSecureStorage();
    final userString = await storage.read(key: 'user');
    final tokenRes = await storage.read(key: 'token');
    if (userString?.isNotEmpty == true) {
      final response = LoginResponse.fromJson(jsonDecode(userString!));
      if (response.token?.isNotEmpty == true) {
        me = response;
        token = tokenRes;
      }
      notifyListeners();
      return response;
    }
    return null;
  }

  Future<List<FaqResponseData?>> getFaq() async {
    final response = await _dioClient.getFaq();

    if (response?.data?.isNotEmpty == true) {
      return response?.data ?? [];
    }
    return [];
  }
}
