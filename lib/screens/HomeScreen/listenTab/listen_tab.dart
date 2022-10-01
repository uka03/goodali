import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:goodali/Providers/auth_provider.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/models/podcast_list_model.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/HomeScreen/listenTab/album.dart';
import 'package:goodali/screens/HomeScreen/listenTab/podcast_screen.dart';
import 'package:goodali/screens/HomeScreen/listenTab/podcast_tabs/podcast_all_tab.dart';
import 'package:goodali/screens/HomeScreen/listenTab/video_list.dart';
import 'package:goodali/screens/ListItems/album_item.dart';
import 'package:goodali/screens/ListItems/podcast_item.dart';
import 'package:goodali/screens/audioScreens.dart/play_audio.dart';
import 'package:iconly/iconly.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

class ListenTabbar extends StatefulWidget {
  const ListenTabbar({Key? key}) : super(key: key);

  @override
  State<ListenTabbar> createState() => _ListenTabbarState();
}

class _ListenTabbarState extends State<ListenTabbar> {
  // late final List<AudioPlayer> audioPlayer = [];
  // late final future = getPodcastList();
  // FileInfo? fileInfo;
  // File? audioFile;
  // int currentIndex = 0;

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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const Podcast()));
                              },
                              icon: const Icon(IconlyLight.arrow_right))
                        ],
                      )),
                  PodcastAll(
                    onTap: (PodcastListModel audioObject) {
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
                                Navigator.push(
                                    context,
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

  // Widget podcast(BuildContext context, List<PodcastListModel> podcastList) {
  //   return ListView.separated(
  //     physics: const NeverScrollableScrollPhysics(),
  //     shrinkWrap: true,
  //     padding: const EdgeInsets.only(bottom: 15),
  //     itemBuilder: (BuildContext context, int index) {
  //       audioPlayer.add(AudioPlayer());
  //       for (var i = 0; i < audioPlayer.length; i++) {
  //         if (currentIndex != i) {
  //           audioPlayer[i].pause();
  //         }
  //       }
  //       return PodcastItem(
  //           podcastItem: podcastList[index],
  //           audioPlayer: audioPlayer[index],
  //           audioPlayerList: audioPlayer,
  //           setIndex: (int index) {
  //             setState(() {
  //               currentIndex = index;
  //             });
  //           });
  //     },
  //     itemCount: podcastList.length,
  //     separatorBuilder: (BuildContext context, int index) => const Divider(
  //       endIndent: 18,
  //       indent: 18,
  //     ),
  //   );
  // }

  Future<List<Products>> getProducts() {
    return Connection.getProducts(context, "0");
  }

  Future<List<Products>> getalbumListLogged() {
    return Connection.getalbumListLogged(context);
  }

  Future<List<PodcastListModel>> getPodcastList() {
    return Connection.getPodcastList(context);
  }
}
