import 'package:flutter/material.dart';
import 'package:goodali/Providers/auth_provider.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/models/video_model.dart';
import 'package:goodali/screens/HomeScreen/listenTab/album.dart';
import 'package:goodali/screens/HomeScreen/listenTab/podcast_screen.dart';
import 'package:goodali/screens/HomeScreen/listenTab/podcast_tabs/podcast_all_tab.dart';
import 'package:goodali/screens/HomeScreen/listenTab/video_list.dart';
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
  bool isLoading = false;
  final HiveDataStore dataStore = HiveDataStore();
  @override
  void initState() {
    super.initState();
    getPodcastList();
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
        future: value.isAuth ? getalbumListLogged() : getProducts(),
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
      getProducts();
      getVideoList();

      getPodcastList();
    });
  }

  Future<List<Products>> getProducts() {
    return Connection.getProducts(context, "0");
  }

  Future<List<VideoModel>> getVideoList() {
    return Connection.getVideoList(context);
  }

  Future<List<Products>> getalbumListLogged() {
    return Connection.getalbumListLogged(context);
  }

  Future<void> getPodcastList() async {
    var data = await Connection.getPodcastList(context);

    for (var item in data) {
      dataStore.addProduct(products: item);
    }
  }
}
