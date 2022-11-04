import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:goodali/Providers/audio_provider.dart';
import 'package:goodali/Providers/cart_provider.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Utils/urls.dart';
import 'package:goodali/Utils/utils.dart';
import 'package:goodali/Widgets/custom_elevated_button.dart';
import 'package:goodali/Widgets/custom_readmore_text.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/models/audio_player_model.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/ListItems/album_detail_item.dart';
import 'package:goodali/screens/ListItems/album_intro_item.dart';
import 'package:goodali/screens/audioScreens.dart/intro_audio.dart';
import 'package:goodali/screens/payment/cart_screen.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

class BannerAlbum extends StatefulWidget {
  final int productId;
  final bool? isAlbum;
  const BannerAlbum({Key? key, required this.productId, this.isAlbum = true})
      : super(key: key);

  @override
  State<BannerAlbum> createState() => _BannerAlbumState();
}

class _BannerAlbumState extends State<BannerAlbum> {
  late final AudioPlayer introAudioPlayer = AudioPlayer();
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

    introAudioPlayer.positionStream.listen((event) {
      position = event;
    });
    introAudioPlayer.durationStream.listen((event) {
      duration = event ?? Duration.zero;
    });

    introAudioPlayer.playingStream.listen((event) {
      isPlaying = event;
    });

    super.initState();
  }

  setAlbumIntroAudio(String audioURl) {
    try {
      introAudioPlayer.setUrl(audioURl).then((value) {
        duration = value ?? Duration.zero;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void dispose() {
    introAudioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _audioPlayerProvider = Provider.of<AudioPlayerProvider>(context);
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: const SimpleAppBar(title: "Цомог"),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: MyColors.primaryColor),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
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
                              value: loadingProgress.expectedTotalBytes != null
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
                      onTap: () {
                        showIntroAudioModal(albumDetail);
                      },
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
                                      imgPath: albumDetail.banner ?? "",
                                      width: 40,
                                      height: 40)),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Танилцуулга".toUpperCase(),
                                      maxLines: 1,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: MyColors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    // CustomReadMoreText(text: widget.products.body ?? "")
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
                                  onPressed: () async {
                                    AudioPlayerModel _audio = AudioPlayerModel(
                                        productID: albumDetail.productId,
                                        audioPosition: position.inMilliseconds);
                                    _audioPlayerProvider
                                        .addAudioPosition(_audio);
                                    if (isPlaying) {
                                      introAudioPlayer.pause();
                                    } else {
                                      introAudioPlayer.play();
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
                                  onPressed: () {},
                                  icon: const Icon(Icons.more_horiz,
                                      color: MyColors.gray)),
                            ],
                          ),
                          const SizedBox(height: 12)
                        ],
                      ),
                    ),
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(bottom: 15),
                      itemBuilder: (BuildContext context, int index) {
                        if (lectureList[index].isBought == false) {
                          return AlbumIntroItem(
                            albumName: '',
                            audioPlayer: audioPlayer,
                            audioPlayerList: [],
                            products: bannerLecture[index],
                            productsList: bannerLecture,
                            setIndex: (int index) {},
                          );
                        } else {
                          return AlbumDetailItem(
                            products: bannerLecture[index],
                            isBought: false,
                            albumName: "",
                            audioPlayer: audioPlayer,
                            productsList: bannerLecture,
                            index: index,
                            albumProducts: Products(),
                            onTap: () {},
                          );
                        }
                      },
                      itemCount: bannerLecture.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(
                        endIndent: 18,
                        indent: 18,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
      floatingActionButton: widget.isAlbum == true
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomElevatedButton(
                  text: "Худалдаж авах",
                  onPress: () {
                    cart.addItemsIndex((widget.productId), albumProductIDs: []);
                    if (!cart.sameItemCheck) {
                      cart.addProducts(albumDetail);
                      cart.addTotalPrice(albumDetail.price?.toDouble() ?? 0.0);
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
                  }),
            )
          : Container(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
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
                    products: albumDetail,
                    productsList: [],
                    audioPlayer: introAudioPlayer);
              },
            ));
  }

  Future<List<Products>> getAlbumLectures() async {
    lectureList = await Connection.getAlbumLectures(context, "2");
    print(lectureList.length);
    for (var item in lectureList) {
      if (item.productId == widget.productId) {
        bannerLecture.add(item);
      }
    }
    print(bannerLecture.length);

    return lectureList;
  }

  Future<List<Products>> getProducts() async {
    List<Products> albumList = await Connection.getProducts(context, "0");
    getAlbumLectures();
    for (var item in albumList) {
      if (item.productId == widget.productId) {
        setState(() {
          albumDetail = item;
          isLoading = false;
        });
      }
    }
    log(albumDetail.banner ?? "hooson");
    String audioURL = Urls.networkPath + (albumDetail.audio ?? "");
    setAlbumIntroAudio(audioURL);

    return albumList;
  }
}
