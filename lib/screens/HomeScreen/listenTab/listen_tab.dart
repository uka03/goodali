import 'package:flutter/material.dart';
import 'package:goodali/Providers/auth_provider.dart';
import 'package:goodali/Widgets/audioplayer_timer.dart';
import 'package:goodali/Widgets/custom_readmore_text.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/models/video_model.dart';
import 'package:goodali/screens/HomeScreen/listenTab/album.dart';
import 'package:goodali/screens/HomeScreen/listenTab/album_detail.dart';
import 'package:goodali/screens/HomeScreen/listenTab/podcast_screen.dart';
import 'package:goodali/screens/HomeScreen/listenTab/podcast_tabs/podcast_all_tab.dart';
import 'package:goodali/screens/HomeScreen/listenTab/video_list.dart';
import 'package:goodali/screens/ListItems/album_detail_item.dart';
import 'package:goodali/screens/ListItems/album_item.dart';
import 'package:goodali/screens/ListItems/video_item.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../../Providers/local_database.dart';

class ListenTabbar extends StatefulWidget {
  const ListenTabbar({Key? key}) : super(key: key);

  @override
  State<ListenTabbar> createState() => _ListenTabbarState();
}

class _ListenTabbarState extends State<ListenTabbar>
    with AutomaticKeepAliveClientMixin<ListenTabbar> {
  @override
  bool get wantKeepAlive => true;
  bool isLoading = true;

  late final futureAlbum = getProducts();
  late final futurLoggedeAlbum = getalbumListLogged();
  final HiveDataStore dataStore = HiveDataStore();
  List<Products> specialList = [];
  @override
  void initState() {
    getPodcastList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: _refresh,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < specialList.length; i++)
              if (specialList[i].isSpecial == 1)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => AlbumDetail(
                                albumProduct: specialList[i], onTap: (d) {})));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Онцлох",
                              style: TextStyle(
                                  color: MyColors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                          Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          child: ImageView(
                                              imgPath:
                                                  specialList[i].banner ?? "",
                                              width: 40,
                                              height: 40)),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              specialList[i].lectureTitle !=
                                                          null &&
                                                      specialList[i]
                                                          .lectureTitle!
                                                          .isNotEmpty
                                                  ? specialList[i].lectureTitle!
                                                  : specialList[i].title ?? "",
                                              maxLines: 1,
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  color: MyColors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 10),
                                            CustomReadMoreText(
                                                text: specialList[i].body ?? "")
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              )),
                        ]),
                  ),
                ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Цомог лекц",
                      style: TextStyle(
                          color: MyColors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const AlbumLecture()));
                      },
                      child: const Icon(IconlyLight.arrow_right))
                ],
              ),
            ),
            albumLecture(),
            Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Подкаст",
                        style: TextStyle(
                            color: MyColors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => Podcast(
                                        dataStore: dataStore,
                                      )));
                        },
                        child: const Icon(IconlyLight.arrow_right))
                  ],
                )),
            ValueListenableBuilder(
              valueListenable: HiveDataStore.box.listenable(),
              builder: (context, Box box, widget) {
                if (box.length > 0) {
                  List<Products> data = [];
                  for (int a = 0; a < box.length; a++) {
                    data.add(box.getAt(a));
                  }
                  return PodcastAll(
                    isHomeScreen: true,
                    podcastList: data,
                  );
                } else {
                  return const Center(
                    child:
                        CircularProgressIndicator(color: MyColors.primaryColor),
                  );
                }
              },
            ),
            Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Видео",
                        style: TextStyle(
                            color: MyColors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const VideoList()));
                        },
                        child: const Icon(IconlyLight.arrow_right))
                  ],
                )),
            videoList()
          ],
        ),
      ),
    );
  }

  Widget albumLecture() {
    return Consumer<Auth>(
      builder: (context, value, child) => FutureBuilder(
        future: value.isAuth ? futurLoggedeAlbum : futureAlbum,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            List<Products> albumList = snapshot.data;

            return GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 4,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 15,
                    childAspectRatio: 1 / 1.6,
                    crossAxisCount: 2),
                itemBuilder: (BuildContext context, int index) =>
                    AlbumItem(albumData: albumList[index]));
          } else {
            return const Center(
              child: CircularProgressIndicator(color: MyColors.primaryColor),
            );
          }
        },
      ),
    );
  }

  Widget videoList() {
    return FutureBuilder(
      future: getVideoList(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          List<VideoModel> videoList = snapshot.data;
          return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: videoList.length > 3 ? 3 : videoList.length,
              itemBuilder: (BuildContext context, int index) =>
                  VideoItem(videoModel: videoList[index]));
        } else {
          return const Center(
            child: CircularProgressIndicator(color: MyColors.primaryColor),
          );
        }
      },
    );
  }

  Future<void> _refresh() async {
    setState(() {
      getVideoList();
      getPodcastList();
    });
  }

  Future<List<Products>> getProducts() async {
    var data = await Connection.getProducts(context, "0");
    for (var element in data) {
      if (element.isSpecial == 1) {
        specialList.add(element);
      }
    }
    if (mounted) {
      setState(() {
        specialList;
      });
    }
    return data;
  }

  Future<List<VideoModel>> getVideoList() {
    return Connection.getVideoList(context);
  }

  Future<List<Products>> getalbumListLogged() async {
    var data = await Connection.getalbumListLogged(context);
    for (var element in data) {
      if (element.isSpecial == 1) {
        specialList.add(element);
      }
    }
    if (mounted) {
      setState(() {
        specialList;
      });
    }
    return data;
  }

  Future<void> getPodcastList() async {
    var data = await Connection.getPodcastList(context);

    for (var item in data) {
      dataStore.addProduct(products: item);
    }
  }
}
