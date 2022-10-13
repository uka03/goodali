import 'package:audio_service/audio_service.dart';
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
import 'package:goodali/controller/duration_state.dart';
import 'package:goodali/main.dart';
import 'package:goodali/models/audio_player_model.dart';
import 'package:goodali/models/products_model.dart';
import 'package:iconly/iconly.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import 'dart:developer' as developer;

import 'package:rxdart/rxdart.dart';

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

  String audioUrl = '';
  Duration duration = Duration.zero;
  int savedDuration = 0;
  bool isLoading = true;
  bool isClicked = false;
  MediaItem? mediaItem;
  Stream<DurationState>? _durationState;

  Stream<Duration> get _bufferedPositionStream => audioHandler.playbackState
      .map((state) => state.bufferedPosition)
      .distinct();

  Stream<Duration?> get _durationStream =>
      audioHandler.mediaItem.map((item) => item?.duration).distinct();

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

  _initiliazePodcast(Duration duration) async {
    audioPlayerController.initiliaze();

    int savedPosition = await AudioPlayerController().getSavedPosition(
        audioPlayerController.toAudioModel(widget.podcastItem));

    _durationState =
        Rx.combineLatest3<Duration?, Duration, Duration, DurationState>(
            _durationStream,
            AudioService.position,
            _bufferedPositionStream,
            (duration, position, buffered) =>
                DurationState(position, buffered, duration));

    mediaItem = MediaItem(
      id: widget.podcastItem.productId.toString(),
      artUri: Uri.parse(Urls.networkPath + widget.podcastItem.banner!),
      title: widget.podcastItem.title!,
      duration: duration,
      extras: {
        'url': Urls.networkPath + widget.podcastItem.audio!,
        "saved_position": savedPosition
      },
    );
  }

  Future<Duration> getTotalDuration() async {
    try {
      var _totalduration = await audioPlayer.setUrl(audioUrl) ?? Duration.zero;
      if (mounted) {
        setState(() {
          duration = _totalduration;
          isLoading = false;
        });
      }
      savedDuration = await audioPlayerController.getSavedPosition(
          audioPlayerController.toAudioModel(widget.podcastItem));
      duration = duration - Duration(milliseconds: savedDuration);

      developer.log(duration.toString());

      return duration;
    } catch (e) {
      developer.log(e.toString(), name: "totalDuration error");
      return Duration.zero;
    }
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
                await audioHandler.skipToQueueItem(widget.podcastItem.id!);
                print(widget.podcastItem.id!);
                audioHandler.play();
                setState(() {
                  isClicked = true;
                });
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
                          ? AudioProgressBar(totalDuration: duration)
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
