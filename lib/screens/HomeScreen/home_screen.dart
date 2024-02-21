import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:goodali/Providers/local_database.dart';
import 'package:goodali/Utils/circle_tab_indicator.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/custom_appbar.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/Widgets/my_delegate.dart';
import 'package:goodali/Widgets/search_bar.dart' as s;
import 'package:goodali/controller/audioplayer_controller.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/controller/default_audio_handler.dart';
import 'package:goodali/models/banner_model.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/HomeScreen/courseTab/course_detail.dart';
import 'package:goodali/screens/HomeScreen/courseTab/course_tab.dart';
import 'package:goodali/screens/HomeScreen/feelTab/feel_tab.dart';
import 'package:goodali/screens/HomeScreen/listenTab/banner/banner_album.dart';
import 'package:goodali/screens/HomeScreen/listenTab/banner/banner_lecture.dart';
import 'package:goodali/screens/HomeScreen/listenTab/listen_tab.dart';
import 'package:goodali/screens/HomeScreen/readTab/read_tab.dart';
import 'package:goodali/screens/ListItems/special_list_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late final tabController = TabController(length: 4, vsync: this);
  final HiveSpecialDataStore dataStore = HiveSpecialDataStore();
  final CarouselController _controller = CarouselController();
  final PageController _pageController = PageController();
  final _kDuration = const Duration(milliseconds: 300);
  final _kCurve = Curves.easeIn;
  bool isLoading = true;
  bool isDone = true;
  List<BannerModel> bannerList = [];
  List<Products> specialList = [];
  List<Products> audioList = [];
  String url = "";

  int _current = 0;
  int _pageCurrent = 0;

  @override
  void initState() {
    getBannerList();
    getSpecialList();
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Сэтгэл',
        actionButton2: null,
        isCartButton: true,
      ),
      body: DefaultTabController(
        length: 4,
        child: NestedScrollView(
          physics: const NeverScrollableScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                  collapsedHeight: 490,
                  expandedHeight: 490,
                  backgroundColor: Colors.white,
                  flexibleSpace: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [banner(), const s.SearchBar(), specialProducts()],
                  )),
              SliverPersistentHeader(
                  floating: false,
                  pinned: true,
                  delegate: MyDelegate(TabBar(
                    controller: tabController,
                    isScrollable: true,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    tabs: const [
                      SizedBox(width: 70, child: Tab(text: "Cонсох")),
                      SizedBox(width: 70, child: Tab(text: "Унших")),
                      SizedBox(width: 70, child: Tab(text: "Мэдрэх")),
                      SizedBox(width: 70, child: Tab(text: "Сургалт*"))
                    ],
                    indicatorWeight: 4,
                    indicator: const CustomTabIndicator(color: MyColors.primaryColor),
                    labelColor: MyColors.primaryColor,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Gilroy'),
                    unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontFamily: 'Gilroy'),
                    unselectedLabelColor: MyColors.gray,
                    indicatorColor: MyColors.primaryColor,
                  )))
            ];
          },
          body: TabBarView(
              controller: tabController, children: const [ListenTabbar(), ReadTabbar(), FeelTabbar(), CourseTabbar()]),
        ),
      ),
    );
  }

  Widget banner() {
    return Stack(alignment: Alignment.bottomCenter, children: [
      CarouselSlider(
        items: bannerList
            .map((item) => GestureDetector(
                  onTap: () {
                    // PRODUCT TYPE 0 - ALBUM, 1 - LECTURE, 2 - TRAINING
                    switch (item.productType) {
                      case 0:
                        // print("banner album orj irle");
                        Navigator.push(
                            context, MaterialPageRoute(builder: (_) => BannerAlbum(productId: item.productID ?? 0)));
                        break;
                      case 1:
                        // print("banner lecuture orj irle");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => BannerLecture(
                                      productID: item.productID ?? 0,
                                    )));
                        break;
                      case 2:
                        // print("case 2 bailaaa");
                        Navigator.push(context, MaterialPageRoute(builder: (_) => CourseDetail(id: item.productID)));
                        break;
                      default:
                    }
                  },
                  child: ImageView(imgPath: item.banner!, width: MediaQuery.of(context).size.width),
                ))
            .toList(),
        carouselController: _controller,
        options: CarouselOptions(
          aspectRatio: 2.3,
          onPageChanged: (index, reason) {
            setState(() {
              _current = index;
            });
          },
          viewportFraction: 1.0,
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: bannerList.asMap().entries.map((entry) {
          return GestureDetector(
            onTap: () => _controller.animateToPage(entry.key),
            child: Container(
              width: 8.0,
              height: 8.0,
              margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 6.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white.withOpacity(_current == entry.key ? 0.9 : 0.4)),
            ),
          );
        }).toList(),
      ),
    ]);
  }

  Widget specialProducts() {
    return !isDone
        ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child:
                    Text("Онцлох", style: TextStyle(color: MyColors.black, fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                height: 190,
                child: Stack(alignment: Alignment.bottomCenter, children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: specialList.length,
                    onPageChanged: (value) {
                      setState(() {
                        _pageCurrent = value;
                      });
                    },
                    itemBuilder: (context, index) {
                      // print("audioList.length ${audioList.length}");
                      return SpecialListItem(
                        specialItem: specialList[index],
                        onTap: () async {
                          if (activeList.first.title == audioList.first.title &&
                              activeList.first.id == audioList.first.id) {
                            currentlyPlaying.value = audioList[index];
                            await audioHandler.skipToQueueItem(index);
                            await audioHandler.seek(Duration(milliseconds: audioList[index].position!));
                            await audioHandler.play();
                          } else if (activeList.first.title != audioList.first.title ||
                              activeList.first.id != audioList.first.id) {
                            activeList = audioList;
                            await initiliazePodcast();
                            await audioHandler.skipToQueueItem(index);
                            await audioHandler.seek(
                              Duration(milliseconds: audioList[index].position!),
                            );
                            await audioHandler.play();
                          }
                          currentlyPlaying.value = audioList[index];
                        },
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: specialList.asMap().entries.map((entry) {
                      return GestureDetector(
                        onTap: () => _pageController.animateToPage(entry.key, curve: _kCurve, duration: _kDuration),
                        child: Container(
                          width: 8.0,
                          height: 8.0,
                          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 6.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: MyColors.primaryColor.withOpacity(_pageCurrent == entry.key ? 0.9 : 0.4)),
                        ),
                      );
                    }).toList(),
                  ),
                ]),
              ),
            ],
          )
        : const CircularProgressIndicator(color: MyColors.primaryColor);
  }

  Future getBannerList() async {
    bannerList = await Connection.getBannerList(context);
    if (mounted) {
      setState(() {
        bannerList = bannerList;
      });
    }
    return bannerList;
  }

  Future<void> getSpecialList() async {
    if (specialList.isNotEmpty) return;
    var list = await Connection.specialList(context);
    if (!mounted) return;

    specialList.clear();
    for (var item in list) {
      await dataStore.addProduct(products: item);
      specialList = await dataStore.getSpecialListfromBox();
    }
    for (var element in specialList) {
      if (element.audio != null) {
        audioList.add(element);
      }
    }
    setState(() {
      isDone = false;
    });
  }
}
