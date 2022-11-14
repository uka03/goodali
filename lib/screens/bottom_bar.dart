import 'dart:io';

import 'package:flutter/material.dart';
import 'package:goodali/Providers/forum_tag_notifier.dart';
import 'package:goodali/Utils/constans.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Utils/utils.dart';
import 'package:goodali/controller/audioplayer_controller.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/HomeScreen/home_screen.dart';
import 'package:goodali/screens/ForumScreen/forum_screen.dart';
import 'package:goodali/screens/ProfileScreen/profile_screen.dart';
import 'package:goodali/screens/audioScreens.dart/play_audio.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class BottomTabbar extends StatefulWidget {
  const BottomTabbar({Key? key}) : super(key: key);

  @override
  State<BottomTabbar> createState() => _BottomTabbarState();
}

class _BottomTabbarState extends State<BottomTabbar> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: playerExpandProgress,
        builder: (BuildContext context, double height, Widget? child) {
          final value = percentageFromValueInRange(
              min: playerMinHeight, max: playerMaxHeight, value: height);

          var opacity = 1 - value;
          if (opacity < 0) opacity = 0;
          if (opacity > 1) opacity = 1;

          double bottomBarHeight = kBottomNavigationBarHeight;
          if (Platform.isIOS) {
            bottomBarHeight = kBottomNavigationBarHeight + 30;
          }
          return SizedBox(
            height: bottomBarHeight - bottomBarHeight * value,
            child: Transform.translate(
              offset:
                  Offset(0.0, (kBottomNavigationBarHeight + 30) * value * 0.5),
              child: Opacity(
                opacity: opacity,
                child: OverflowBox(
                  maxHeight: kBottomNavigationBarHeight + 30,
                  child: child,
                ),
              ),
            ),
          );
        },
        child: BottomNavigationBar(
          key: _navigationKey,
          unselectedFontSize: 10,
          unselectedItemColor: MyColors.gray,
          elevation: 0,
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 3.0),
                  child: Icon(Icons.circle_outlined),
                ),
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 3.0),
                  child: Icon(Icons.circle_outlined, color: MyColors.gray),
                ),
                label: 'Сэтгэл'),
            BottomNavigationBarItem(
                activeIcon: Padding(
                  padding: const EdgeInsets.only(bottom: 3.0),
                  child: Image.asset("assets/images/tuudeg_gal_icon.png",
                      height: 27, width: 27, color: MyColors.primaryColor),
                ),
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 3.0),
                  child: Image.asset("assets/images/tuudeg_gal_icon.png",
                      height: 27, width: 27, color: MyColors.gray),
                ),
                label: "Түүдэг гал"),
            const BottomNavigationBarItem(
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 3.0),
                  child: Icon(IconlyLight.profile),
                ),
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 3.0),
                  child: Icon(IconlyLight.profile, color: MyColors.gray),
                ),
                label: "Би")
          ],
          currentIndex: selectedIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (int? value) {
            onTabTapped(value!);
          },
        ),
      ),
      body: Stack(
        children: [
          _widgetOptions.elementAt(selectedIndex),
          ValueListenableBuilder(
              valueListenable: currentlyPlaying,
              builder:
                  (BuildContext context, Products? podcastItem, Widget? child) {
                return podcastItem != null
                    ? PlayAudio(
                        products: podcastItem,
                        albumName: podcastItem.albumTitle ?? "",
                      )
                    : Container();
              }),
        ],
      ),
    );
  }

  final List<Widget> _widgetOptions = const <Widget>[
    HomeScreen(),
    ForumScreen(),
    ProfileScreen(),
  ];

  void onTabTapped(int index) {
    Provider.of<ForumTagNotifier>(context, listen: false)
        .selectedForumNames
        .clear();
    setState(() {
      selectedIndex = index;
    });
  }
}

final _navigationKey = GlobalKey<NavigatorState>();
