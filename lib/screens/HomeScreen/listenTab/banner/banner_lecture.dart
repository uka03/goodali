import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:goodali/Providers/cart_provider.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Utils/urls.dart';
import 'package:goodali/Utils/utils.dart';
import 'package:goodali/Widgets/custom_readmore_text.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/Widgets/top_snack_bar.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/models/products_model.dart';

import 'package:goodali/screens/audioScreens.dart/intro_audio.dart';
import 'package:iconly/iconly.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

class BannerLecture extends StatefulWidget {
  final int? productID;
  const BannerLecture({Key? key, this.productID}) : super(key: key);

  @override
  State<BannerLecture> createState() => _BannerLectureState();
}

class _BannerLectureState extends State<BannerLecture> {
  late final AudioPlayer audioPlayer = AudioPlayer();
  Products albumDetail = Products();
  List<Products> lectureList = [];
  List<Products> bannerLecture = [];
  double imageSize = 180;
  bool isPlaying = false;
  bool isLoading = true;

  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    getProducts();
    audioPlayer.positionStream.listen((event) {
      setState(() {
        position = event;
      });
    });
    audioPlayer.durationStream.listen((event) {
      duration = event ?? Duration.zero;
    });

    audioPlayer.playingStream.listen((event) {
      setState(() {
        isPlaying = event;
      });
    });
    super.initState();
  }

  Future<void> getFileDuration(String mediaPath) async {
    try {
      duration = await audioPlayer.setUrl(mediaPath) ?? Duration.zero;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: const SimpleAppBar(title: "Лекц"),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: MyColors.primaryColor),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: SizedBox(
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          Urls.networkPath + (albumDetail.banner ?? ""),
                          width: imageSize,
                          height: imageSize,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                color: MyColors.primaryColor,
                                strokeWidth: 2,
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stack) {
                            if (error is NetworkImageLoadException &&
                                error.statusCode == 404) {
                              return const Text("404");
                            }

                            return SizedBox(
                                width: imageSize,
                                height: imageSize,
                                child: const Text(
                                  "No Image",
                                  style: TextStyle(fontSize: 12),
                                ));
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        albumDetail.title ?? "" "",
                        style: const TextStyle(
                            fontSize: 20,
                            color: MyColors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: CustomReadMoreText(
                            text: albumDetail.body ?? "",
                            textAlign: TextAlign.center,
                          )),
                      const SizedBox(height: 20),
                      const Divider(endIndent: 20, indent: 20),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {},
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 12),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: ImageView(
                                        imgPath:
                                            bannerLecture.first.banner ?? "",
                                        width: 40,
                                        height: 40)),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        bannerLecture.first.title ?? "",
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
                                          text: bannerLecture.first.body ?? "")
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: MyColors.input,
                                  child: IconButton(
                                    splashRadius: 20,
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      if (isPlaying) {
                                        audioPlayer.pause();
                                      } else {
                                        audioPlayer.play();
                                      }
                                    },
                                    icon: Icon(
                                      isPlaying
                                          ? Icons.pause_rounded
                                          : Icons.play_arrow_rounded,
                                      size: 30,
                                      color: MyColors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(formatTime(duration - position) + "мин",
                                    style: const TextStyle(
                                        fontSize: 12, color: MyColors.black)),
                                const Spacer(),
                                IconButton(
                                    splashRadius: 20,
                                    onPressed: () {
                                      cart.addItemsIndex(
                                          bannerLecture.first.productId!,
                                          albumID: albumDetail.productId!);
                                      if (!cart.sameItemCheck) {
                                        cart.addProducts(bannerLecture.first);
                                        cart.addTotalPrice(bannerLecture
                                                .first.price
                                                ?.toDouble() ??
                                            0.0);
                                        TopSnackBar.successFactory(
                                                msg:
                                                    "Сагсанд амжилттай нэмэгдлээ")
                                            .show(context);
                                      } else {
                                        TopSnackBar.errorFactory(
                                                msg: "Сагсанд байна")
                                            .show(context);
                                      }
                                    },
                                    icon: const Icon(IconlyLight.buy,
                                        color: MyColors.gray))
                              ],
                            ),
                            const SizedBox(height: 12)
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Future<List<Products>> getAlbumLectures() async {
    lectureList = await Connection.getAlbumLectures(context, "5");

    setState(() {
      isLoading = false;
    });
    for (var item in lectureList) {
      if (item.productId == widget.productID) {
        bannerLecture.add(item);
      }
    }
    print(bannerLecture.length);
    await getFileDuration(Urls.networkPath + (bannerLecture.first.audio ?? ""));
    setState(() {});

    return lectureList;
  }

  showIntroAudioModal(Products albumDetail) {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: true,
        backgroundColor: Colors.white,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        builder: (_) => StatefulBuilder(
              builder: (BuildContext context,
                  void Function(void Function()) setState) {
                return IntroAudio(
                    products: albumDetail, productsList: const []);
              },
            ));
  }

  Future<List<Products>> getProducts() async {
    List<Products> albumList = await Connection.getProducts(context, "0");
    getAlbumLectures();
    for (var item in albumList) {
      if (item.productId == 5) {
        setState(() {
          albumDetail = item;
        });
      }
    }
    log(albumDetail.banner ?? "hooson");

    return albumList;
  }
}
