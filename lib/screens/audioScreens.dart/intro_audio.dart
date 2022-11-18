import 'dart:convert';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:goodali/Providers/audio_provider.dart';
import 'package:goodali/Providers/cart_provider.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Utils/urls.dart';
import 'package:goodali/Widgets/custom_elevated_button.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/Widgets/top_snack_bar.dart';
import 'package:goodali/controller/audioplayer_controller.dart';
import 'package:goodali/controller/default_audio_handler.dart';
import 'package:goodali/controller/progress_notifier.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/audioScreens.dart/player_buttons.dart';
import 'package:goodali/screens/payment/cart_screen.dart';
import 'package:iconly/iconly.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:goodali/Utils/utils.dart';

class IntroAudio extends StatefulWidget {
  final Products products;
  final List<Products> productsList;

  const IntroAudio(
      {Key? key, required this.products, required this.productsList})
      : super(key: key);

  @override
  State<IntroAudio> createState() => _IntroAudioState();
}

class _IntroAudioState extends State<IntroAudio> {
  PlayerState? playerState;
  AudioPlayer audioPlayer = AudioPlayer();
  Duration totalDurationduration = Duration.zero;
  Duration position = Duration.zero;
  Duration audioPosition = Duration.zero;
  Duration savedPosition = Duration.zero;
  var totalDuration = Duration.zero;

  int saveddouble = 0;

  String audioUrl = "";

  @override
  void initState() {
    super.initState();
    audioUrl = Urls.networkPath + widget.products.audio!;
    _init();
  }

  Future<void> _init() async {
    try {
      audioPosition = await audioPlayer.setUrl(audioUrl) ?? Duration.zero;
    } catch (e) {
      debugPrint('An error occured $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

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
                      const SizedBox(height: 15),
                      Text(
                        parseHtmlString(widget.products.body ?? ""),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 12, color: MyColors.gray, height: 1.5),
                      ),
                      const SizedBox(height: 15),
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
              child: ValueListenableBuilder<ProgressBarState>(
                valueListenable: progressNotifier,
                builder: (context, durationValue, widget) {
                  totalDuration = durationStateNotifier.value.total!;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      height: 4,
                      width: double.infinity,
                      child: ProgressBar(
                        progress: durationValue.current,
                        buffered: durationValue.buffered,
                        total: totalDuration,
                        onSeek: (duration) {
                          audioHandler.seek(duration);
                        },
                        timeLabelTextStyle:
                            const TextStyle(color: MyColors.gray),
                        baseBarColor: MyColors.border1,
                        progressBarColor: MyColors.primaryColor,
                        thumbColor: MyColors.primaryColor,
                        bufferedBarColor: MyColors.primaryColor.withAlpha(20),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: buttonBackWard5Seconds,
                  child: SvgPicture.asset(
                    "assets/images/replay_5.svg",
                  ),
                ),
                const CircleAvatar(
                    radius: 36,
                    backgroundColor: MyColors.primaryColor,
                    child: PlayerButtons()),
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
      audioHandler.seek(const Duration(seconds: 0));
    } else {
      audioHandler.seek(position);
    }
  }

  buttonForward15Seconds() {
    position = position + const Duration(seconds: 15);

    if (totalDuration > position) {
      audioHandler.seek(position);
    } else if (totalDuration < position) {
      audioHandler.seek(totalDuration);
    }
  }
}
