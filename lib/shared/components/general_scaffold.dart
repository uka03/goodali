import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:goodali/connection/models/product_response.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/audio/audio_page.dart';
import 'package:goodali/pages/audio/provider/audio_provider.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/constants.dart';
import 'package:goodali/utils/modals.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/utils.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

class GeneralScaffold extends StatefulWidget {
  const GeneralScaffold({
    super.key,
    required this.child,
    this.appBar,
    this.bottomBar,
    this.actionButton,
    this.extendBodyBehindAppBar = false,
    this.backgroundColor,
    this.withSafearea = true,
    this.withSafeareaBottom = true,
    this.isDetailPage = false,
  });

  final Widget child;
  final PreferredSizeWidget? appBar;
  final Widget? bottomBar, actionButton;
  final bool extendBodyBehindAppBar;
  final bool withSafearea;
  final bool withSafeareaBottom;
  final bool isDetailPage;
  final Color? backgroundColor;

  @override
  State<GeneralScaffold> createState() => _GeneralScaffoldState();
}

class _GeneralScaffoldState extends State<GeneralScaffold> {
  late AudioProvider audioProvider;

  @override
  void initState() {
    super.initState();
    audioProvider = Provider.of<AudioProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
      appBar: widget.appBar,
      backgroundColor: widget.backgroundColor ?? GoodaliColors.primaryBGColor,
      body: widget.withSafearea
          ? SafeArea(
              bottom: widget.withSafeareaBottom,
              child: widget.child,
            )
          : widget.child,
      bottomNavigationBar: widget.bottomBar,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: widget.actionButton ??
          Selector<AudioProvider, GoodaliPlayerState?>(
            selector: (_, provider) => provider.playerState,
            builder: (context, state, _) {
              final audioPlayer = audioProvider.audioPlayer;
              if (!mounted) {
                return SizedBox();
              }
              if (state == GoodaliPlayerState.stopped || state == null) {
                return SizedBox();
              }
              return SizedBox(
                height: 80,
                child: FloatingActionButton.extended(
                  backgroundColor: GoodaliColors.borderColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  elevation: 0,
                  onPressed: null,
                  label: _miniPlayer(context, state, audioPlayer),
                ),
              );
            },
          ),
    );
  }

  Widget _miniPlayer(BuildContext context, GoodaliPlayerState state,
      AudioPlayer? audioPlayer) {
    return CustomButton(
      onPressed: () {
        showModalSheet(
          context,
          isScrollControlled: true,
          height: MediaQuery.of(context).size.height * 0.85,
          child: AudioPage(data: audioProvider.product),
        );
      },
      child: SizedBox(
        width: kIsWeb ? 400 : MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Selector<AudioProvider, ProductResponseData?>(
                        selector: (_, provider) => provider.product,
                        builder: (context, data, _) {
                          return Row(
                            children: [
                              SizedBox(
                                width: 40,
                                height: 40,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        data?.banner?.toUrl() ?? placeholder,
                                  ),
                                ),
                              ),
                              HSpacer(),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data?.isBought == true
                                          ? data?.lectureTitle ?? ""
                                          : data?.title ?? "",
                                      style: GoodaliTextStyles.titleText(
                                          context,
                                          fontSize: 14),
                                    ),
                                    Text(
                                      removeHtmlTags(data?.body ?? ""),
                                      style: GoodaliTextStyles.bodyText(context,
                                          fontSize: 10),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (state == GoodaliPlayerState.playing) {
                            audioProvider.setPlayerState(
                                context, GoodaliPlayerState.paused);
                          } else if (state == GoodaliPlayerState.completed) {
                            audioProvider.setPlayerState(
                                context, GoodaliPlayerState.completed);
                            audioProvider.audioPlayer?.seek(Duration.zero);
                          } else {
                            audioProvider.setPlayerState(
                                context, GoodaliPlayerState.playing);
                          }
                        },
                        icon: Icon(
                          audioProvider.playerState ==
                                  GoodaliPlayerState.playing
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          size: 30,
                          color: GoodaliColors.grayColor,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          audioProvider.setPlayerState(
                              context, GoodaliPlayerState.disposed);
                        },
                        icon: Icon(
                          Icons.close,
                          size: 30,
                          color: GoodaliColors.grayColor,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            StreamBuilder<SeekBarData>(
              stream: audioProvider.streamController?.stream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                return CustomProgressBar(
                  progress: positionData?.position,
                  total: positionData?.duration,
                  buffered: positionData?.bufferedPosition,
                  isMiniPlayer: true,
                  onSeek: (value) {
                    audioProvider.audioPlayer?.seek(value);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CustomProgressBar extends StatelessWidget {
  const CustomProgressBar({
    super.key,
    required this.progress,
    required this.total,
    this.buffered,
    this.onSeek,
    this.isMiniPlayer = false,
  });
  final Duration? progress;
  final Duration? total;
  final Duration? buffered;
  final Function(Duration value)? onSeek;
  final bool isMiniPlayer;

  @override
  Widget build(BuildContext context) {
    return ProgressBar(
      progress: progress ?? Duration.zero,
      total: total ?? Duration.zero,
      buffered: buffered ?? Duration.zero,
      thumbGlowRadius: isMiniPlayer ? 0.0 : 30.0,
      thumbRadius: isMiniPlayer ? 0.0 : 10,
      progressBarColor: GoodaliColors.primaryColor,
      baseBarColor: GoodaliColors.grayColor,
      bufferedBarColor: Colors.grey,
      timeLabelLocation: isMiniPlayer ? TimeLabelLocation.none : null,
      onSeek: (value) {
        if (onSeek != null) {
          onSeek!(value);
        }
      },
      barHeight: 4,
      thumbColor: GoodaliColors.primaryColor,
      timeLabelType: TimeLabelType.remainingTime,
      timeLabelTextStyle: GoodaliTextStyles.bodyText(
        context,
        fontSize: 14,
        textColor: GoodaliColors.grayColor,
      ),
    );
  }
}
