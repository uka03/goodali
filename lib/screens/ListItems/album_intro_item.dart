import 'dart:developer';

import 'package:ffmpeg_kit_flutter/ffprobe_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:goodali/Providers/auth_provider.dart';
import 'package:goodali/Providers/cart_provider.dart';
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
import 'package:goodali/controller/duration_state.dart';
import 'package:goodali/controller/pray_button_notifier.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/audioScreens.dart/intro_audio.dart';
import 'package:iconly/iconly.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef SetIndex = void Function(int index);

class AlbumIntroItem extends StatefulWidget {
  final Products products;
  final Products? albumProducts;
  final VoidCallback onTap;

  final String albumName;

  final AudioPlayer audioPlayer;

  const AlbumIntroItem(
      {Key? key, required this.products, required this.albumName, required this.audioPlayer, this.albumProducts, required this.onTap})
      : super(key: key);
  @override
  State<AlbumIntroItem> createState() => _AlbumIntroItemState();
}

class _AlbumIntroItemState extends State<AlbumIntroItem> {
  FileInfo? fileInfo;
  File? audioFile;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  int savedPosition = 0;
  int saveddouble = 0;
  int currentIndex = 0;
  bool isPlaying = false;
  String url = "";
  var _totalduration = Duration.zero;
  String username = "";
  bool isLoading = true;

  @override
  void initState() {
    getUserName();
    getTotalDuration(Urls.networkPath + widget.products.audio!);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getUserName() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      username = pref.getString("email") ?? "";
    });
    // print('appbar $username');
  }

  Future<Duration> getTotalDuration(String url) async {
    try {
      if (widget.products.duration == null || widget.products.duration == 0) {
        _totalduration = await getFileDuration(url);
      } else {
        _totalduration = Duration(milliseconds: widget.products.duration!);
      }

      log(_totalduration.toString(), name: "intro duration");

      if (mounted) {
        setState(() {
          duration = _totalduration;
          isLoading = false;
        });
      }

      savedPosition = widget.products.position ?? 0;
      return duration;
    } catch (e) {
      log(e.toString(), name: "intro item");
    }
    return duration;
  }

  Future<Duration> getFileDuration(String mediaPath) async {
    final mediaInfoSession = await FFprobeKit.getMediaInformation(mediaPath);
    final mediaInfo = mediaInfoSession.getMediaInformation()!;
    final double duration = double.parse(mediaInfo.getDuration()!);
    widget.products.duration = (duration * 1000).toInt();
    await widget.products.save();
    return Duration(milliseconds: (duration * 1000).toInt());
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    var isAuth = Provider.of<Auth>(context).isAuth;
    return GestureDetector(
        onTap: () {
          showIntroAudioModal();
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(borderRadius: BorderRadius.circular(4), child: ImageView(imgPath: widget.products.banner ?? "", width: 40, height: 40)),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.products.title ?? "",
                        maxLines: 1,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: MyColors.black, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        parseHtmlString(widget.products.body ?? ""),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14, height: 1.6, color: MyColors.gray),
                      )
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
                bool isPlaying = currently?.title == widget.products.title && buttonState == ButtonState.playing ? true : false;

                return Row(
                  children: [
                    AudioPlayerButton(
                      onPlay: () async {
                        widget.onTap();
                      },
                      onPause: () {
                        audioHandler.pause();
                      },
                      title: widget.products.title ?? "",
                      id: widget.products.id!,
                    ),
                    const SizedBox(width: 10),
                    isLoading
                        ? const SizedBox(
                            width: 30, child: LinearProgressIndicator(backgroundColor: Colors.transparent, minHeight: 2, color: MyColors.black))
                        : Row(
                            children: [
                              (savedPosition > 0 || isPlaying)
                                  ? AudioProgressBar(
                                      totalDuration: duration,
                                      title: widget.products.title ?? "",
                                      savedPostion: Duration(milliseconds: savedPosition),
                                    )
                                  : Container(),
                              const SizedBox(width: 10),
                              AudioplayerTimer(
                                id: widget.products.id!,
                                title: widget.products.title ?? "",
                                totalDuration: _totalduration,
                                savedDuration: Duration(milliseconds: savedPosition),
                              ),
                            ],
                          ),
                    const Spacer(),
                    if (username != "surgalt9@gmail.com" && isAuth)
                      widget.products.isBought == false && widget.products.title != "Танилцуулга"
                          ? IconButton(
                              splashRadius: 20,
                              onPressed: () {
                                addToCard(cart);
                              },
                              icon: const Icon(IconlyLight.buy, color: MyColors.gray))
                          : Container(),
                    moreButton()
                  ],
                );
              },
            ),
            const SizedBox(height: 12)
          ],
        ));
  }

  //To show a PopupMenu with Share and Copy Link options on the onTap event of the IconButton widget
  Widget moreButton() {
    return PopupMenuButton(
      icon: IconButton(splashRadius: 20, onPressed: () {}, icon: const Icon(Icons.more_horiz, color: MyColors.gray)),
      onSelected: (value) {
        if (value == 0) {
          Share.share(Urls.networkPath + widget.products.audio!);
        } else if (value == 1) {
          Clipboard.setData(ClipboardData(text: Urls.networkPath + widget.products.audio!));
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Линк хуулагдлаа')));
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 0,
          child: Text('Хуваалцах'),
        ),
        const PopupMenuItem(
          value: 1,
          child: Text('Линк хуулах'),
        ),
      ],
    );
  }

  showIntroAudioModal() {
    if (kIsWeb) {
      showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: true,
        backgroundColor: Colors.transparent, // Change this to transparent
        isScrollControlled: true,
        clipBehavior: Clip.antiAlias,
        builder: (_) => StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return Column(
              children: [
                const Spacer(),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    child: IntroAudio(products: widget.products, productsList: const []),
                  ),
                ),
                const Spacer(),
              ],
            );
          },
        ),
      );
    } else {
      showModalBottomSheet(
          context: context,
          isDismissible: false,
          enableDrag: true,
          backgroundColor: Colors.white,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
          builder: (_) => StatefulBuilder(
                builder: (BuildContext _, void Function(void Function()) setState) {
                  // setState(() {});
                  return IntroAudio(products: widget.products, productsList: const []);
                },
              ));
    }
  }

  addToCard(cart) {
    cart.addItemsIndex(widget.products.productId!, albumID: widget.albumProducts?.productId!);
    if (!cart.sameItemCheck) {
      cart.addProducts(widget.products);
      cart.addTotalPrice(widget.products.price?.toDouble() ?? 0.0);
      TopSnackBar.successFactory(msg: "Сагсанд амжилттай нэмэгдлээ").show(context);
    } else {
      TopSnackBar.errorFactory(msg: "Сагсанд байна").show(context);
    }
  }
}
