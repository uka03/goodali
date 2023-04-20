import 'dart:developer';

import 'package:ffmpeg_kit_flutter/ffprobe_kit.dart';
import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Utils/urls.dart';
import 'package:goodali/Utils/utils.dart';
import 'package:goodali/Widgets/audio_progressbar.dart';
import 'package:goodali/Widgets/audioplayer_button.dart';
import 'package:goodali/Widgets/audioplayer_timer.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/controller/audioplayer_controller.dart';
import 'package:goodali/controller/default_audio_handler.dart';
import 'package:goodali/controller/duration_state.dart';
import 'package:goodali/controller/pray_button_notifier.dart';
import 'package:goodali/models/article_model.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/HomeScreen/courseTab/course_detail.dart';
import 'package:goodali/screens/HomeScreen/listenTab/album_detail.dart';
import 'package:goodali/screens/ListItems/article_item.dart';

class SpecialListItem extends StatefulWidget {
  final Products specialItem;
  final VoidCallback onTap;
  const SpecialListItem({Key? key, required this.specialItem, required this.onTap}) : super(key: key);

  @override
  State<SpecialListItem> createState() => _SpecialListItemState();
}

class _SpecialListItemState extends State<SpecialListItem> {
  String audioURL = '';
  int savedPosition = 0;
  bool isLoading = true;
  var _totalduration = Duration.zero;
  Duration duration = Duration.zero;
  ArticleModel articleModel = ArticleModel();

  @override
  void initState() {
    if (widget.specialItem.type == "article") {
      articleModel =
          ArticleModel(banner: widget.specialItem.banner, body: widget.specialItem.body, id: widget.specialItem.id, title: widget.specialItem.title);
    }
    if (widget.specialItem.audio != "Audio failed to upload") {
      audioURL = widget.specialItem.audio ?? "";
    }

    if (audioURL != '') {
      getTotalDuration(Urls.networkPath + (widget.specialItem.audio ?? ""));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onSpecialClicked(widget.specialItem.type!);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(4), child: ImageView(imgPath: widget.specialItem.banner ?? "", width: 40, height: 40)),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.specialItem.title ?? "",
                              maxLines: 1,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: MyColors.black, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              parseHtmlString(widget.specialItem.body ?? ""),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14, height: 1.6, color: MyColors.gray),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  if (widget.specialItem.type == "lecture" || widget.specialItem.type == "album") const SizedBox(height: 14),
                  if (widget.specialItem.type == "lecture" || widget.specialItem.type == "album")
                    ValueListenableBuilder(
                        valueListenable: durationStateNotifier,
                        builder: (context, DurationState value, child) {
                          var buttonState = buttonNotifier.value;
                          var currently = currentlyPlaying.value;

                          bool isPlaying = currently?.title == widget.specialItem.title && buttonState == ButtonState.playing ? true : false;

                          return Row(
                            children: [
                              AudioPlayerButton(
                                onPlay: () async {
                                  widget.onTap();
                                },
                                onPause: () {
                                  audioHandler.pause();
                                },
                                title: widget.specialItem.title ?? "",
                                id: widget.specialItem.id!,
                              ),
                              const SizedBox(width: 10),
                              isLoading
                                  ? const SizedBox(
                                      width: 30,
                                      child: LinearProgressIndicator(backgroundColor: Colors.transparent, minHeight: 2, color: MyColors.black))
                                  : Row(
                                      children: [
                                        (savedPosition > 0 || isPlaying)
                                            ? AudioProgressBar(
                                                totalDuration: duration,
                                                title: widget.specialItem.title ?? "",
                                                savedPostion: Duration(milliseconds: savedPosition),
                                              )
                                            : Container(),
                                        const SizedBox(width: 10),
                                        AudioplayerTimer(
                                          id: widget.specialItem.id!,
                                          title: widget.specialItem.title ?? "",
                                          totalDuration: _totalduration,
                                          savedDuration: Duration(milliseconds: savedPosition),
                                        ),
                                      ],
                                    ),
                            ],
                          );
                        }),
                  const SizedBox(height: 12)
                ],
              )),
        ]),
      ),
    );
  }

  Future<Duration> getTotalDuration(String url) async {
    try {
      if (widget.specialItem.duration == null || widget.specialItem.duration == 0) {
        _totalduration = await getFileDuration(url);
      } else {
        _totalduration = Duration(milliseconds: widget.specialItem.duration!);
      }

      if (mounted) {
        setState(() {
          duration = _totalduration;
          isLoading = false;
        });
      }

      savedPosition = widget.specialItem.position!;

      return duration;
    } catch (e) {
      log(e.toString(), name: "special list");
    }
    return duration;
  }

  Future<Duration> getFileDuration(String mediaPath) async {
    final mediaInfoSession = await FFprobeKit.getMediaInformation(mediaPath);
    final mediaInfo = mediaInfoSession.getMediaInformation()!;
    final double duration = double.parse(mediaInfo.getDuration()!);
    widget.specialItem.duration = (duration * 1000).toInt();
    await widget.specialItem.save();
    return Duration(milliseconds: (duration * 1000).toInt());
  }

  void onSpecialClicked(String type) {
    switch (type) {
      case "lecture":
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    AlbumDetail(albumProduct: widget.specialItem, onTap: (value) {}, isLecture: true, albumID: widget.specialItem.albumId)));
        break;
      case "album":
        Navigator.push(context, MaterialPageRoute(builder: (_) => AlbumDetail(albumProduct: widget.specialItem, onTap: (value) {})));
        break;
      case "article":
        Navigator.push(context, MaterialPageRoute(builder: (_) => ArtcileItem(articleModel: articleModel, isFromHome: true)));
        break;
      case "training":
        Navigator.push(context, MaterialPageRoute(builder: (_) => CourseDetail(courseProducts: widget.specialItem, id: widget.specialItem.id)));
        break;
      default:
    }
  }
}
