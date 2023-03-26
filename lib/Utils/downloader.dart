import 'package:flutter_downloader/flutter_downloader.dart';

class Downloader {
  Future<void> initialize() async {
    await FlutterDownloader.initialize();
  }

  static void cancelAll() {
    FlutterDownloader.cancelAll();
  }

  static Future<void> remove({String? taskId, bool? shouldDeleteContent}) async {
    await FlutterDownloader.remove(taskId: taskId ?? "0", shouldDeleteContent: shouldDeleteContent ?? false);
  }
}
