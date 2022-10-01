import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:goodali/Providers/auth_provider.dart';
import 'package:goodali/Utils/constans.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Utils/utils.dart';
import 'package:goodali/Widgets/custom_appbar.dart';
import 'package:goodali/models/podcast_list_model.dart';
import 'package:goodali/screens/HomeScreen/home_screen.dart';
import 'package:goodali/screens/ForumScreen/forum_screen.dart';
import 'package:goodali/screens/ProfileScreen/settings.dart';
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
  String title = "Сэтгэл";
  Widget? actionButton1;
  Widget? actionButton2;
  bool isCartButton = true;
  bool isAuthencated = false;
  @override
  void initState() {
    // firstValue();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: title,
        actionButton2: actionButton2,
        actionButton1: actionButton1,
        isCartButton: isCartButton,
      ),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: playerExpandProgress,
        builder: (BuildContext context, double height, Widget? child) {
          final value = percentageFromValueInRange(
              min: playerMinHeight, max: playerMaxHeight, value: height);

          var opacity = 1 - value;
          if (opacity < 0) opacity = 0;
          if (opacity > 1) opacity = 1;

          return SizedBox(
            height:
                kBottomNavigationBarHeight - kBottomNavigationBarHeight * value,
            child: Transform.translate(
              offset: Offset(0.0, kBottomNavigationBarHeight * value * 0.5),
              child: Opacity(
                opacity: opacity,
                child: OverflowBox(
                  maxHeight: kBottomNavigationBarHeight,
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
          _widgetOptions[selectedIndex],
          ValueListenableBuilder(
              valueListenable: currentlyPlaying,
              builder: (BuildContext context, PodcastListModel? audioObject,
                  Widget? child) {
                print(audioObject?.title);
                return audioObject != null
                    ? PlayAudio(
                        podcastItem: audioObject,
                        albumName: '',
                        notifyParent: () {},
                      )
                    : Container();
              }),
        ],
      ),
    );
  }

  final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const ForumScreen(),
    const ProfileScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      selectedIndex = index;
      switch (index) {
        case 0:
          title = 'Сэтгэл';
          isCartButton = true;
          actionButton2 = null;
          break;
        case 1:
          title = 'Түүдэг гал';
          isCartButton = false;
          actionButton1 = IconButton(
              onPressed: () {},
              icon: const Icon(IconlyLight.heart,
                  size: 28, color: MyColors.black));
          actionButton2 = IconButton(
              onPressed: () {},
              icon: const Icon(IconlyLight.bookmark,
                  size: 28, color: MyColors.black));
          break;
        case 2:
          title = 'Би';
          isCartButton = false;
          actionButton1 = Consumer<Auth>(
            builder: (context, value, child) => value.isAuth
                ? IconButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const Settings()));
                    },
                    icon: const Icon(Icons.more_horiz,
                        size: 28, color: MyColors.black))
                : Container(),
          );
          actionButton2 = null;
          break;
      }
    });
  }

  Widget renderView(int tabIndex, Widget view) {
    return IgnorePointer(
      ignoring: selectedIndex != tabIndex,
      child: Opacity(opacity: selectedIndex == tabIndex ? 1 : 0, child: view),
    );
  }
}
