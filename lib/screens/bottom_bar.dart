import 'dart:io';

import 'package:flutter/material.dart';
import 'package:goodali/Providers/forum_tag_notifier.dart';
import 'package:goodali/Utils/constans.dart';
import 'package:goodali/Utils/utils.dart';
import 'package:goodali/controller/audioplayer_controller.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/HomeScreen/home_screen.dart';
import 'package:goodali/screens/ForumScreen/forum_screen.dart';
import 'package:goodali/screens/ProfileScreen/profile_screen.dart';
import 'package:goodali/screens/audioScreens.dart/play_audio.dart';
import 'package:iconly/iconly.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:provider/provider.dart';

class BottomTabbar extends StatefulWidget {
  const BottomTabbar({Key? key}) : super(key: key);

  @override
  State<BottomTabbar> createState() => _BottomTabbarState();
}

class _BottomTabbarState extends State<BottomTabbar> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void goToFirstTab() {
    setState(() {
      selectedIndex = 0;
    });
  }

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
          elevation: 0,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 6.0),
                  child: Icon(Icons.circle_outlined),
                ),
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 6.0),
                  child: Icon(Icons.circle_outlined),
                ),
                label: 'Сэтгэл'),
            BottomNavigationBarItem(
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 6.0),
                  child: Icon(Icons.forum),
                ),
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 6.0),
                  child: Icon(Icons.home_outlined),
                ),
                label: "Түүдэг гал"),
            BottomNavigationBarItem(
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 6.0),
                  child: Icon(IconlyLight.profile),
                ),
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 6.0),
                  child: Icon(IconlyLight.profile),
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
          widgetOptions().elementAt(selectedIndex),
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

  List<Widget> widgetOptions() {
    return [
      HomeScreen(key: HomeScreen.tabbedPageKey),
      ForumScreen(goToFirstTab: goToFirstTab),
      const ProfileScreen(),
    ];
  }

  void onTabTapped(int index) {
    Provider.of<ForumTagNotifier>(context, listen: false)
        .selectedForumNames
        .clear();
    setState(() {
      selectedIndex = index;
    });
  }

  Widget renderView(int tabIndex, Widget view) {
    return IgnorePointer(
      ignoring: selectedIndex != tabIndex,
      child: Opacity(opacity: selectedIndex == tabIndex ? 1 : 0, child: view),
    );
  }
}
