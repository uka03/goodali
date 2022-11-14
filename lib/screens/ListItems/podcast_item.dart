import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:ffmpeg_kit_flutter/ffprobe_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:goodali/Providers/local_database.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Utils/urls.dart';
import 'package:goodali/Utils/utils.dart';
import 'package:goodali/Widgets/audio_progressbar.dart';
import 'package:goodali/Widgets/audioplayer_button.dart';
import 'package:goodali/Widgets/audioplayer_timer.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/Widgets/top_snack_bar.dart';
import 'package:goodali/controller/audioplayer_controller.dart';
import 'package:goodali/controller/default_audio_handler.dart';
import 'package:goodali/controller/download_controller.dart';
import 'package:goodali/controller/download_state.dart';
import 'package:goodali/controller/duration_state.dart';
import 'package:goodali/controller/pray_button_notifier.dart';
import 'package:goodali/models/products_model.dart';
import 'package:iconly/iconly.dart';
import 'package:just_audio/just_audio.dart';

import 'dart:developer' as developer;

class PodcastItem extends StatefulWidget {
  final Products podcastItem;
  final List<Products> podcastList;
  final VoidCallback? onTap;
  final int index;

  const PodcastItem({
    Key? key,
    required this.podcastItem,
    required this.podcastList,
    required this.index,
    this.onTap,
  }) : super(key: key);

  @override
  State<PodcastItem> createState() => _PodcastItemState();
}

class _PodcastItemState extends State<PodcastItem> {
  HiveDataStore downloadedPodcast = HiveDataStore();
  AudioPlayerController audioPlayerController = AudioPlayerController();
  DownloadController downloadController = DownloadController();
  AudioPlayer audioPlayer = AudioPlayer();
  String audioUrl = '';
  Duration duration = Duration.zero;
  bool isLoading = true;
  bool hasGranted = false;
  var _totalduration = Duration.zero;
  var progressMax = Duration.zero;
  var savedDuration = 0;
  final ReceivePort _port = ReceivePort();
  DownloadTaskStatus? downloadTaskStatus;
  int downloadProgress = 0;

  @override
  void initState() {
    if (widget.podcastItem.audio != "Audio failed to upload") {
      audioUrl = Urls.networkPath + (widget.podcastItem.audio ?? "");
    }
    log(widget.podcastItem.isDownloaded.toString(), name: "downloaded");
    if (audioUrl != '') {
      getTotalDuration();
    }

    final isSuccess = IsolateNameServer.registerPortWithName(
      _port.sendPort,
      'downloader_send_port',
    );
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) async {
      var status = data[1] as DownloadTaskStatus;
      var progress = data[2] as int;
      setState(() {
        downloadProgress = progress;
        downloadTaskStatus = status;
      });
      downloadTaskIDNotifier.value = (data as List<dynamic>)[0] as String;

      if (status == DownloadTaskStatus.undefined) {
        downloadStatusNotifier.value = DownloadState.undefined;
      } else if (status == DownloadTaskStatus.complete) {
        downloadStatusNotifier.value = DownloadState.undefined;
      } else if (status == DownloadTaskStatus.enqueued) {
        downloadStatusNotifier.value = DownloadState.enqueued;
      } else if (status == DownloadTaskStatus.running) {
        downloadStatusNotifier.value = DownloadState.running;
      } else if (status == DownloadTaskStatus.failed) {
        TopSnackBar.errorFactory(
                title: "Алдаа гарлаа", msg: "Дахин оролдоно уу")
            .show(context);
      }
      downloadProgressNotifier.value = downloadProgress;

      if (status == DownloadTaskStatus.complete) {
        print("podcast nemegdlee");
        setState(() {
          widget.podcastItem.isDownloaded = true;
        });
        await widget.podcastItem.save();
      }
    });

    FlutterDownloader.registerCallback(downloadCallback, step: 1);

    super.initState();
  }

  Future<void> updateSavedPosition() async {
    var item = currentlyPlaying.value;

    if (item != null) {
      if (item.title == widget.podcastItem.title) {
        setState(() {
          savedDuration = durationStateNotifier.value.progress!.inMilliseconds;
        });
      }
      item.position = durationStateNotifier.value.progress!.inMilliseconds;
      log('${item.position}');
      return item.save();
    }
  }

  getTotalDuration() async {
    try {
      if (widget.podcastItem.duration == null ||
          widget.podcastItem.duration == 0) {
        _totalduration = await getFileDuration(audioUrl);
      } else {
        _totalduration = Duration(milliseconds: widget.podcastItem.duration!);
      }

      if (savedDuration == 0) {
        savedDuration = widget.podcastItem.position!;
      }
      progressMax = _totalduration;

      // if (widget.podcastItem.position != null) {
      //   _totalduration = _totalduration - Duration(milliseconds: savedDuration);
      // }

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      developer.log(e.toString(), name: "totalDuration error");
    }
  }

  Future<Duration> getFileDuration(String mediaPath) async {
    final mediaInfoSession = await FFprobeKit.getMediaInformation(mediaPath);
    final mediaInfo = mediaInfoSession.getMediaInformation()!;
    final double duration = double.parse(mediaInfo.getDuration()!);
    widget.podcastItem.duration = (duration * 1000).toInt();
    await widget.podcastItem.save();
    return Duration(milliseconds: (duration * 1000).toInt());
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
    String id,
    DownloadTaskStatus status,
    int progress,
  ) {
    print(
      'Callback on background isolate: '
      'task ($id) is in status ($status) and process ($progress)',
    );

    IsolateNameServer.lookupPortByName('downloader_send_port')
        ?.send([id, status, progress]);
  }

  downloadButtonTapped() async {
    hasGranted = await downloadController.checkPermission();
    currentIndexNotifier.value = widget.index;
    if (hasGranted) {
      downloadController.download(Urls.networkPath + widget.podcastItem.audio!);
    } else {
      TopSnackBar.errorFactory(
              title: "Алдаа гарлаа",
              msg: "Grant storage permission to continue")
          .show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: ImageView(
                  height: 40,
                  width: 40,
                  imgPath: widget.podcastItem.banner ?? ""),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.podcastItem.title ?? "",
                    maxLines: 1,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: MyColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    parseHtmlString(widget.podcastItem.body ?? ""),
                    style: const TextStyle(
                        color: MyColors.gray, fontSize: 12, height: 1.5),
                  ),
                ],
              ),
            )
          ],
        ),
        const SizedBox(height: 14),
        ValueListenableBuilder(
            valueListenable: durationStateNotifier,
            builder: (context, DurationState value, child) {
              var buttonState = buttonNotifier.value;
              var currently = currentlyPlaying.value;
              bool isPlaying = currently?.title == widget.podcastItem.title &&
                      buttonState == ButtonState.playing
                  ? true
                  : false;

              return Row(
                children: [
                  AudioPlayerButton(
                    onPlay: () async {
                      await updateSavedPosition();
                      widget.onTap!.call();
                    },
                    onPause: () async {
                      await updateSavedPosition();
                      audioHandler.pause();
                    },
                    title: widget.podcastItem.title ?? "",
                  ),
                  const SizedBox(width: 10),
                  isLoading
                      ? const SizedBox(
                          width: 30,
                          child: LinearProgressIndicator(
                              backgroundColor: Colors.transparent,
                              minHeight: 2,
                              color: MyColors.black))
                      : Row(
                          children: [
                            (savedDuration > 0 || isPlaying)
                                ? AudioProgressBar(
                                    totalDuration: progressMax,
                                    title: widget.podcastItem.title ?? "",
                                    savedPostion:
                                        Duration(milliseconds: savedDuration),
                                  )
                                : Container(),
                            const SizedBox(width: 10),
                            AudioplayerTimer(
                              title: widget.podcastItem.title ?? "",
                              totalDuration: _totalduration,
                              savedDuration:
                                  Duration(milliseconds: savedDuration),
                            ),
                          ],
                        ),
                  const Spacer(),
                  ValueListenableBuilder<DownloadState>(
                      valueListenable: downloadStatusNotifier,
                      builder: (context, value, child) {
                        print(value);
                        var progress = downloadProgressNotifier.value;
                        if (value == DownloadState.undefined) {
                          return IconButton(
                            onPressed: () async {
                              downloadButtonTapped();
                            },
                            icon: const Icon(IconlyLight.arrow_down,
                                size: 20, color: MyColors.gray),
                            splashRadius: 1,
                          );
                        } else if (value == DownloadState.running &&
                            widget.index == currentIndexNotifier.value) {
                          return Text(
                            progress.toString() + "%",
                            style:
                                const TextStyle(color: MyColors.primaryColor),
                          );
                        } else if (value == DownloadState.complete ||
                            widget.podcastItem.isDownloaded == true) {
                          return IconButton(
                            onPressed: () {},
                            icon: const Icon(IconlyLight.arrow_down,
                                size: 20, color: MyColors.primaryColor),
                            splashRadius: 1,
                          );
                        } else if (value == DownloadState.enqueued) {
                          return const CircularProgressIndicator(
                              strokeWidth: 2, color: MyColors.primaryColor);
                        } else {
                          return IconButton(
                            onPressed: () async {
                              downloadButtonTapped();
                            },
                            icon: const Icon(IconlyLight.arrow_down,
                                size: 20, color: MyColors.gray),
                            splashRadius: 1,
                          );
                        }
                      }),
                  IconButton(
                      splashRadius: 20,
                      onPressed: () {},
                      icon: const Icon(Icons.more_horiz, color: MyColors.gray)),
                ],
              );
            }),
        const SizedBox(height: 12)
      ],
    );
  }
}
