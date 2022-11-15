import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:goodali/models/products_model.dart';

class TaskInfo {
  final String? taskId;
  final Products? products;
  int? progress;
  DownloadTaskStatus? status;

  TaskInfo(this.products, this.taskId,
      {this.progress = 0, this.status = DownloadTaskStatus.undefined});

  TaskInfo copyWith(
      {String? taskId, int? progress, DownloadTaskStatus? status}) {
    return TaskInfo(products, taskId ?? this.taskId,
        progress: progress ?? this.progress, status: status ?? this.status);
  }
}
