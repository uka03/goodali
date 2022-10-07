import 'package:flutter/material.dart';
import 'package:goodali/Providers/auth_provider.dart';
import 'package:goodali/controller/audioplayer_controller.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/HomeScreen/listenTab/album.dart';
import 'package:goodali/screens/HomeScreen/listenTab/podcast_screen.dart';
import 'package:goodali/screens/HomeScreen/listenTab/podcast_tabs/podcast_all_tab.dart';
import 'package:goodali/screens/HomeScreen/listenTab/video_list.dart';
import 'package:goodali/screens/ListItems/album_item.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class ListenTabbar extends StatefulWidget {
  const ListenTabbar({Key? key}) : super(key: key);

  @override
  State<ListenTabbar> createState() => _ListenTabbarState();
}

class _ListenTabbarState extends State<ListenTabbar> {
  List<Products>? albumList;
  List<Products> audioLength = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer<Auth>(
        builder: (context, value, child) => FutureBuilder(
          future: value.isAuth ? getalbumListLogged() : getProducts(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              albumList = snapshot.data;

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 30.0, bottom: 20, left: 20, right: 20),
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
                              Navigator.of(context, rootNavigator: true).push(
                                  MaterialPageRoute(
                                      builder: (_) => const AlbumLecture()));
                            },
                            icon: const Icon(IconlyLight.arrow_right))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: albumLecture(context, albumList!),
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
                                Navigator.of(context, rootNavigator: true).push(
                                    MaterialPageRoute(
                                        builder: (_) => const Podcast()));
                              },
                              icon: const Icon(IconlyLight.arrow_right))
                        ],
                      )),
                  PodcastAll(
                    onTap: (Products audioObject, List<Products> podcastList) {
                      currentlyPlaying.value = audioObject;
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
                                Navigator.of(context, rootNavigator: true).push(
                                    MaterialPageRoute(
                                        builder: (_) => const VideoList()));
                              },
                              icon: const Icon(IconlyLight.arrow_right))
                        ],
                      )),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(color: MyColors.primaryColor),
              );
            }
          },
        ),
      ),
    );
  }

  Widget albumLecture(BuildContext context, List<Products> albumList) {
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
  }

  Future<List<Products>> getProducts() {
    return Connection.getProducts(context, "0");
  }

  Future<List<Products>> getalbumListLogged() {
    return Connection.getalbumListLogged(context);
  }

  Future<List<Products>> getPodcastList() {
    return Connection.getPodcastList(context);
  }
}
