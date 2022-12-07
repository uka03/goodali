import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:goodali/Providers/local_database.dart';
import 'package:goodali/Utils/urls.dart';
import 'package:goodali/controller/download_state.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/models/task_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

final downloadProgressNotifier = ValueNotifier<int>(0);
final currentIndexNotifier = ValueNotifier<int>(0);
final downloadTaskIDNotifier = ValueNotifier<String>("0");
final downloadStatusNotifier =
    ValueNotifier<DownloadState>(DownloadState.undefined);

@pragma('vm:entry-point')
void downloadCallback(String id, DownloadTaskStatus status, int progress) {
  log('Homepage callback task in $id  status ($status) $progress');
  final send = IsolateNameServer.lookupPortByName('downloader_send_port')!;
  send.send([id, status, progress]);
}

class DownloadController with ChangeNotifier {
  final HiveBoughtDataStore _dataStore = HiveBoughtDataStore();

  String _localPath = "";
  List<TaskInfo> _episodeTasks = [];
  List<TaskInfo> get episodeTasks => _episodeTasks;

  DownloadController() {
    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback);
  }

  void _bindBackgroundIsolate() {
    final _port = ReceivePort();
    final isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }

    _port.listen((dynamic data) {
      String? id = data[0];
      DownloadTaskStatus? status = data[1];
      int? progress = data[2];

      try {
        for (var episodeTask in _episodeTasks) {
          if (episodeTask.taskId == id) {
            episodeTask.status = status;
            episodeTask.progress = progress;
            if (status == DownloadTaskStatus.complete) {
              _saveMediaId(episodeTask).then((value) {
                notifyListeners();
              });
            } else {
              notifyListeners();
            }
          }
        }
      } catch (e) {
        print(e);
      }
    });
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  Future _saveMediaId(TaskInfo episodeTask) async {
    episodeTask.status = DownloadTaskStatus.complete;

    final episodePodcast = await _dataStore.getProductsFromUrl(
        url: Urls.networkPath + episodeTask.products!.audio!);
    episodePodcast!.isDownloaded = true;
    episodePodcast.downloadedPath = _localPath;
    await episodePodcast.save();
    log(episodePodcast.isDownloaded.toString(), name: "podcast downloaded");
    _episodeTasks.add(TaskInfo(episodePodcast, episodeTask.taskId,
        progress: 100, status: DownloadTaskStatus.complete));
    notifyListeners();
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  TaskInfo episodeToTask(Products? products) {
    return _episodeTasks.firstWhere((task) {
      return task.products!.title == products!.title;
    }, orElse: () {
      return TaskInfo(
        products,
        '',
      );
    });
  }

  Future<void> _loadTasks() async {
    print("_loadTasks");
    _episodeTasks = [];
    var dbHelper = HiveBoughtDataStore();
    var tasks = await FlutterDownloader.loadTasks();

    print("task length ${tasks?.length}");
    if (tasks != null && tasks.isNotEmpty) {
      for (var task in tasks) {
        var episode = await dbHelper.getProductsFromUrl(url: task.url);
        if (episode == null) {
          await FlutterDownloader.remove(
              taskId: task.taskId, shouldDeleteContent: true);
        } else {
          if (task.status == DownloadTaskStatus.complete) {
            var exist =
                await File(path.join(task.savedDir, task.filename)).exists();

            if (!exist) {
              await FlutterDownloader.remove(
                  taskId: task.taskId, shouldDeleteContent: true);
            } else {
              _episodeTasks.add(TaskInfo(episode, task.taskId,
                  progress: task.progress, status: task.status));
            }
          } else {
            _episodeTasks.add(TaskInfo(episode, task.taskId,
                progress: task.progress, status: task.status));
          }
        }
        // if (task.status == DownloadTaskStatus.complete) {
        //   _episodeTasks.add(TaskInfo(episode, task.taskId,
        //       progress: task.progress, status: task.status));
        // } else {
        //   _episodeTasks.add(TaskInfo(episode, task.taskId,
        //       progress: task.progress, status: task.status));
        // }
      }
      print("_episodeTasks.length ${_episodeTasks.length}");
    }
    notifyListeners();
  }

  @override
  void addListener(VoidCallback listener) async {
    _loadTasks();
    super.addListener(listener);
  }

  Future<void> download(Products products) async {
    log(products.title!, name: "download podcast name ");
    var isDownloaded = await _dataStore.isDownloaded(title: products.title!);
    if (!isDownloaded) {
      var localPath = await _prepareSaveDir();
      var taskId = await FlutterDownloader.enqueue(
          url: Urls.networkPath + products.audio!,
          savedDir: localPath,
          fileName: products.title,
          showNotification: true,
          openFileFromNotification: false);

      _episodeTasks.add(TaskInfo(products, taskId));

      notifyListeners();
    }
  }

  Future<String> _prepareSaveDir() async {
    _localPath = (await findLocalPath())!;
    log(_localPath, name: "local path");
    final savedDir = Directory(_localPath);
    final hasExisted = savedDir.existsSync();
    if (!hasExisted) {
      await savedDir.create();
    }
    return _localPath;
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
