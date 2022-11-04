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
    return SingleChildScrollView(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 30.0, bottom: 20, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Цомог лекц",
                  style: TextStyle(
                      color: MyColors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const AlbumLecture()));
                  },
                  icon: const Icon(IconlyLight.arrow_right))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: albumLecture(),
        ),
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
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => Podcast(
                                    dataStore: dataStore,
                                  )));
                    },
                    icon: const Icon(IconlyLight.arrow_right))
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
                child: CircularProgressIndicator(color: MyColors.primaryColor),
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
                IconButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const VideoList()));
                    },
                    icon: const Icon(IconlyLight.arrow_right))
              ],
            )),
        videoList()
      ],
    ));
  }

  Widget albumLecture() {
    return Consumer<Auth>(
      builder: (context, value, child) => FutureBuilder(
        future: value.isAuth ? getalbumListLogged() : getProducts(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            List<Products> albumList = snapshot.data;
            return SizedBox(
              height: 220,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: albumList.length,
                  itemBuilder: (BuildContext context, int index) => Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: AlbumItem(albumData: albumList[index]),
                      )),
            );
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
