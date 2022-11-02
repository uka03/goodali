import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Utils/urls.dart';
import 'package:goodali/Widgets/custom_appbar.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/models/banner_model.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/HomeScreen/courseTab/course_detail.dart';
import 'package:goodali/screens/HomeScreen/feelTab/feel_tab.dart';
import 'package:goodali/screens/HomeScreen/courseTab/course_tab.dart';
import 'package:goodali/screens/HomeScreen/listenTab/album.dart';
import 'package:goodali/screens/HomeScreen/listenTab/album_detail.dart';
import 'package:goodali/screens/HomeScreen/listenTab/banner/banner_album.dart';
import 'package:goodali/screens/HomeScreen/listenTab/banner/banner_album.dart';
import 'package:goodali/screens/HomeScreen/listenTab/listen_tab.dart';
import 'package:goodali/Widgets/my_delegate.dart';
import 'package:goodali/screens/HomeScreen/readTab/read_tab.dart';

import 'package:goodali/Widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  static final tabbedPageKey = GlobalKey<_HomeScreenState>();

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final tabController = TabController(length: 4, vsync: this);
  final CarouselController _controller = CarouselController();
  List<BannerModel> bannerList = [];
  int _current = 0;

  @override
  void initState() {
    getBannerList();
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
        // actionButton1: actionButton1,
        isCartButton: true,
      ),
      body: DefaultTabController(
        length: 4,
        child: NestedScrollView(
          physics: const NeverScrollableScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                  collapsedHeight: 271,
                  expandedHeight: 271,
                  backgroundColor: Colors.white,
                  flexibleSpace: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [banner(), const SearchBar()],
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
                    labelColor: MyColors.primaryColor,
                    unselectedLabelColor: MyColors.black,
                    indicatorColor: MyColors.primaryColor,
                  )))
            ];
          },
          body: TabBarView(controller: tabController, children: const [
            ListenTabbar(),
            ReadTabbar(),
            FeelTabbar(),
            CourseTabbar()
          ]),
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => BannerAlbum(
                                    productId: item.productID ?? 0)));
                        break;
                      case 1:
                        print("banner lecuture orj irle");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => BannerAlbum(
                                      productId: item.productID ?? 0,
                                      isAlbum: false,
                                    )));
                        break;
                      case 2:
                        print("case 2 bailaaa");
                        // Navigator.push(context, MaterialPageRoute(builder: (_) => const Cours()));
                        break;
                      default:
                    }
                  },
                  child: ImageView(
                      imgPath: item.banner!,
                      width: MediaQuery.of(context).size.width),
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
              margin:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 6.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white
                      .withOpacity(_current == entry.key ? 0.9 : 0.4)),
            ),
          );
        }).toList(),
      ),
    ]);
  }

  Future getBannerList() async {
    bannerList = await Connection.getBannerList(context);
    setState(() {
      bannerList = bannerList;
    });
    return bannerList;
  }
}
