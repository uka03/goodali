import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:goodali/Providers/forum_tag_notifier.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/custom_appbar.dart';
import 'package:goodali/Widgets/my_delegate.dart';
import 'package:goodali/models/tag_model.dart';
import 'package:goodali/screens/ForumScreen/create_post_screen.dart';
import 'package:goodali/screens/ForumScreen/human_nature_tab.dart';
import 'package:goodali/screens/ForumScreen/my_friend_tab.dart';
import 'package:goodali/screens/ForumScreen/tuudeg_gal_tab.dart';
import 'package:goodali/screens/HomeScreen/header_widget.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../Utils/circle_tab_indicator.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({Key? key}) : super(key: key);

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  List<TagModel> tagList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kIsWeb
          ? null
          : const CustomAppBar(
              title: 'Сэтгэлийн гэр',
              actionButton2: null,
              isCartButton: false,
            ),
      body: Column(
        children: [
          const Visibility(
            visible: kIsWeb,
            child: Column(
              children: [
                HeaderWidget(),
                Text(
                  'Сэтгэлийн гэр',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                )
              ],
            ),
          ),
          Expanded(
            child: SizedBox(
              width: kIsWeb ? MediaQuery.of(context).size.width * 0.4 : MediaQuery.of(context).size.width,
              child: DefaultTabController(
                length: 3,
                child: NestedScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        collapsedHeight: 80,
                        expandedHeight: 80,
                        backgroundColor: Colors.white,
                        flexibleSpace: Container(
                          margin: const EdgeInsets.all(18),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            color: MyColors.input,
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 13),
                              const Icon(IconlyLight.edit, color: MyColors.gray),
                              const SizedBox(width: 14),
                              SizedBox(
                                width: 200,
                                child: TextField(
                                  onTap: () {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CreatePost()));
                                  },
                                  readOnly: true,
                                  cursorColor: MyColors.primaryColor,
                                  decoration: const InputDecoration(border: InputBorder.none, hintText: "Пост нэмэх"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverPersistentHeader(
                          floating: false,
                          pinned: true,
                          delegate: MyDelegate(
                              const TabBar(
                                isScrollable: true,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                tabs: [
                                  SizedBox(width: 110, child: Tab(text: "Хүний байгаль")),
                                  SizedBox(width: 110, child: Tab(text: "Түүдэг гал")),
                                  SizedBox(width: 110, child: Tab(text: "Миний нандин"))
                                ],
                                indicatorWeight: 4,
                                indicator: CustomTabIndicator(color: MyColors.primaryColor),
                                labelColor: MyColors.primaryColor,
                                labelStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Gilroy'),
                                unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal, fontFamily: 'Gilroy'),
                                unselectedLabelColor: MyColors.gray,
                                indicatorColor: MyColors.primaryColor,
                              ),
                              container: context.watch<ForumTagNotifier>().selectedForumNames.isEmpty
                                  ? null
                                  : Consumer<ForumTagNotifier>(
                                      builder: (BuildContext context, value, Widget? child) {
                                        return SizedBox(
                                          height: 40,
                                          width: MediaQuery.of(context).size.width,
                                          child: ListView(
                                              scrollDirection: Axis.horizontal,
                                              children: value.selectedForumNames
                                                  .map((e) => Padding(
                                                        padding: const EdgeInsets.only(left: 8.0),
                                                        child: Chip(
                                                          padding: const EdgeInsets.all(2.0),
                                                          side: const BorderSide(color: MyColors.border2, width: 0.5),
                                                          backgroundColor: Colors.white,
                                                          label: Text(
                                                            e['name'],
                                                            style: const TextStyle(color: MyColors.black),
                                                          ),
                                                          deleteIcon: const Icon(Icons.close, size: 20),
                                                          onDeleted: () {
                                                            value.removeTags(e);
                                                          },
                                                        ),
                                                      ))
                                                  .toList()),
                                        );
                                      },
                                    )))
                    ];
                  },
                  body: const TabBarView(children: [NatureOfHuman(), NuutsBulgem(), MyFriendTab()]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
