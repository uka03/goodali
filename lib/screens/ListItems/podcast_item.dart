import 'package:audio_service/audio_service.dart';
import 'package:ffmpeg_kit_flutter/ffprobe_kit.dart';
import 'package:flutter/material.dart';
import 'package:goodali/Providers/podcast_provider.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Utils/urls.dart';
import 'package:goodali/Widgets/audio_progressbar.dart';
import 'package:goodali/Widgets/audioplayer_button.dart';
import 'package:goodali/Widgets/audioplayer_timer.dart';
import 'package:goodali/Widgets/custom_readmore_text.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/controller/audioplayer_controller.dart';
import 'package:goodali/controller/default_audio_handler.dart';
import 'package:goodali/controller/duration_state.dart';
import 'package:goodali/models/products_model.dart';
import 'package:iconly/iconly.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import 'dart:developer' as developer;

import 'package:rxdart/rxdart.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

typedef OnTap = Function(Products audioObject);

class PodcastItem extends StatefulWidget {
  final Products podcastItem;
  final List<Products> podcastList;
  final OnTap onTap;
  final int index;

  const PodcastItem({
    Key? key,
    required this.podcastItem,
    required this.podcastList,
    required this.index,
    required this.onTap,
  }) : super(key: key);

  @override
  State<PodcastItem> createState() => _PodcastItemState();
}

class _PodcastItemState extends State<PodcastItem> {
  AudioPlayerController audioPlayerController = AudioPlayerController();
  AudioPlayer audioPlayer = AudioPlayer();
  Stream<DurationState>? _durationState;
  String audioUrl = '';
  Duration duration = Duration.zero;
  int savedDuration = 0;
  bool isLoading = true;
  bool isClicked = false;
  var _totalduration = Duration.zero;
  @override
  void initState() {
    if (widget.podcastItem.audio != "Audio failed to upload") {
      audioUrl = Urls.networkPath + (widget.podcastItem.audio ?? "");
    }

    if (audioUrl != '') {
      getTotalDuration();
    }
    super.initState();
  }

  Stream<Duration> get _bufferedPositionStream => audioHandler.playbackState
      .map((state) => state.bufferedPosition)
      .distinct();

  // _initiliazePodcast(Duration duration, int savedDuration) async {
  //   audioPlayerController.initiliaze();

  //   setState(() {
  //     _durationState =
  //         Rx.combineLatest3<MediaItem?, Duration, Duration, DurationState>(
  //             audioHandler.mediaItem,
  //             AudioService.position,
  //             _bufferedPositionStream,
  //             (mediaItem, position, buffered) =>
  //                 DurationState(position, buffered, mediaItem?.duration));
  //   });

  //   mediaItem = MediaItem(
  //       id: widget.podcastItem.id.toString(),
  //       title: widget.podcastItem.title ?? "",
  //       duration: duration,
  //       artUri: Uri.parse(Urls.networkPath + widget.podcastItem.banner!),
  //       extras: {"saved_position": savedDuration, 'url': audioUrl});
  // }

  Future<Duration> getTotalDuration() async {
    try {
      if (_totalduration == Duration.zero) {
        _totalduration = await getFileDuration(audioUrl);
      }
      if (mounted) {
        setState(() {
          duration = _totalduration;
          isLoading = false;
        });
      }
      savedDuration = await audioPlayerController.getSavedPosition(
          audioPlayerController.toAudioModel(widget.podcastItem));
      duration = duration - Duration(milliseconds: savedDuration);
      return duration;
    } catch (e) {
      developer.log(e.toString(), name: "totalDuration error");
      return Duration.zero;
    }
  }

  Future<Duration> getFileDuration(String mediaPath) async {
    final mediaInfoSession = await FFprobeKit.getMediaInformation(mediaPath);
    final mediaInfo = mediaInfoSession.getMediaInformation()!;
    final double duration = double.parse(mediaInfo.getDuration()!);
    print(duration);
    return Duration(milliseconds: (duration * 1000).toInt());
  }

  @override
  Widget build(BuildContext context) {
    final podcastProvider = Provider.of<PodcastProvider>(context);
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
                  const SizedBox(height: 10),
                  CustomReadMoreText(
                    text: widget.podcastItem.body ?? "",
                  ),
                ],
              ),
            )
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            AudioPlayerButton(
              onPlay: () async {
                if (isClicked == true) return;
                await audioHandler.skipToQueueItem(widget.index);
                await audioHandler.play();

                if (mounted) {
                  setState(() {
                    isClicked = true;
                  });
                }

                podcastProvider.addPodcastID(widget.podcastItem.id ?? 0);
                if (!podcastProvider.sameItemCheck) {
                  podcastProvider.addListenedPodcast(
                      widget.podcastItem, widget.podcastList);
                }
                widget.onTap(widget.podcastItem);
              },
              onPause: () {
                widget.onTap(widget.podcastItem);
                audioHandler.pause().then((value) =>
                    podcastProvider.unListenedPodcastFun(
                        widget.podcastItem, widget.podcastList));
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
                      (savedDuration > 0 || isClicked)
                          ? StreamBuilder<DurationState>(
                              stream: _durationState,
                              builder: (context, snapshot) {
                                final durationState = snapshot.data;
                                final position =
                                    durationState?.progress ?? Duration.zero;

                                duration = durationState?.total ?? duration;
                                return SizedBox(
                                    width: 90,
                                    child: SfLinearGauge(
                                      minimum: 0,
                                      maximum:
                                          (duration.inSeconds.toDouble() / 10),
                                      showLabels: false,
                                      showAxisTrack: false,
                                      showTicks: false,
                                      ranges: [
                                        LinearGaugeRange(
                                          position:
                                              LinearElementPosition.inside,
                                          edgeStyle: LinearEdgeStyle.bothCurve,
                                          startValue: 0,
                                          color: MyColors.border1,
                                          endValue:
                                              (duration.inSeconds.toDouble() /
                                                  10),
                                        ),
                                      ],
                                      barPointers: [
                                        LinearBarPointer(
                                            position:
                                                LinearElementPosition.inside,
                                            edgeStyle:
                                                LinearEdgeStyle.bothCurve,
                                            color: MyColors.primaryColor,
                                            value:
                                                (position.inSeconds.toDouble() /
                                                    10))
                                      ],
                                    ));
                              })
                          : Container(),
                      const SizedBox(width: 10),
                      AudioplayerTimer(
                          title: widget.podcastItem.title ?? "",
                          totalDuration: duration),
                    ],
                  ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: const Icon(IconlyLight.arrow_down, color: MyColors.gray),
              splashRadius: 1,
            ),
            IconButton(
                splashRadius: 20,
                onPressed: () {},
                icon: const Icon(Icons.more_horiz, color: MyColors.gray)),
          ],
        ),
        const SizedBox(height: 12)
      ],
    );
  }
}
