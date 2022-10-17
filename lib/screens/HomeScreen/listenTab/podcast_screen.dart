import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/my_delegate.dart';
import 'package:goodali/controller/audioplayer_controller.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/controller/podcast_state.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/repository.dart/sembast_repository.dart';
import 'package:goodali/screens/HomeScreen/listenTab/podcast_tabs/downloaded_podcast.dart';
import 'package:goodali/screens/HomeScreen/listenTab/podcast_tabs/listened_podcast.dart';
import 'package:goodali/screens/HomeScreen/listenTab/podcast_tabs/unlistened_podcast.dart';
import 'package:goodali/screens/HomeScreen/listenTab/podcast_tabs/podcast_all_tab.dart';
import 'package:goodali/services/podcast_service.dart';

class Podcast extends StatefulWidget {
  const Podcast({Key? key}) : super(key: key);

  @override
  State<Podcast> createState() => _PodcastState();
}

class _PodcastState extends State<Podcast> {
  PodcastService service = PodcastService(repository: SembastRepository());
  late final future = getPodcastList();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
          length: 4,
          child: NestedScrollView(
              physics: const NeverScrollableScrollPhysics(),
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    pinned: true,
                    floating: true,
                    // snap: true,
                    elevation: 0,
                    iconTheme: const IconThemeData(color: MyColors.black),
                    backgroundColor: Colors.white,
                    bottom: PreferredSize(
                        preferredSize:
                            const Size(double.infinity, kToolbarHeight - 10),
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
                        labelColor: MyColors.primaryColor,
                        unselectedLabelColor: MyColors.black,
                        indicatorColor: MyColors.primaryColor,
                      )))
                ];
              },
              body: ValueListenableBuilder<PodcastState>(
                valueListenable: podcastsNotifier,
                builder: (context, snapshot, _) {
                  if (snapshot.fetched) {
                    List<Products> podcastList = snapshot.products;
                    return TabBarView(children: [
                      PodcastAll(
                        service: service,
                        podcastList: podcastList,
                      ),
                      NotListenedPodcast(
                        podcastList: podcastList,
                        service: service,
                      ),
                      DownloadedPodcast(
                        service: service,
                      ),
                      ListenedPodcast(
                        service: service,
                      )
                    ]);
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

  Future<void> getPodcastList() async {
    await Connection.getPodcastList(context)
        .then((value) => () {
              for (var item in value) {
                service.saveEpisode(item);
              }
            })
        .onError((error, stackTrace) => () {});
    var data = await service.loadEpisodes();
    podcastsNotifier.value = PodcastState(data, true);
  }
}
