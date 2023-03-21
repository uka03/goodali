import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodali/Providers/auth_provider.dart';
import 'package:goodali/Providers/cart_provider.dart';
import 'package:goodali/Providers/local_database.dart';
import 'package:goodali/Utils/urls.dart';
import 'package:goodali/Utils/utils.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/controller/audioplayer_controller.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/custom_elevated_button.dart';
import 'package:goodali/Widgets/custom_readmore_text.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/controller/default_audio_handler.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/ListItems/album_detail_item.dart';
import 'package:goodali/screens/ListItems/album_intro_item.dart';
import 'package:goodali/screens/audioScreens.dart/intro_audio.dart';
import 'package:goodali/screens/payment/cart_screen.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef OnTap = Function(Products products);

class AlbumDetail extends StatefulWidget {
  final Products albumProduct;
  final bool? isLecture;
  final int? albumID;
  final OnTap onTap;

  const AlbumDetail({
    Key? key,
    required this.albumProduct,
    required this.onTap,
    this.isLecture = false,
    this.albumID,
  }) : super(key: key);

  @override
  State<AlbumDetail> createState() => _AlbumDetailState();
}

class _AlbumDetailState extends State<AlbumDetail> {
  List<int> albumProductsList = [];
  bool isLoading = true;

  final HiveBoughtDataStore dataStore = HiveBoughtDataStore();
  final HiveIntroDataStore dataIntroStore = HiveIntroDataStore();

  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  ScrollController? _controller;
  double imageSize = 0;
  double initialSize = 180;
  double containerHeight = 270;
  double containerInitialHeight = 270;
  double imageOpacity = 1;
  bool isPlaying = false;
  String username = "";
  List<Products> buyList = [];
  List<Products> introList = [];
  AudioPlayer audioPlayer = AudioPlayer();
  @override
  void initState() {
    super.initState();
    audioPlayer.setLoopMode(LoopMode.off);
    getUserName();
    bool isAuth = Provider.of<Auth>(context, listen: false).isAuth;
    if (isAuth) {
      getLectureListLogged();
    } else {
      getAlbumLectures();
    }

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
  }

  getUserName() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      username = pref.getString("email") ?? "";
    });
    // print('appbar $username');
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final isAuth = Provider.of<Auth>(context).isAuth;
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: const SimpleAppBar(),
        body: Consumer<Auth>(
          builder: (context, value, child) {
            return ValueListenableBuilder(
              valueListenable:
                  value.isAuth || widget.albumProduct.isBought == true ? HiveBoughtDataStore.box.listenable() : HiveIntroDataStore.box.listenable(),
              builder: (context, Box box, boxWidgets) {
                if (box.length > 0) {
                  List<Products> lectureList = [];

                  for (int a = 0; a < box.length; a++) {
                    Products products = box.getAt(a);

                    if (products.albumTitle == widget.albumProduct.title) {
                      lectureList.add(products);
                    }
                  }
                  // print(lectureList.length);
                  buyList = removeDuplicates(lectureList);

                  if (widget.albumProduct.isBought == true) {
                    var introProd = buyList.indexWhere((element) => element.title == "Танилцуулга");
                    buyList.insert(0, buyList[introProd]);
                    buyList.removeLast();
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: Stack(children: [
                          Container(
                              height: containerHeight,
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Opacity(
                                    opacity: imageOpacity.clamp(0, 1),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(14),
                                        child: CachedNetworkImage(
                                          imageUrl: "${Urls.networkPath}${widget.albumProduct.banner}",
                                          width: imageSize,
                                          height: imageSize,
                                          progressIndicatorBuilder: (context, url, downloadProgress) {
                                            return Center(
                                              child: CircularProgressIndicator(
                                                color: MyColors.primaryColor,
                                                strokeWidth: 2,
                                                value: downloadProgress.progress,
                                              ),
                                            );
                                          },
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) {
                                            if (error is NetworkImageLoadException && error.statusCode == 404) {
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
                                        )),
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
                                widget.albumProduct.title ?? "" "",
                                style: const TextStyle(fontSize: 20, color: MyColors.black, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: CustomReadMoreText(
                                    text: widget.albumProduct.body ?? "",
                                    textAlign: TextAlign.center,
                                  )),
                              const SizedBox(height: 20),
                              const Divider(endIndent: 20, indent: 20),
                              lecture(context, buyList, isAuth),
                              const SizedBox(height: 70),
                            ]),
                          ),
                        ]),
                      ),
                      widget.albumProduct.isBought == true || username == "surgalt9@gmail.com" && isAuth
                          ? Container()
                          : Container(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                                child: CustomElevatedButton(
                                    text: "Худалдаж авах",
                                    onPress: () {
                                      _onBuyClicked(cart, isAuth);
                                    }),
                              ),
                            ),
                    ],
                  );
                } else {
                  return const Center(child: CircularProgressIndicator(color: MyColors.primaryColor));
                }
              },
            );
          },
        ),
      ),
    );
  }

  Widget lecture(BuildContext context, List<Products> product, bool isAuth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.only(bottom: 15),
        itemBuilder: (BuildContext context, int index) {
          if (widget.albumProduct.isBought == false && product[index].isBought == false) {
            return AlbumIntroItem(
              albumName: '',
              audioPlayer: audioPlayer,
              products: product[index],
              albumProducts: widget.albumProduct,
              onTap: () async {
                print("intro");
                currentlyPlaying.value = product[index];
                if (activeList.first.title == product.first.title && activeList.first.id == product.first.id) {
                  await audioHandler.skipToQueueItem(index);
                  log("Starts in: ${product[index].position}");

                  await audioHandler.seek(
                    Duration(milliseconds: product[index].position!),
                  );

                  await audioHandler.play();
                } else if (activeList.first.title != product.first.title || activeList.first.id != product.first.id) {
                  activeList = product;
                  log("Starts in: ${product[index].position}");
                  await initiliazePodcast();
                  await audioHandler.skipToQueueItem(index);
                  await audioHandler.seek(
                    Duration(milliseconds: product[index].position!),
                  );
                  await audioHandler.play();
                }
              },
            );
          } else {
            return Padding(
              padding: const EdgeInsets.only(top: 12),
              child: AlbumDetailItem(
                products: product[index],
                isBought: product[index].isBought!,
                albumName: widget.albumProduct.title ?? "",
                productsList: product,
                index: index,
                albumProducts: widget.albumProduct,
                onTap: () async {
                  // if (widget.albumProduct.isBought == true) {

                  if (activeList.first.title == product.first.title && activeList.first.id == product.first.id) {
                    currentlyPlaying.value = product[index];
                    await audioHandler.skipToQueueItem(index);
                    await audioHandler.seek(
                      Duration(milliseconds: product[index].position!),
                    );
                    await audioHandler.play();
                  } else if (activeList.first.title != product.first.title || activeList.first.id != product.first.id) {
                    activeList = product;
                    await initiliazePodcast();
                    await audioHandler.skipToQueueItem(index);
                    await audioHandler.seek(
                      Duration(milliseconds: product[index].position!),
                    );
                    await audioHandler.play();
                  }
                  currentlyPlaying.value = product[index];
                  // } else {}
                },
              ),
            );
          }
        },
        itemCount: product.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }

  _onBuyClicked(cart, bool isAuth) {
    print("buyList.length ${buyList.length}");
    print("product id ${buyList[0].productId}");
    for (var item in buyList) {
      if (item.isBought == false) {
        albumProductsList.add(item.productId!);
      }
    }
    cart.addItemsIndex((widget.albumProduct.productId ?? widget.albumProduct.id ?? 0), albumProductIDs: albumProductsList);
    if (!cart.sameItemCheck) {
      cart.addProducts(widget.albumProduct);
      cart.addTotalPrice(widget.albumProduct.price?.toDouble() ?? 0.0);

      Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen()));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen()));
    }
  }

  showIntroAudioModal() {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: true,
        backgroundColor: Colors.white,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        builder: (_) => StatefulBuilder(
              builder: (BuildContext context, void Function(void Function()) setState) {
                return IntroAudio(products: widget.albumProduct, productsList: const []);
              },
            ));
  }

  Future<void> getAlbumLectures() async {
    List<Products> data;
    if (widget.isLecture == true) {
      data = await Connection.getAlbumLectures(context, widget.albumID.toString());
    } else {
      data = await Connection.getAlbumLectures(context, widget.albumProduct.id.toString());
    }

    Products introduction = Products(
        title: "Танилцуулга",
        id: widget.albumProduct.id,
        albumTitle: widget.albumProduct.title,
        audio: widget.albumProduct.audio,
        isBought: widget.albumProduct.isBought,
        productId: widget.albumProduct.productId,
        price: widget.albumProduct.price,
        duration: 0,
        position: 0,
        banner: widget.albumProduct.banner);
    await dataIntroStore.addProduct(products: introduction);

    setState(() {
      introList = data;
      isLoading = false;
    });
    // _initiliazePodcast(lectureList);
    for (var item in data) {
      item.albumTitle = widget.albumProduct.title;
      await dataIntroStore.addProduct(products: item);
    }
  }

  Future<void> getLectureListLogged() async {
    var data = await Connection.getLectureListLogged(context, widget.albumProduct.id.toString());
    Products introduction = Products(
        title: "Танилцуулга",
        id: widget.albumProduct.id,
        albumTitle: widget.albumProduct.title,
        audio: widget.albumProduct.audio,
        isBought: widget.albumProduct.isBought,
        productId: widget.albumProduct.productId,
        duration: 0,
        position: 0,
        price: widget.albumProduct.price,
        banner: widget.albumProduct.banner);
    await dataStore.addProduct(products: introduction);

    setState(() {});
    for (var item in data) {
      item.albumTitle = widget.albumProduct.title;

      await dataStore.addProduct(products: item);
    }
  }
}
