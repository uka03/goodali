import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodali/Providers/auth_provider.dart';
import 'package:goodali/Providers/cart_provider.dart';
import 'package:goodali/Providers/local_database.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/custom_elevated_button.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/Widgets/search_bar.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/models/banner_model.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/Auth/login_web.dart';
import 'package:goodali/screens/Auth/reset_password.dart';
import 'package:goodali/screens/ForumScreen/forum_screen.dart';
import 'package:goodali/screens/HomeScreen/courseTab/course_detail.dart';
import 'package:goodali/screens/HomeScreen/courseTab/course_tab_web.dart';
import 'package:goodali/screens/HomeScreen/feelTab/feel_tab.dart';
import 'package:goodali/screens/HomeScreen/listenTab/album.dart';
import 'package:goodali/screens/HomeScreen/listenTab/banner/banner_album.dart';
import 'package:goodali/screens/HomeScreen/listenTab/banner/banner_lecture.dart';
import 'package:goodali/screens/HomeScreen/listenTab/listen_tab.dart';
import 'package:goodali/screens/HomeScreen/listenTab/podcast_screen.dart';
import 'package:goodali/screens/HomeScreen/listenTab/video_list.dart';
import 'package:goodali/screens/HomeScreen/readTab/article_screen.dart';
import 'package:goodali/screens/HomeScreen/readTab/read_tab.dart';
import 'package:goodali/screens/ListItems/course_products_item_web.dart';
import 'package:goodali/screens/ProfileScreen/edit_profile.dart';
import 'package:goodali/screens/ProfileScreen/faQ.dart';
import 'package:goodali/screens/ProfileScreen/profile_screen.dart';
import 'package:goodali/screens/payment/cart_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 155),
                    child: Image.asset("assets/images/title_logo.png", width: 113, height: 32),
                  ),
                  Expanded(child: Container(padding: EdgeInsets.symmetric(horizontal: 60), child: const SearchBar())),
                  Builder(
                    builder: (BuildContext innerContext) {
                      return InkWell(
                        onTap: () {
                          final RenderBox rowRenderBox = innerContext.findRenderObject() as RenderBox;
                          final rowSize = rowRenderBox.size;
                          final rowPosition = rowRenderBox.localToGlobal(Offset.zero);
                          showMenu<String>(
                            context: context,
                            position: RelativeRect.fromLTRB(
                              rowPosition.dx,
                              rowPosition.dy + rowSize.height,
                              MediaQuery.of(context).size.width - rowPosition.dx - rowSize.width - (rowSize.width / 1.25),
                              rowPosition.dy,
                            ),
                            items: [
                              'Цомог',
                              'Подкаст',
                              'Видео',
                              'Бичвэр',
                              'Мүүд',
                              'Онлайн сургалт',
                            ].map((String choice) {
                              return PopupMenuItem<String>(
                                value: choice,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(choice),
                                ),
                              );
                            }).toList(),
                          ).then((String? value) {
                            if (value != null) {
                              if (value == 'Цомог') {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const AlbumLecture()));
                              } else if (value == 'Подкаст') {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => Podcast(dataStore: dStore)));
                              } else if (value == 'Видео') {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const VideoList()));
                              } else if (value == 'Бичвэр') {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const ArticleScreen()));
                              } else if (value == 'Мүүд') {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const FeelTabbar(isHomeScreen: true)));
                              } else if (value == 'Онлайн сургалт') {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const CourseTabbar()));
                              }
                            }
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Сэтгэл",
                                  style: TextStyle(
                                    fontFamily: 'Gilroy',
                                    color: Color(0xff778089),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                  )),
                              SizedBox(height: 24, width: 24, child: SvgPicture.asset("assets/images/chevron_down.svg", color: Color(0xff778089))),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 30, right: 60),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const ForumScreen()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Сэтгэлийн гэр",
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              color: Color(0xff778089),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                            )),
                      ),
                    ),
                  ),
                  Consumer<Auth>(builder: (BuildContext context, value, Widget? child) {
                    if (value.isAuth == true) {
                      return Row(
                        children: [
                          /* InkWell(
                            onTap: () {
                              // Your action here
                            },
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFBF9F8),
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: SvgPicture.asset(
                                  'assets/images/web_icon_favorite.svg',
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 30), */

                          InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
                            },
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFBF9F8),
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: SvgPicture.asset(
                                  'assets/images/web_icon_cart.svg',
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 30),
                          Builder(
                            builder: (BuildContext innerContext) {
                              return InkWell(
                                onTap: () {
                                  final RenderBox rowRenderBox = innerContext.findRenderObject() as RenderBox;
                                  final rowSize = rowRenderBox.size;
                                  final rowPosition = rowRenderBox.localToGlobal(Offset.zero);
                                  showMenu<String>(
                                    context: context,
                                    position: RelativeRect.fromLTRB(
                                      rowPosition.dx,
                                      rowPosition.dy + rowSize.height,
                                      MediaQuery.of(context).size.width - rowPosition.dx - rowSize.width - (rowSize.width / 1.25),
                                      rowPosition.dy,
                                    ),
                                    items: [
                                      'Би',
                                      'Миний мэдээлэл',
                                      'Пин код солих',
                                      'Нийтлэг асуулт хариулт',
                                      'Гарах',
                                    ].map((String choice) {
                                      return PopupMenuItem<String>(
                                        value: choice,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(choice),
                                        ),
                                      );
                                    }).toList(),
                                  ).then((String? value) {
                                    if (value != null) {
                                      if (value == 'Би') {
                                        Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
                                      } else if (value == 'Миний мэдээлэл') {
                                        Navigator.push(context, MaterialPageRoute(builder: (_) => EditProfile()));
                                      } else if (value == 'Пин код солих') {
                                        Navigator.push(context, MaterialPageRoute(builder: (_) => const ResetPassword()));
                                      } else if (value == 'Нийтлэг асуулт хариулт') {
                                        Navigator.push(context, MaterialPageRoute(builder: (_) => const FrequentlyQuestions()));
                                      } else if (value == 'Гарах') {
                                        showLogOutDialog();
                                      }
                                    }
                                  });
                                },
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFBF9F8),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: SvgPicture.asset(
                                      'assets/images/web_icon_profile.svg',
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(width: 30),
                        ],
                      );
                    } else {
                      return Container(
                        margin: EdgeInsets.only(right: 155),
                        width: 86,
                        height: 36,
                        child: CustomElevatedButton(
                            onPress: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const WebLoginScreen()));
                            },
                            text: "Нэвтрэх"),
                      );
                    }
                  }),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(10),
            sliver: SliverToBoxAdapter(child: carouselBanners()),
          ),
          SliverPadding(
            padding: EdgeInsets.all(10),
            sliver: SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 155),
                child: ListenTabbar(),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(10),
            sliver: SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 155),
                child: ReadTabbar(),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(10),
            sliver: SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.only(left: 155, right: 155, bottom: 155),
                child: FeelTabbar(isHomeScreen: true),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(10),
            sliver: SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 155),
                child: CourseTabbarWeb(),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(10),
            sliver: SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.only(left: 10, right: 155, top: 60, bottom: 34),
                height: 420,
                decoration: new BoxDecoration(color: Color(0xfffbf9f8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: Image.asset("assets/images/title_logo.png", width: 113, height: 32),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Үндсэн",
                          style: TextStyle(
                            fontFamily: 'Gilroy',
                            color: Color(0xff84807d),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        SizedBox(height: 15),
                        InkWell(
                          onTap: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (_) => const WebHomeScreen()));
                          },
                          child: Text(
                            "Сэтгэл",
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              color: Color(0xff393837),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const ForumScreen()));
                          },
                          child: new Text("Сэтгэлийн гэр",
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                color: Color(0xff393837),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                              )),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        new Text("Контент",
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              color: Color(0xff84807d),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                            )),
                        SizedBox(height: 15),
                        InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const AlbumLecture()));
                          },
                          child: new Text("Цомог",
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                color: Color(0xff393837),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                              )),
                        ),
                        SizedBox(height: 15),
                        InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => Podcast(dataStore: dStore)));
                          },
                          child: new Text("Подкаст",
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                color: Color(0xff393837),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                              )),
                        ),
                        SizedBox(height: 15),
                        InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => VideoList()));
                          },
                          child: new Text("Видео",
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                color: Color(0xff393837),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                              )),
                        ),
                        SizedBox(height: 15),
                        InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => ArticleScreen()));
                          },
                          child: new Text("Бичвэр",
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                color: Color(0xff393837),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                              )),
                        ),
                        SizedBox(height: 15),
                        InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => CourseTabbar()));
                          },
                          child: new Text("Онлайн сургалт",
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                color: Color(0xff393837),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                              )),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Бусад",
                          style: TextStyle(
                            fontFamily: 'Gilroy',
                            color: Color(0xff84807d),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        SizedBox(height: 15),
                        InkWell(
                          child: Text(
                            "Үйлчилгээний нөхцөл",
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              color: Color(0xff393837),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => FrequentlyQuestions()));
                          },
                          child: new Text("Тусламж",
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                color: Color(0xff393837),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                              )),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Апп татах",
                          style: TextStyle(
                            fontFamily: 'Gilroy',
                            color: Color(0xff84807d),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        SizedBox(height: 15),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: InkWell(
                            onTap: () {
                              launch("https://apps.apple.com/us/app/goodali/id1661415299");
                            },
                            child: Image.asset(
                              "assets/images/app_store.png",
                              width: 140,
                              height: 40,
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: InkWell(
                            onTap: () {
                              launch("https://play.google.com/store/apps/details?id=com.goodali.mn");
                            },
                            child: Image.asset(
                              "assets/images/google_play.png",
                              width: 140,
                              height: 40,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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

  Widget CourseTabbarWeb() {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Онлайн сургалт", style: TextStyle(color: MyColors.black, fontSize: 24, fontWeight: FontWeight.bold)),
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
                  itemCount: 2,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 15,
                    childAspectRatio: 1,
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (BuildContext context, int index) => CourseProductsListItemWeb(
                        courseProducts: products[index],
                        courseProductsList: products,
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
                        Navigator.push(context, MaterialPageRoute(builder: (_) => CourseDetail(id: item.productID)));
                        break;
                      default:
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
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
