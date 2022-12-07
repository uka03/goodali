import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:goodali/Providers/local_database.dart';
import 'package:goodali/Utils/constans.dart';
import 'package:goodali/controller/audioplayer_controller.dart';
import 'package:goodali/controller/default_audio_handler.dart';
import 'package:goodali/controller/download_controller.dart';
import 'package:goodali/controller/http.dart';
import 'package:goodali/Utils/urls.dart';
import 'package:goodali/Widgets/top_snack_bar.dart';
import 'package:goodali/controller/pray_button_notifier.dart';
import 'package:goodali/models/user_info.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  final LocalAuthentication localAuth = LocalAuthentication();
  final HiveBoughtDataStore _dataStore = HiveBoughtDataStore();
  bool _isAuth = false;
  bool get isAuth => _isAuth;

  bool _hasTraining = false;
  bool get hasTraining => _hasTraining;

  bool _canBiometric = false;
  bool get canBiometric => _canBiometric;

  bool? firstBiometric;

  bool _loginWithBio = false;
  bool get loginWithBio => _loginWithBio;

  bool _isFirstTime = false;
  bool get isFirstTime => _isFirstTime;

  bool _isBiometricEnabled = false;
  bool get isBiometricEnabled => _isBiometricEnabled;

  void changeStatus(bool status) {
    _isAuth = status;
    notifyListeners();
  }

  Auth() {
    print("ene ehend bnuu");
    checkIntroScreen();
    checkBiometric();
  }

  Future<void> checkIntroScreen() async {
    final prefs = await SharedPreferences.getInstance();

    _isFirstTime = prefs.getBool("isFirstTime") ?? true;
    notifyListeners();
  }

  Future<void> checkBiometric() async {
    final prefs = await SharedPreferences.getInstance();

    _loginWithBio = prefs.getBool("login_biometric") ?? false;

    notifyListeners();
  }

  Future<void> removeIntroScreen(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("isFirstTime", false);
    _isFirstTime = false;
    notifyListeners();
  }

  Future<Map<String, dynamic>> login(BuildContext context, dynamic data,
      {bool? toRemind}) async {
    final preferences = await SharedPreferences.getInstance();
    try {
      final response = await Http()
          .getDio(context, headerTypeNone)
          .post(Urls.signin, data: data);

      if (response.statusCode == 200) {
        if (response.data['token'] != null) {
          await checkUserIsChanged(data["email"], context);
          preferences.setString("email", data['email']);
          preferences.setString("password", data['password']);
          preferences.setString("token", response.data['token']);
          preferences.setBool("has_training", response.data['has_traing']);

          if (toRemind == true) {
            _saveLoginInfo(toRemind ?? false);
          } else {
            preferences.remove("toRemind");
          }

          if (buttonNotifier.value == ButtonState.playing ||
              currentlyPlaying.value != null) {
            currentlyPlaying.value = null;
            audioHandler.pause();
          }

          String mapToStr = json.encode(response.data);
          checkTraining();
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
        TopSnackBar.errorFactory(msg: "Интернет холболтоо шалгана уу.")
            .show(context);
      } else if (e.type == DioErrorType.receiveTimeout) {
        TopSnackBar.errorFactory(msg: "Сервертэй холбогдоход алдаа гарлаа.")
            .show(context);
      }
      return {};
    }
  }

  Future<void> checkUserIsChanged(String username, BuildContext context) async {
    final pref = await SharedPreferences.getInstance();
    var tasks =
        Provider.of<DownloadController>(context, listen: false).episodeTasks;
    String email = pref.getString("email") ?? "";
    print("username $username");
    print("email $email");
    if (username != email) {
      print("user changed so box is deleted");
      _dataStore.deleteBoxes();
      print(tasks.length);
      if (tasks.isNotEmpty) {
        for (var element in tasks) {
          print("element.taskId ${element.taskId} ");
          await FlutterDownloader.remove(
              taskId: element.taskId ?? "0", shouldDeleteContent: true);
          Provider.of<DownloadController>(context, listen: false)
              .episodeTasks
              .clear();
        }
      }
    } else {
      print("ijil user");
    }
  }

  Future<void> _saveLoginInfo(bool toRemind) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setBool("toRemind", toRemind);
  }

  Future<Map<String, dynamic>> getUserInfo() async {
    String nickname = "";
    final preferences = await SharedPreferences.getInstance();
    bool isRemembered = preferences.getBool("toRemind") ?? false;
    if (isRemembered == true) {
      nickname = preferences.getString("email") ?? "";
    }
    return {"to_remind": isRemembered, "email": nickname};
  }

  Future<void> logOut(BuildContext context) async {
    final preferences = await SharedPreferences.getInstance();
    if (buttonNotifier.value == ButtonState.playing ||
        currentlyPlaying.value != null) {
      currentlyPlaying.value = null;
      audioHandler.pause();
    }
    preferences.remove("token");
    preferences.remove("has_training");
    preferences.remove("user_profile");
    FlutterDownloader.cancelAll();

    _isAuth = false;
    notifyListeners();
  }

  Future<bool> checkTraining() async {
    final preferences = await SharedPreferences.getInstance();
    _hasTraining = preferences.getBool("has_training") ?? false;

    notifyListeners();
    return _hasTraining;
  }

  Future<void> canBiometrics() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      _canBiometric = await localAuth.canCheckBiometrics;
      _isBiometricEnabled = await preferences.setBool("first_biometric", true);

      notifyListeners();
    } on PlatformException catch (e) {
      _canBiometric = false;
      notifyListeners();
      print(e);
    }
  }

  Future<void> enableBiometric(BuildContext context) async {
    final preferences = await SharedPreferences.getInstance();

    _isBiometricEnabled = await preferences.setBool("first_biometric", false);

    authenticate(context);
    notifyListeners();
  }

  Future<void> noNeedBiometric() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setBool("first_biometric", false);
    _isBiometricEnabled = false;
    notifyListeners();
  }

  Future<void> authenticate(BuildContext context) async {
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
      if (_authenticated) {
        _loginWithBio = true;
        _isBiometricEnabled = false;
        prefs.setBool("login_biometric", _authenticated);
        _canBiometric = false;
      } else {}
      notifyListeners();
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> disableBiometric() async {
    print(" huruunii hee haagdlaa");
    final prefs = await SharedPreferences.getInstance();
    _loginWithBio = false;
    prefs.setBool("login_biometric", _loginWithBio);
    notifyListeners();
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
