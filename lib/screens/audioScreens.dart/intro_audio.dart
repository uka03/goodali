import 'dart:convert';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:goodali/Providers/audio_provider.dart';
import 'package:goodali/Providers/cart_provider.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Utils/urls.dart';
import 'package:goodali/Widgets/custom_elevated_button.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/Widgets/top_snack_bar.dart';
import 'package:goodali/controller/progress_notifier.dart';
import 'package:goodali/models/audio_player_model.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/payment/cart_screen.dart';
import 'package:iconly/iconly.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:goodali/Utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroAudio extends StatefulWidget {
  final Products products;
  final List<Products> productsList;
  final AudioPlayer audioPlayer;
  const IntroAudio(
      {Key? key,
      required this.products,
      required this.productsList,
      required this.audioPlayer})
      : super(key: key);

  @override
  State<IntroAudio> createState() => _IntroAudioState();
}

class _IntroAudioState extends State<IntroAudio> {
  late Stream<ProgressBarState> _durationState;

  AudioPlayer audioPlayer = AudioPlayer();
  PlayerState? playerState;

  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  Duration audioPosition = Duration.zero;
  Duration savedPosition = Duration.zero;

  int saveddouble = 0;

  String introUrl = "";
  String audioUrl = "";

  @override
  void initState() {
    super.initState();
    introUrl = Urls.networkPath + widget.products.intro!;
    audioUrl = Urls.networkPath + widget.products.audio!;
    widget.audioPlayer.playbackEventStream.listen((event) {});
    _durationState =
        Rx.combineLatest2<Duration, PlaybackEvent, ProgressBarState>(
            audioPlayer.positionStream,
            audioPlayer.playbackEventStream,
            (position, playbackEvent) => ProgressBarState(
                  current: position,
                  buffered: playbackEvent.bufferedPosition,
                  total: playbackEvent.duration!,
                ));
    _init();
  }

  Future<void> _init() async {
    try {
      await audioPlayer.setUrl(audioUrl).then((value) {
        setState(() {
          audioPosition = value ?? Duration.zero;
        });
      });
      setState(() {
        if (widget.products.intro == "") {
          // audioPlayer.setUrl(audioUrl).then((value) {
          getSavedPosition(widget.products.productId!).then((value) {
            if (value != Duration.zero) {
              savedPosition = value;
              position = savedPosition;
              // if (position != Duration.zero) {
              //   introAudioPlayer.seek(position);
              // }
              audioPlayer.setUrl(audioUrl, initialPosition: position);
            } else {
              audioPlayer.setUrl(audioUrl);
            }
            // });
          });
        } else {
          getSavedPosition(widget.products.productId!).then((value) {
            if (value != Duration.zero) {
              savedPosition = value;
              position = savedPosition;
              // if (position != Duration.zero) {
              //   introAudioPlayer.seek(position);
              // }
              audioPlayer.setUrl(introUrl, initialPosition: position);
            } else {
              audioPlayer.setUrl(introUrl);
            }
            // });
          });
        }
      });
    } catch (e) {
      debugPrint('An error occured $e');
    }
  }

  Future getSavedPosition(int moodItemID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> decodedAudioString = prefs.getStringList("save_audio") ?? [];
    List<AudioPlayerModel> decodedProduct = decodedAudioString
        .map((res) => AudioPlayerModel.fromJson(json.decode(res)))
        .toList();

    // developer.log(decodedProduct.first.audioPosition.toString());
    for (var item in decodedProduct) {
      if (moodItemID == item.productID) {
        saveddouble = decodedProduct.isNotEmpty ? item.audioPosition ?? 0 : 0;
      }
    }
    Duration savedPosition = Duration(milliseconds: saveddouble);

    return savedPosition;
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final _audioPlayerProvider = Provider.of<AudioPlayerProvider>(context);
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2 + 120,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
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
            const SizedBox(height: 40),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: ImageView(
                    imgPath: widget.products.banner ?? "",
                    width: 36,
                    height: 36,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.products.title ?? "",
                        style: const TextStyle(
                            fontSize: 16,
                            height: 1.6,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Wrap(children: [
                            const Text(
                              "Үргэлжлэх хугацаа: ",
                              style:
                                  TextStyle(fontSize: 12, color: MyColors.gray),
                            ),
                            Text(formatTime(audioPosition) + " мин",
                                style: const TextStyle(
                                    fontSize: 12, color: MyColors.black))
                          ]),
                          const SizedBox(width: 20),
                          Wrap(children: [
                            const Text(
                              "Үнэ: ",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 12, color: MyColors.gray),
                            ),
                            Text(
                              widget.products.price.toString() + "₮",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 12, color: MyColors.black),
                            ),
                          ]),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 70),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: StreamBuilder<ProgressBarState>(
                  stream: _durationState,
                  builder: (context, snapshot) {
                    final durationState = snapshot.data;
                    position = durationState?.current ?? Duration.zero;
                    final buffered = durationState?.buffered ?? Duration.zero;
                    duration = durationState?.total ?? Duration.zero;
                    return ProgressBar(
                      progress: position,
                      buffered: buffered,
                      total: duration,
                      thumbColor: MyColors.primaryColor,
                      thumbGlowColor: MyColors.primaryColor,
                      timeLabelTextStyle: const TextStyle(color: MyColors.gray),
                      progressBarColor: MyColors.primaryColor,
                      bufferedBarColor: MyColors.primaryColor.withOpacity(0.3),
                      baseBarColor: MyColors.border1,
                      onSeek: (position) {
                        audioPlayer.seek(position);
                      },
                    );
                    // });
                  }),
            ),
            const SizedBox(height: 40),
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
                  child: StreamBuilder<PlayerState>(
                    stream: audioPlayer.playerStateStream,
                    builder: (context, snapshot) {
                      final playerState = snapshot.data;
                      final processingState = playerState?.processingState;
                      final playing = playerState?.playing;
                      if (processingState == ProcessingState.loading ||
                          processingState == ProcessingState.buffering) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      } else if (playing != true) {
                        return IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 40.0,
                          ),
                          onPressed: audioPlayer.play,
                        );
                      } else if (processingState != ProcessingState.completed) {
                        return IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.pause_rounded,
                            color: Colors.white,
                            size: 40.0,
                          ),
                          onPressed: () {
                            audioPlayer.pause();
                            AudioPlayerModel _audio = AudioPlayerModel(
                                productID: widget.products.productId,
                                audioPosition: position.inMilliseconds);
                            _audioPlayerProvider.addAudioPosition(_audio);
                          },
                        );
                      } else {
                        return IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.replay,
                            color: Colors.white,
                            size: 40.0,
                          ),
                          onPressed: () => audioPlayer.seek(Duration.zero),
                        );
                      }
                    },
                  ),
                ),
                InkWell(
                  onTap: () {
                    buttonForward15Seconds();
                  },
                  child: SvgPicture.asset(
                    "assets/images/forward_15.svg",
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width / 2 + 70,
                    child: CustomElevatedButton(
                        text: "Худалдаж авах",
                        onPress: () {
                          cart.addItemsIndex(widget.products.productId!);
                          if (!cart.sameItemCheck) {
                            cart.addProducts(widget.products);
                            cart.addTotalPrice(
                                widget.products.price?.toDouble() ?? 0.0);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const CartScreen()));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const CartScreen()));
                          }
                        })),
                GestureDetector(
                  onTap: () {
                    cart.addItemsIndex(widget.products.productId!);
                    if (!cart.sameItemCheck) {
                      cart.addProducts(widget.products);
                      cart.addTotalPrice(
                          widget.products.price?.toDouble() ?? 0.0);
                      TopSnackBar.successFactory(
                              msg: "Сагсанд амжилттай нэмэгдлээ")
                          .show(context);
                    } else {
                      TopSnackBar.errorFactory(
                              msg: "Сагсанд бүтээгдэхүүн байна")
                          .show(context);
                    }
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: MyColors.input),
                    child: const Icon(
                      IconlyLight.buy,
                      color: MyColors.primaryColor,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 40)
          ],
        ),
      ),
    );
  }

  buttonBackWard5Seconds() {
    position = position - const Duration(seconds: 5);

    if (position < const Duration(seconds: 0)) {
      audioPlayer.seek(const Duration(seconds: 0));
    } else {
      audioPlayer.seek(position);
    }
  }

  buttonForward15Seconds() {
    position = position + const Duration(seconds: 15);

    if (duration > position) {
      audioPlayer.seek(position);
    } else if (duration < position) {
      audioPlayer.seek(duration);
    }
  }
}
