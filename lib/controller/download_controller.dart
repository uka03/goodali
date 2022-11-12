import 'dart:developer';
import 'dart:io';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadController {
  String _localPath = "";

  Future<void> download(String url) async {
    await FlutterDownloader.enqueue(
        url: url,
        savedDir: _localPath,
        showNotification: true,
        openFileFromNotification: false);
  }

  //   Future<void> _retryRequestPermission() async {
  //   final hasGranted = await _checkPermission();

  //   if (hasGranted) {
  //     await _prepareSaveDir();
  //   }

  //     _permissionReady = hasGranted;

  // }

  Future<bool> checkPermission() async {
    if (Platform.isIOS) {
      return true;
    }
    final storageStatus = await Permission.storage.status;

    if (storageStatus.isGranted) {
      await _prepareSaveDir();
      return true;
    }

    if (storageStatus.isDenied) {
      print("storage permission denied");
      await Permission.storage.request();
      if (await Permission.storage.request().isGranted) {
        print("storage permission granted");
        await _prepareSaveDir();

        return true;
      } else if (storageStatus.isPermanentlyDenied) {
        openAppSettings();
        return false;
      }
    }

    return false;
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await findLocalPath())!;
    log(_localPath, name: "local path");
    final savedDir = Directory(_localPath);
    final hasExisted = savedDir.existsSync();
    if (!hasExisted) {
      await savedDir.create();
    }
  }

  Future<String?> findLocalPath() async {
    String? externalStorageDirPath;
    if (Platform.isAndroid) {
      try {
        final directory = await getExternalStorageDirectory();
        externalStorageDirPath = directory?.path;
      } catch (e) {
        print(e);
      }
    } else if (Platform.isIOS) {
      externalStorageDirPath =
          (await getApplicationDocumentsDirectory()).absolute.path;
    }
    return externalStorageDirPath;
  }
}
