import 'dart:io';

import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/top_snack_bar.dart';
import 'package:goodali/controller/download_controller.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/models/task_info.dart';
import 'package:iconly/iconly.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class DownloadButton extends StatefulWidget {
  final Products products;
  const DownloadButton({Key? key, required this.products}) : super(key: key);

  @override
  State<DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  Future<void> _requestDownload(Products? episode) async {
    final hasGranted = await _checkPermission();
    print(hasGranted.toString());

    if (hasGranted) {
      Provider.of<DownloadController>(context, listen: false)
          .download(episode!);
    } else {
      TopSnackBar.errorFactory(
              title: "Алдаа гарлаа",
              msg: "Grant storage permission to continue")
          .show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DownloadController>(
      builder: (context, value, child) {
        var _task = Provider.of<DownloadController>(context, listen: false)
            .episodeToTask(widget.products);
        return _downloadButton(_task, context);
      },
    );
  }

  Widget _downloadButton(TaskInfo task, BuildContext context) {
    switch (task.status!.value) {
      case 0:
        return IconButton(
          onPressed: () => _requestDownload(widget.products),
          icon: const Icon(IconlyLight.arrow_down,
              size: 20, color: MyColors.gray),
          splashRadius: 1,
        );
      case 2:
        return Text(
          task.progress.toString() + "%",
          style: const TextStyle(color: MyColors.primaryColor),
        );
      case 3:
        return IconButton(
          onPressed: () {},
          icon: const Icon(IconlyLight.arrow_down,
              size: 20, color: MyColors.primaryColor),
          splashRadius: 1,
        );

      default:
        return Center();
    }
  }

  Future<bool> _checkPermission() async {
    final storageStatus = await Permission.storage.status;

    if (storageStatus != PermissionStatus.granted) {
      var permissions = await [Permission.storage].request();
      if (permissions[Permission.storage] == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }
}
