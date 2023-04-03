import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodali/Providers/local_database.dart';
import 'package:goodali/Utils/circle_tab_indicator.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/custom_appbar.dart';
import 'package:goodali/Widgets/custom_elevated_button.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/Widgets/my_delegate.dart';
import 'package:goodali/Widgets/search_bar.dart';
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
import 'package:goodali/screens/ListItems/course_products_item.dart';
import 'package:goodali/screens/ListItems/course_products_item_web.dart';
import 'package:goodali/screens/ListItems/special_list_item.dart';

class WebHomeScreen extends StatefulWidget {
  const WebHomeScreen({Key? key}) : super(key: key);

  @override
  State<WebHomeScreen> createState() => _WebHomeScreenState();
}

class _WebHomeScreenState extends State<WebHomeScreen> with SingleTickerProviderStateMixin {
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
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Сэтгэл",
                            style: TextStyle(
                              fontFamily: 'Gilroy-☞',
                              color: Color(0xff778089),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                            )),
                        SizedBox(height: 24, width: 24, child: SvgPicture.asset("assets/images/chevron_down.svg", color: Color(0xff778089))),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 30, right: 60),
                    child: new Text("Түүдэг гал",
                        style: TextStyle(
                          fontFamily: 'Gilroy-☞',
                          color: Color(0xff778089),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                        )),
                  ),
                  Container(margin: EdgeInsets.only(right: 155), width: 86, height: 36, child: CustomElevatedButton(onPress: () {}, text: "Нэвтрэх")),
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
                child: FeelTabbar(),
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
        ],
      ),
    );
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
