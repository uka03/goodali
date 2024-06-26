import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:goodali/connection/models/product_response.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/audio/audio_page.dart';
import 'package:goodali/pages/audio/provider/audio_provider.dart';
import 'package:goodali/pages/auth/provider/auth_provider.dart';
import 'package:goodali/pages/cart/provider/cart_provider.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/shared/components/general_scaffold.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/constants.dart';
import 'package:goodali/utils/modals.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/toasts.dart';
import 'package:goodali/utils/utils.dart';
import 'package:provider/provider.dart';

class PodcastItem extends StatefulWidget {
  const PodcastItem({
    super.key,
    required this.podcast,
    this.isbought = false,
    this.ontap,
    this.isSaved = false,
  });

  final ProductResponseData? podcast;
  final Function()? ontap;
  final bool isbought;
  final bool isSaved;

  @override
  State<PodcastItem> createState() => _PodcastItemState();
}

class _PodcastItemState extends State<PodcastItem> {
  bool isLoading = false;
  Duration totalDuration = Duration.zero;
  late CartProvider cartProvider;
  late AudioProvider audioProvider;
  late AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    cartProvider = Provider.of<CartProvider>(context, listen: false);
    audioProvider = Provider.of<AudioProvider>(context, listen: false);
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (widget.podcast != null && (widget.podcast?.totalTime ?? 0) <= 0) {
        await audioTime(widget.podcast);
      }
      authProvider.getMe(isPodcast: true);

      setState(() {
        totalDuration = Duration(minutes: widget.podcast?.totalTime ?? 0);
      });
    });
  }

  Future<void> audioTime(ProductResponseData? podcast) async {
    Duration duration = Duration.zero;
    setState(() {
      isLoading = true;
    });
    final url = podcast?.audio ?? "";
    if (url != "Audio failed to upload") {
      try {
        duration = await _getAudioDuration(url);
      } catch (e) {
        print(e);
        duration = Duration.zero;
      }
    }

    setState(() {
      widget.podcast?.totalTime = duration.inMinutes;
      totalDuration = duration;
      isLoading = false;
    });
  }

  Future<Duration> _getAudioDuration(String url) async {
    Duration duration = Duration.zero;
    try {
      final player = AudioPlayer();
      await player.setSourceUrl(url.toUrl());
      duration = await player.getDuration() ?? Duration.zero;
      player.dispose();
    } catch (e) {
      log("Error retrieving audio duration: $e");
    }
    return duration;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pausedDuration = Duration(minutes: widget.podcast?.pausedTime ?? 0);
    final pausedTime = parseDuration(totalDuration - pausedDuration);
    final totalTime = parseDuration(totalDuration);
    return Consumer<AudioProvider>(builder: (context, provider, _) {
      return CustomButton(
        onPressed: widget.ontap ??
            () {
              showModalSheet(
                context,
                isScrollControlled: true,
                height: MediaQuery.of(context).size.height * 0.85,
                child: AudioPage(
                  isBought: widget.isbought,
                  data: widget.podcast,
                  isSaved: widget.isSaved,
                ),
              );
            },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: CachedNetworkImage(
                        imageUrl: widget.podcast?.banner?.toUrl() ?? placeholder,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  HSpacer(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.isbought ? widget.podcast?.lectureTitle ?? "" : widget.podcast?.title ?? "",
                          style: GoodaliTextStyles.titleText(context),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        VSpacer.xs(),
                        Text(
                          removeHtmlTags(widget.podcast?.body ?? ""),
                          style: GoodaliTextStyles.bodyText(context),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              VSpacer(),
              Row(
                children: [
                  CustomButton(
                    onPressed: () async {
                      if (provider.playerState == GoodaliPlayerState.playing && provider.product?.audio == widget.podcast?.audio) {
                        audioProvider.setPlayerState(context, GoodaliPlayerState.paused);
                      } else {
                        await audioProvider.setAudioPlayer(context, widget.podcast, save: widget.isSaved);
                        if (context.mounted) {
                          audioProvider.setPlayerState(context, GoodaliPlayerState.playing);
                        }
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: GoodaliColors.inputColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        provider.playerState == GoodaliPlayerState.playing && provider.product?.audio == widget.podcast?.audio ? Icons.pause : Icons.play_arrow_rounded,
                      ),
                    ),
                  ),
                  HSpacer(),
                  Expanded(
                    child: pausedDuration.inMinutes == 0
                        ? isLoading
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: GoodaliColors.primaryColor,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                totalTime,
                                style: GoodaliTextStyles.bodyText(
                                  context,
                                  fontSize: 14,
                                ),
                              )
                        : pausedDuration.inMinutes == totalDuration.inMinutes
                            ? Text(
                                "Дууссан",
                                style: GoodaliTextStyles.bodyText(
                                  context,
                                  fontSize: 14,
                                  textColor: GoodaliColors.primaryColor,
                                ),
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    child: CustomProgressBar(
                                      progress: totalDuration - pausedDuration,
                                      total: totalDuration,
                                      isMiniPlayer: true,
                                    ),
                                  ),
                                  HSpacer.sm(),
                                  Text(
                                    "$pausedTime үлдсэн",
                                    style: GoodaliTextStyles.bodyText(
                                      context,
                                      fontSize: 14,
                                      textColor: GoodaliColors.primaryColor,
                                    ),
                                  ),
                                  HSpacer.sm(),
                                ],
                              ),
                  ),
                  HSpacer(),
                  widget.podcast?.isBought == false
                      ? authProvider.token.isEmpty == true || authProvider.me?.email?.toLowerCase() == "surgalt9@gmail.com"
                          ? SizedBox()
                          : CustomButton(
                              onPressed: () {
                                final result = cartProvider.addProduct(widget.podcast);
                                if (result) {
                                  Toast.success(context, description: "Лекц сагсанд нэмэгдлээ.");
                                } else {
                                  Toast.error(context, description: "Лекц сагсанд нэмэгдсэн байна.");
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Image.asset(
                                  "assets/icons/ic_cart.png",
                                  width: 24,
                                ),
                              ),
                            )
                      : SizedBox(),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
