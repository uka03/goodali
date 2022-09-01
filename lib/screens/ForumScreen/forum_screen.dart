import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/my_delegate.dart';
import 'package:goodali/screens/ForumScreen/human_nature_tab.dart';
import 'package:goodali/screens/ForumScreen/tuudeg_gal_tab.dart';
import 'package:goodali/screens/HomeScreen/feelTab/feel_tab.dart';
import 'package:goodali/screens/HomeScreen/courseTab/course_tab.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({Key? key}) : super(key: key);

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        physics: const NeverScrollableScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverPersistentHeader(
                floating: false,
                pinned: true,
                delegate: MyDelegate(
                  const TabBar(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    tabs: [Tab(text: "Хүний байгаль"), Tab(text: "Түүдэг гал")],
                    labelColor: MyColors.primaryColor,
                    unselectedLabelColor: MyColors.black,
                    indicatorColor: MyColors.primaryColor,
                  ),
                ))
          ];
        },
        body: const TabBarView(children: [NatureOfHuman(), TuudegGal()]),
      ),
    );
  }
}
