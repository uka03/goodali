import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:goodali/Providers/auth_provider.dart';
import 'package:goodali/Providers/cart_provider.dart';
import 'package:goodali/Providers/local_database.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/models/banner_model.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/HomeScreen/courseTab/course_detail.dart';
import 'package:goodali/screens/HomeScreen/courseTab/course_tab_web.dart';
import 'package:goodali/screens/HomeScreen/feelTab/feel_tab.dart';
import 'package:goodali/screens/HomeScreen/footer_widget.dart';
import 'package:goodali/screens/HomeScreen/header_widget.dart';
import 'package:goodali/screens/HomeScreen/listenTab/banner/banner_album.dart';
import 'package:goodali/screens/HomeScreen/listenTab/banner/banner_lecture.dart';
import 'package:goodali/screens/HomeScreen/listenTab/listen_tab.dart';
import 'package:goodali/screens/HomeScreen/readTab/read_tab.dart';
import 'package:goodali/screens/ListItems/course_products_item_web.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class WebHomeScreen extends StatefulWidget {
  const WebHomeScreen({Key? key}) : super(key: key);

  @override
  State<WebHomeScreen> createState() => _WebHomeScreenState();
}

class _WebHomeScreenState extends State<WebHomeScreen> with SingleTickerProviderStateMixin {
  late final tabController = TabController(length: 4, vsync: this);
  final HiveSpecialDataStore dataStore = HiveSpecialDataStore();
  final HiveDataStore dStore = HiveDataStore();
  final CarouselController _controller = CarouselController();
  bool isLoading = true;
  bool isDone = true;
  List<BannerModel> bannerList = [];
  List<Products> specialList = [];
  List<Products> audioList = [];
  String url = "";

  int _current = 0;

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
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: HeaderWidget(isHome: true),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(10),
            sliver: SliverToBoxAdapter(child: carouselBanners()),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(10),
            sliver: SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 155),
                child: const ListenTabbar(isHomeScreen: true),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(10),
            sliver: SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 155),
                child: const ReadTabbar(),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(10),
            sliver: SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(left: 155, right: 155, bottom: 155),
                child: const FeelTabbar(isHomeScreen: true),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(10),
            sliver: SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 155),
                child: courseTabbarWeb(),
              ),
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.all(10),
            sliver: SliverToBoxAdapter(
              child: FooterWidget(),
            ),
          ),
        ],
      ),
    );
  }

  showLogOutDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text("Та гарахдаа итгэлтэй байна уу?", textAlign: TextAlign.center, style: TextStyle(color: MyColors.black, fontSize: 18)),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "ҮГҮЙ",
                    style: TextStyle(color: MyColors.primaryColor),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                    Provider.of<Auth>(context, listen: false).logOut(context);
                    Provider.of<CartProvider>(context, listen: false).removeAllProducts();
                  },
                  child: const Text(
                    "ТИЙМ",
                    style: TextStyle(color: MyColors.primaryColor),
                  )),
            ],
          );
        });
  }

  late final futureCourses = getCourses();

  Future<List<Products>> getCourses() {
    return Connection.getProducts(context, "2");
  }

  Widget courseTabbarWeb() {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Онлайн сургалт", style: TextStyle(color: MyColors.black, fontSize: 24, fontWeight: FontWeight.bold)),
                GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const CourseTabbarWeb()));
                    },
                    child: const Icon(IconlyLight.arrow_right)),
              ],
            )),
        FutureBuilder(
          future: futureCourses,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
              List<Products> products = snapshot.data;

              return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 3,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 15,
                    childAspectRatio: 1,
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (BuildContext context, int index) => CourseProductsListItemWeb(
                        courseProducts: products[index],
                        courseProductsList: products,
                        isHomeScreen: true,
                      ));
            } else {
              return const Center(
                child: CircularProgressIndicator(color: MyColors.primaryColor),
              );
            }
          },
        ),
      ],
    );
  }

  //CarouselSlider banner next and prevous items shows 50% opacity using this bannerList
  Widget carouselBanners() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CarouselSlider(
          items: bannerList
              .map(
                (item) => GestureDetector(
                  onTap: () {
                    // PRODUCT TYPE 0 - ALBUM, 1 - LECTURE, 2 - TRAINING
                    log('PRODUCT TYPE: ${item.productType}');
                    switch (item.productType) {
                      case 0:
                        Navigator.push(context, MaterialPageRoute(builder: (_) => BannerAlbum(productId: item.productID ?? 0)));
                        break;
                      case 1:
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => BannerLecture(
                                      productID: item.productID ?? 0,
                                    )));
                        break;
                      case 2:
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => CourseDetail(
                                      id: item.productID,
                                      isHomeScreen: true,
                                    )));
                        break;
                      default:
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: ImageView(
                        imgPath: item.banner!,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
          carouselController: _controller,
          options: CarouselOptions(
            aspectRatio: 2.3,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
            viewportFraction: 0.8, // Update the viewportFraction to 0.8 to show half of the previous and next items
            enableInfiniteScroll: true,
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
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(_current == entry.key ? 0.9 : 0.4)),
              ),
            );
          }).toList(),
        ),
      ],
    );
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
