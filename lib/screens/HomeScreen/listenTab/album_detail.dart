import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:goodali/Providers/audio_provider.dart';
import 'package:goodali/Providers/auth_provider.dart';
import 'package:goodali/Providers/cart_provider.dart';
import 'package:goodali/Utils/urls.dart';
import 'package:goodali/Utils/utils.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/custom_elevated_button.dart';
import 'package:goodali/Widgets/custom_readmore_text.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/models/audio_player_model.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/ListItems/album_detail_item.dart';
import 'package:goodali/screens/audioScreens.dart/intro_audio.dart';
import 'package:goodali/screens/payment/cart_screen.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class AlbumDetail extends StatefulWidget {
  final Products products;

  const AlbumDetail({Key? key, required this.products}) : super(key: key);

  @override
  State<AlbumDetail> createState() => _AlbumDetailState();
}

class _AlbumDetailState extends State<AlbumDetail> {
  late final List<AudioPlayer> audioPlayer = [];
  late final Future future = getAlbumLectures();
  late final Future futureLogged = getLectureListLogged();
  late final AudioPlayer introAudioPlayer = AudioPlayer();
  List<int> albumProductsList = [];

  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  ScrollController? _controller;
  double imageSize = 0;
  double initialSize = 180;
  double containerHeight = 270;
  double containerInitialHeight = 270;
  double imageOpacity = 1;
  bool isLoading = true;
  bool isPlaying = false;
  bool isClicked = false;
  int currentIndex = 1;
  Duration savedPosition = Duration.zero;
  int saveddouble = 0;

  @override
  void initState() {
    super.initState();
    imageSize = initialSize;

    _controller = ScrollController()
      ..addListener(() {
        imageSize = initialSize - _controller!.offset;
        if (imageSize < 0) {
          imageSize = 0;
        }

        containerHeight = containerInitialHeight - _controller!.offset;
        if (containerHeight < 0) {
          containerHeight = 0;
        }
        imageOpacity = imageSize / initialSize;

        setState(() {});
      });

    introAudioPlayer.positionStream.listen((event) {
      position = event;
    });
    introAudioPlayer.durationStream.listen((event) {
      duration = event ?? Duration.zero;
    });

    introAudioPlayer.playingStream.listen((event) {
      isPlaying = event;
    });
    setAlbumIntroAudio();
  }

  @override
  void dispose() {
    introAudioPlayer.dispose();
    audioPlayer.map((e) => e.dispose());
    super.dispose();
  }

  setAlbumIntroAudio() {
    try {
      introAudioPlayer
          .setUrl(Urls.networkPath + widget.products.audio!)
          .then((value) {
        duration = value ?? Duration.zero;
        getSavedPosition(widget.products.productId!).then((value) {
          if (value != Duration.zero) {
            savedPosition = value;
            position = savedPosition;
            // if (position != Duration.zero) {
            //   introAudioPlayer.seek(position);
            // }
            introAudioPlayer.setUrl(Urls.networkPath + widget.products.audio!,
                initialPosition: position);
          } else {}
        });
      });
    } catch (e) {
      print(e);
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
  Widget build(BuildContext context) {
    final _audioPlayerProvider = Provider.of<AudioPlayerProvider>(context);
    final cart = Provider.of<CartProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        print("onwiilppaoop");
        // AudioPlayerModel _audio = AudioPlayerModel(
        //     productID: widget.products.productId,
        //     audioPosition: position.inMilliseconds);
        // _audioPlayerProvider.addAudioPosition(_audio);
        return true;
      },
      child: Scaffold(
          appBar: const SimpleAppBar(),
          body: Consumer<Auth>(
            builder: (context, value, child) {
              return FutureBuilder(
                future: value.isAuth ? futureLogged : future,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    List<Products> lectureList = snapshot.data;
                    return Stack(children: [
                      Container(
                          height: containerHeight,
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Container(
                              //     height: imageSize,
                              //     width: imageSize,
                              //     color: Colors.indigo[200]),
                              Opacity(
                                opacity: imageOpacity.clamp(0, 1),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: ImageView(
                                      imgPath: widget.products.banner ?? "",
                                      width: imageSize,
                                      height: imageSize),
                                ),
                              ),
                              const SizedBox(height: 80)
                            ],
                          )),
                      SingleChildScrollView(
                        controller: _controller,
                        physics: const BouncingScrollPhysics(),
                        child: Column(children: [
                          SizedBox(height: initialSize + 32),
                          Text(
                            widget.products.title ?? "",
                            style: const TextStyle(
                                fontSize: 20,
                                color: MyColors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: CustomReadMoreText(
                                text: widget.products.body ?? "",
                                textAlign: TextAlign.center,
                              )),
                          const SizedBox(height: 20),
                          const Divider(endIndent: 20, indent: 20),
                          lecture(context, lectureList),
                          const SizedBox(height: 20),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: CustomElevatedButton(
                                text: "Худалдаж авах",
                                onPress: () {
                                  for (var item in lectureList) {
                                    albumProductsList.add(item.productId!);
                                  }
                                  cart.addItemsIndex(widget.products.productId!,
                                      albumProductIDs: albumProductsList);
                                  if (!cart.sameItemCheck) {
                                    cart.addProducts(widget.products);
                                    cart.addTotalPrice(
                                        widget.products.price?.toDouble() ??
                                            0.0);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const CartScreen()));
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const CartScreen()));
                                  }
                                }),
                          ),
                          const SizedBox(height: 50),
                        ]),
                      ),
                    ]);
                  } else {
                    return const Center(
                        child: CircularProgressIndicator(
                            color: MyColors.primaryColor));
                  }
                },
              );
            },
          )),
    );
  }

  Widget lecture(BuildContext context, List<Products> product) {
    final _audioPlayerProvider = Provider.of<AudioPlayerProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          GestureDetector(
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
                    ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: ImageView(
                            imgPath: widget.products.banner ?? "",
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
                          setState(() {
                            isClicked = true;
                            currentIndex = audioPlayer.length + 1;
                          });
                          AudioPlayerModel _audio = AudioPlayerModel(
                              productID: widget.products.productId,
                              audioPosition: position.inMilliseconds);
                          _audioPlayerProvider.addAudioPosition(_audio);
                          if (isPlaying) {
                            introAudioPlayer.pause();
                          } else {
                            await introAudioPlayer.play();
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
                    if (isClicked || savedPosition != Duration.zero)
                      Row(
                        children: [
                          const SizedBox(width: 14),
                          SizedBox(
                            width: 90,
                            child: SfLinearGauge(
                              minimum: 0,
                              maximum: duration.inSeconds.toDouble() / 10,
                              showLabels: false,
                              showAxisTrack: false,
                              showTicks: false,
                              ranges: [
                                LinearGaugeRange(
                                  position: LinearElementPosition.inside,
                                  edgeStyle: LinearEdgeStyle.bothCurve,
                                  startValue: 0,
                                  color: MyColors.border1,
                                  endValue: duration.inSeconds.toDouble() / 10,
                                ),
                              ],
                              barPointers: [
                                LinearBarPointer(
                                    position: LinearElementPosition.inside,
                                    edgeStyle: LinearEdgeStyle.bothCurve,
                                    color: MyColors.primaryColor,
                                    // color: MyColors.border1,
                                    value: position.inSeconds.toDouble() / 10)
                              ],
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(width: 10),
                    Text(formatTime(duration - position) + "мин",
                        style: const TextStyle(
                            fontSize: 12, color: MyColors.black)),
                    const Spacer(),
                    IconButton(
                        splashRadius: 20,
                        onPressed: () {},
                        icon:
                            const Icon(Icons.more_horiz, color: MyColors.gray)),
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
              audioPlayer.add(AudioPlayer());
              for (var i = 0; i < audioPlayer.length; i++) {
                if (currentIndex != i) {
                  audioPlayer[i].pause();
                }
                if (audioPlayer[i].playing) {
                  introAudioPlayer.pause();
                }
              }
              return AlbumDetailItem(
                products: product[index],
                isBought: false,
                albumName: widget.products.title!,
                audioPlayer: audioPlayer[index],
                currentIndex: currentIndex,
                audioPlayerList: audioPlayer,
                productsList: product,
                albumProducts: widget.products,
                setIndex: (int index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
              );
            },
            itemCount: product.length,
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(
              endIndent: 18,
              indent: 18,
            ),
          ),
        ],
      ),
    );
  }

  showIntroAudioModal() {
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
                return IntroAudio(products: widget.products, productsList: []);
              },
            ));
  }

  Future<List<Products>> getAlbumLectures() async {
    return await Connection.getAlbumLectures(
        context, widget.products.id.toString());
  }

  Future<List<Products>> getLectureListLogged() async {
    return await Connection.getLectureListLogged(
        context, widget.products.id.toString());
  }
}
