import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/custom_appbar.dart';
import 'package:goodali/screens/HomeScreen/feelTab/feel_tab.dart';
import 'package:goodali/screens/HomeScreen/courseTab/course_tab.dart';
import 'package:goodali/screens/HomeScreen/listenTab/listen_tab.dart';
import 'package:goodali/Widgets/my_delegate.dart';
import 'package:goodali/screens/HomeScreen/readTab/read_tab.dart';

import 'package:goodali/Widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CarouselController _controller = CarouselController();
  int _current = 0;

  List colorList = [
    MyColors.primaryColor,
    MyColors.secondary,
    MyColors.border1
  ];

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
                  collapsedHeight: 265,
                  expandedHeight: 265,
                  backgroundColor: Colors.white,
                  flexibleSpace: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [banner(), const SearchBar()],
                  )),
              SliverPersistentHeader(
                  floating: false,
                  pinned: true,
                  delegate: MyDelegate(
                    const TabBar(
                      isScrollable: true,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      tabs: [
                        SizedBox(width: 70, child: Tab(text: "Cонсох")),
                        SizedBox(width: 70, child: Tab(text: "Унших")),
                        SizedBox(width: 70, child: Tab(text: "Мэдрэх")),
                        SizedBox(width: 70, child: Tab(text: "Сургалт*"))
                      ],
                      labelColor: MyColors.primaryColor,
                      unselectedLabelColor: MyColors.black,
                      indicatorColor: MyColors.primaryColor,
                    ),
                  ))
            ];
          },
          body: const TabBarView(children: [
            ListenTabbar(),
            ReadTabbar(),
            FeelTabbar(),
            CourseTabbar()
          ]),
        ),
      ),
    );
  }

  late List<Widget> imageSliders = colorList
      .map((item) => Container(
            width: MediaQuery.of(context).size.width,
            color: item,
            child: const Center(
                child: Text(
              "Banner Here",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            )),
          ))
      .toList();

  Widget banner() {
    return Stack(alignment: Alignment.bottomCenter, children: [
      CarouselSlider(
        items: imageSliders,
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
        children: colorList.asMap().entries.map((entry) {
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
}
