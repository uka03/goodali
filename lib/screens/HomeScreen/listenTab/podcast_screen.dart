import 'package:flutter/material.dart';
import 'package:goodali/Utils/circle_tab_indicator.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/my_delegate.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/HomeScreen/listenTab/podcast_tabs/downloaded_podcast.dart';
import 'package:goodali/screens/HomeScreen/listenTab/podcast_tabs/listened_podcast.dart';
import 'package:goodali/screens/HomeScreen/listenTab/podcast_tabs/unlistened_podcast.dart';
import 'package:goodali/screens/HomeScreen/listenTab/podcast_tabs/podcast_all_tab.dart';
import 'package:hive_flutter/adapters.dart';

import '../../../Providers/local_database.dart';

class Podcast extends StatefulWidget {
  final int? id;
  final HiveDataStore dataStore;
  const Podcast({Key? key, this.id, required this.dataStore}) : super(key: key);

  @override
  State<Podcast> createState() => _PodcastState();
}

class _PodcastState extends State<Podcast> {
  final HiveDataStore dataStore = HiveDataStore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(noCard: true),
      body: DefaultTabController(
          length: 4,
          child: NestedScrollView(
              physics: const NeverScrollableScrollPhysics(),
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child: SizedBox(
                        height: 56,
                        child: Container(
                          padding: const EdgeInsets.only(left: 20),
                          alignment: Alignment.topLeft,
                          child: const Text("Подкаст",
                              style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: MyColors.black)),
                        )),
                  ),
                  SliverPersistentHeader(
                      floating: false,
                      pinned: true,
                      delegate: MyDelegate(const TabBar(
                        isScrollable: true,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        tabs: [
                          SizedBox(width: 78, child: Tab(text: "Бүгд")),
                          SizedBox(width: 78, child: Tab(text: "Сонсоогүй")),
                          SizedBox(width: 78, child: Tab(text: "Татсан")),
                          SizedBox(width: 78, child: Tab(text: "Сонссон"))
                        ],
                        indicatorWeight: 4,
                        indicator:
                            CustomTabIndicator(color: MyColors.primaryColor),
                        labelColor: MyColors.primaryColor,
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold, fontFamily: 'Gilroy'),
                        unselectedLabelStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Gilroy'),
                        unselectedLabelColor: MyColors.gray,
                        indicatorColor: MyColors.primaryColor,
                      )))
                ];
              },
              body: ValueListenableBuilder(
                valueListenable: HiveDataStore.box.listenable(),
                builder: (context, Box box, widget) {
                  if (box.length > 0) {
                    List<Products> data = [];
                    for (int a = 0; a < box.length; a++) {
                      data.add(box.getAt(a));
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: TabBarView(children: [
                        PodcastAll(
                          podcastList: data,
                        ),
                        NotListenedPodcast(
                          dataStore: dataStore,
                        ),
                        const DownloadedPodcast(),
                        ListenedPodcast(
                          dataStore: dataStore,
                        )
                      ]),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(
                          color: MyColors.primaryColor),
                    );
                  }
                },
              ))),
    );
  }
}
