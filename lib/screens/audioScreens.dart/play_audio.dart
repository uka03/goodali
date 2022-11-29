import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:goodali/Utils/constans.dart';
import 'package:goodali/Utils/styles.dart';

import 'package:goodali/Utils/utils.dart';
import 'package:goodali/Widgets/download_button.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/controller/audioplayer_controller.dart';
import 'package:goodali/controller/default_audio_handler.dart';

import 'package:goodali/controller/duration_state.dart';
import 'package:goodali/controller/pray_button_notifier.dart';
import 'package:goodali/controller/progress_notifier.dart';
import 'package:goodali/screens/audioScreens.dart/player_buttons.dart';
import 'package:miniplayer/miniplayer.dart';

import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/audioScreens.dart/audio_description.dart';
import 'package:iconly/iconly.dart';

void onTap() {}

final MiniplayerController controller = MiniplayerController();

class PlayAudio extends StatefulWidget {
  final Products products;
  final String albumName;

  final String? downloadedAudioPath;

  const PlayAudio({
    Key? key,
    required this.products,
    required this.albumName,
    this.downloadedAudioPath,
  }) : super(key: key);

  @override
  State<PlayAudio> createState() => _PlayAudioState();
}

class _PlayAudioState extends State<PlayAudio> {
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    print('widget.products.isBought');
    print(widget.products.isBought);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return playAudio();
  }

  Widget playAudio() {
    return Miniplayer(
        valueNotifier: playerExpandProgress,
        minHeight: playerMinHeight,
        maxHeight: playerMaxHeight,
        onDismiss: () async {
          await audioHandler.stop();
          audioHandler.customAction("dispose");
          currentlyPlaying.value = null;
        },
        controller: controller,
        elevation: 4,
        curve: Curves.easeOut,
        builder: (height, percentage) {
          bool miniplayer = percentage < miniplayerPercentageDeclaration;
          const double maxImgSize = 220;

          var percentageExpandedPlayer = percentageFromValueInRange(
              min: playerMaxHeight * miniplayerPercentageDeclaration +
                  playerMinHeight,
              max: playerMaxHeight,
              value: height);
          if (percentageExpandedPlayer < 0) percentageExpandedPlayer = 0;
          final paddingVertical = valueFromPercentageInRange(
              min: 0, max: 0, percentage: percentageExpandedPlayer);
          final double heightWithoutPadding = height - paddingVertical * 2 / 9;
          final double imageSize =
              heightWithoutPadding > maxImgSize ? maxImgSize : 48;

          position = durationStateNotifier.value.progress ?? Duration.zero;
          duration = durationStateNotifier.value.total ?? Duration.zero;

          if (!miniplayer) {
            return Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12))),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Opacity(
                  opacity: percentageExpandedPlayer,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Container(
                        width: 38,
                        height: 6,
                        decoration: BoxDecoration(
                            color: MyColors.gray,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: EdgeInsets.only(
                            left: paddingVertical,
                            top: paddingVertical,
                            bottom: paddingVertical),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: ImageView(
                            imgPath: widget.products.banner ?? "",
                            width: imageSize,
                            height: imageSize,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        widget.albumName,
                        style:
                            const TextStyle(fontSize: 12, color: MyColors.gray),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.products.title == ""
                            ? widget.products.lectureTitle ?? ""
                            : widget.products.title ?? "",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 46),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (widget.products.isBought == true)
                            DownloadButton(
                                products: widget.products, isModalPlayer: true),
                          Column(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AudioDescription(
                                                  description: widget
                                                          .products.body ??
                                                      widget.products.body ??
                                                      "")));
                                },
                                icon: const Icon(
                                  IconlyLight.info_square,
                                  color: MyColors.gray,
                                ),
                                splashRadius: 1,
                              ),
                              const Text("Тайлбар",
                                  style: TextStyle(
                                      fontSize: 12, color: MyColors.gray))
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      ValueListenableBuilder<ProgressBarState>(
                        valueListenable: progressNotifier,
                        builder: (context, durationValue, widget) {
                          var totalDuration = durationStateNotifier.value.total;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: SizedBox(
                              height: 50,
                              width: 300,
                              child: ProgressBar(
                                progress: durationValue.current,
                                buffered: durationValue.buffered,
                                total: totalDuration!,
                                onSeek: (Duration duration) async {
                                  print("onSeek");
                                  print(duration);

                                  await audioHandler.seek(duration);
                                },
                                baseBarColor: MyColors.border1,
                                progressBarColor: MyColors.primaryColor,
                                thumbColor: MyColors.primaryColor,
                                bufferedBarColor:
                                    MyColors.primaryColor.withAlpha(20),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: buttonBackWard5Seconds,
                            child: SvgPicture.asset(
                              "assets/images/replay_5.svg",
                            ),
                          ),
                          CircleAvatar(
                              radius: 36,
                              backgroundColor: MyColors.primaryColor,
                              child:
                                  PlayerButtons(title: widget.products.title!)),
                          InkWell(
                            onTap: buttonForward15Seconds,
                            child: SvgPicture.asset(
                              "assets/images/forward_15.svg",
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }
          final percentageMiniplayer = percentageFromValueInRange(
              min: playerMinHeight,
              max: playerMaxHeight * miniplayerPercentageDeclaration +
                  playerMinHeight,
              value: height);

          final elementOpacity = 1 - 1 * percentageMiniplayer;
          final progressIndicatorHeight = 3 - 3 * percentageMiniplayer;

          return GestureDetector(
            onTap: () => controller.animateToHeight(state: PanelState.MAX),
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      ConstrainedBox(
                        constraints:
                            const BoxConstraints(maxHeight: maxImgSize),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: ImageView(
                            imgPath: widget.products.banner ??
                                widget.products.banner ??
                                "",
                            width: imageSize,
                            height: imageSize,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Opacity(
                            opacity: elementOpacity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(widget.products.title ?? "",
                                    maxLines: 1,
                                    style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.bold,
                                        color: MyColors.black)),
                                Text(
                                  widget.albumName,
                                  style: const TextStyle(
                                      fontSize: 12, color: MyColors.gray),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 3),
                        child: Opacity(
                          opacity: elementOpacity,
                          child: ValueListenableBuilder(
                            valueListenable: buttonNotifier,
                            builder:
                                (context, ButtonState? buttonValue, widget) {
                              if (buttonValue?.index == 0) {
                                return IconButton(
                                  icon: const Icon(Icons.play_arrow_rounded),
                                  onPressed: () {
                                    audioHandler.play();
                                  },
                                );
                              } else if (buttonValue?.index == 1) {
                                return IconButton(
                                    onPressed: () {
                                      audioHandler.pause();
                                      buttonNotifier.value = ButtonState.paused;
                                    },
                                    icon: const Icon(Icons.pause_rounded));
                              } else {
                                return const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(
                                      color: Colors.grey),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            audioHandler.pause();
                            currentlyPlaying.value = null;
                            buttonNotifier.value = ButtonState.paused;
                          }),
                    ],
                  ),
                ),
                SizedBox(
                    height: progressIndicatorHeight,
                    child: Opacity(
                      opacity: elementOpacity,
                      child: ValueListenableBuilder<DurationState>(
                        valueListenable: durationStateNotifier,
                        builder: (context, durationValue, widget) {
                          return SizedBox(
                            height: 2,
                            width: double.infinity,
                            child: ProgressBar(
                              progress: durationValue.progress!,
                              buffered: durationValue.buffered,
                              total: durationValue.total!,
                              onSeek: null,
                              barHeight: 2,
                              baseBarColor: MyColors.border1,
                              progressBarColor: MyColors.primaryColor,
                              thumbRadius: 0,
                              thumbGlowRadius: 0,
                              thumbColor: Colors.transparent,
                              bufferedBarColor:
                                  MyColors.primaryColor.withAlpha(20),
                            ),
                          );
                        },
                      ),
                    )),
              ],
            ),
          );
        });
  }

  buttonForward15Seconds() {
    position = position + const Duration(seconds: 15);
    if (duration > position) {
      audioHandler.seek(position);
    } else if (duration < position) {
      audioHandler.seek(duration);
    }
  }

  buttonBackWard5Seconds() {
    position = position - const Duration(seconds: 5);
    if (position < const Duration(seconds: 0)) {
      audioHandler.seek(const Duration(seconds: 0));
    } else {
      audioHandler.seek(position);
    }
  }
}
