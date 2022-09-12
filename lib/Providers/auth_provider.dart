import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goodali/Utils/constans.dart';
import 'package:goodali/controller/http.dart';
import 'package:goodali/Utils/urls.dart';
import 'package:goodali/Utils/utils.dart';
import 'package:goodali/Widgets/top_snack_bar.dart';
import 'package:goodali/models/user_info.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class Auth with ChangeNotifier {
  final LocalAuthentication localAuth = LocalAuthentication();
  bool _isAuth = false;
  bool get isAuth => _isAuth;

  bool _canBiometric = false;
  bool get canBiometric => _canBiometric;

  bool? firstBiometric;

  bool _isBiometric = false;
  bool get isBiometric => _isBiometric;

  void changeStatus(bool status) {
    print("change status");
    _isAuth = status;
    notifyListeners();
  }

  Auth() {
    print("ene ehend bnuu");
  }

  Future<void> removeIntroScreen(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("isFirstTime", true);
    notifyListeners();
  }

  Future<Map<String, dynamic>> login(BuildContext context, dynamic data) async {
    final preferences = await SharedPreferences.getInstance();

    print(data);
    try {
      final response = await Http()
          .getDio(context, headerTypeNone)
          .post(Urls.signin, data: data);

      if (response.statusCode == 200) {
        if (response.data['token'] != null) {
          preferences.setString("email", data['email']);
          preferences.setString("password", data['password']);
          preferences.setString("token", response.data['token']);

          String mapToStr = json.encode(response.data);

          var strToMap = json.decode(mapToStr);

          UserInfo userInfo = UserInfo.fromJson(response.data);
          preferences.setString("userData", json.encode(strToMap));

          _isAuth = true;
          notifyListeners();
          return {'success': true, "userInfo": userInfo};
        } else {
          return {'success': false, "message": response.data['message']};
        }
      } else {
        _isAuth = false;

        notifyListeners();
        return {'success': false, "message": response.data['message']};
      }
    } on DioError catch (e) {
      print(e.type);
      if (e.type == DioErrorType.other) {
        showTopSnackBar(
            context,
            const CustomTopSnackBar(
                type: 0, text: "Интернет холболтоо шалгана уу."));
      } else if (e.type == DioErrorType.receiveTimeout) {
        showTopSnackBar(
            context,
            const CustomTopSnackBar(
                type: 0, text: "Сервертэй холбогдоход алдаа гарлаа"));
      }
      return {};
    }
  }

  Future<void> logOut(BuildContext context) async {
    _isAuth = false;
    notifyListeners();
  }

  Future<void> canBiometrics() async {
    final preferences = await SharedPreferences.getInstance();
    try {
      _canBiometric = await localAuth.canCheckBiometrics;
      preferences.setBool("first_biometric", true);
      notifyListeners();
    } on PlatformException catch (e) {
      _canBiometric = false;
      notifyListeners();
      print(e);
    }
  }

  Future<void> enableBiometric() async {
    _isBiometric = true;
    authenticate();
    notifyListeners();
  }

  Future<void> noNeedBiometric() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setBool("first_biometric", false);
    notifyListeners();
  }

  Future<void> authenticate() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      bool _authenticated = await localAuth.authenticate(
        localizedReason:
            'Scan your fingerprint (or face or whatever) to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      prefs.setBool("login_biometric", _authenticated);
      if (_authenticated) {
        _canBiometric = false;
        notifyListeners();
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> disableBiometric() async {
    print(" huruunii hee haagdlaa");
    final prefs = await SharedPreferences.getInstance();
    _isBiometric = false;
    prefs.setBool("login_biometric", _isBiometric);
    notifyListeners();
  }

  Future<void> getCheckBiometric() async {
    final prefs = await SharedPreferences.getInstance();
    _isBiometric = prefs.getBool("login_biometric") ?? false;
  }

  bool checkBiometric() {
    getCheckBiometric();
    return _isBiometric;
  }

  Future<void> authenticateWithBiometrics(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      bool _authenticated = await localAuth.authenticate(
        localizedReason:
            'Scan your fingerprint (or face or whatever) to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      String email = prefs.getString("email") ?? "";
      String password = prefs.getString("password") ?? "";
      if (email != "" && password != "") {
        Map<String, String> data = {"email": email, "password": password};
        if (_authenticated) {
          login(context, data);
        } else {
          print("");
        }
      }
      notifyListeners();
    } on PlatformException catch (e) {
      print(e);
      return;
    }
  }
}
