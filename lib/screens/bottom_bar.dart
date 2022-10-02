import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodali/Utils/constans.dart';
import 'package:goodali/Utils/utils.dart';
import 'package:goodali/models/podcast_list_model.dart';
import 'package:goodali/screens/HomeScreen/home_screen.dart';
import 'package:goodali/screens/ForumScreen/forum_screen.dart';
import 'package:goodali/screens/ProfileScreen/profile_screen.dart';
import 'package:goodali/screens/audioScreens.dart/play_audio.dart';
import 'package:iconly/iconly.dart';
import 'package:miniplayer/miniplayer.dart';

final _navigatorKey = GlobalKey();

class BottomTabbar extends StatefulWidget {
  const BottomTabbar({Key? key}) : super(key: key);

  @override
  State<BottomTabbar> createState() => _BottomTabbarState();
}

class _BottomTabbarState extends State<BottomTabbar> {
  int selectedIndex = 0;

  @override
  void initState() {
    // firstValue();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MiniplayerWillPopScope(
      onWillPop: () async {
        final NavigatorState? navigator =
            _navigatorKey.currentState as NavigatorState?;
        if (!navigator!.canPop()) return true;
        navigator.pop();

        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: ValueListenableBuilder(
          valueListenable: playerExpandProgress,
          builder: (BuildContext context, double height, Widget? child) {
            final value = percentageFromValueInRange(
                min: playerMinHeight, max: playerMaxHeight, value: height);

            var opacity = 1 - value;
            if (opacity < 0) opacity = 0;
            if (opacity > 1) opacity = 1;

            return SizedBox(
              height: kBottomNavigationBarHeight -
                  kBottomNavigationBarHeight * value,
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
            Navigator(
              key: _navigatorKey,
              onGenerateRoute: (RouteSettings settings) => MaterialPageRoute(
                settings: settings,
                builder: (BuildContext context) => const HomeScreen(),
              ),
            ),
            _widgetOptions[selectedIndex],
            ValueListenableBuilder(
                valueListenable: currentlyPlaying,
                builder: (BuildContext context, PodcastListModel? podcastItem,
                    Widget? child) {
                  print(podcastItem?.title);
                  return podcastItem != null
                      ? PlayAudio(
                          podcastItem: podcastItem,
                          albumName: podcastItem.albumName ?? "",
                          notifyParent: () {},
                        )
                      : Container();
                }),
          ],
        ),
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
    });
  }

  Widget renderView(int tabIndex, Widget view) {
    return IgnorePointer(
      ignoring: selectedIndex != tabIndex,
      child: Opacity(opacity: selectedIndex == tabIndex ? 1 : 0, child: view),
    );
  }
}
