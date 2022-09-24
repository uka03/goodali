import 'package:flutter/material.dart';
import 'package:goodali/Providers/auth_provider.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/HomeScreen/listenTab/album.dart';
import 'package:goodali/screens/HomeScreen/listenTab/podcast_screen.dart';
import 'package:goodali/screens/HomeScreen/listenTab/video_list.dart';
import 'package:goodali/screens/ListItems/album_item.dart';
import 'package:goodali/screens/ProfileScreen/courseLessons.dart/my_course_main.dart';
import 'package:goodali/screens/ProfileScreen/courseLessons.dart/my_courses_detail.dart';
import 'package:goodali/screens/intro_screen.dart';
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                      padding: const EdgeInsets.only(top: 30.0, bottom: 20),
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
                    albumLecture(context, albumList!),
                    // Padding(
                    //     padding: const EdgeInsets.symmetric(vertical: 20.0),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         const Text("Подкаст",
                    //             style: TextStyle(
                    //                 color: MyColors.black,
                    //                 fontSize: 24,
                    //                 fontWeight: FontWeight.bold)),
                    //         IconButton(
                    //             onPressed: () {
                    //               // Navigator.push(
                    //               //     context,
                    //               //     MaterialPageRoute(
                    //               //         builder: (_) => const MyCourseMain()));
                    //             },
                    //             icon: const Icon(IconlyLight.arrow_right))
                    //       ],
                    //     )),
                    // podcast(context),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
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
                  child:
                      CircularProgressIndicator(color: MyColors.primaryColor),
                );
              }
            },
          ),
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

  Widget podcast(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.only(bottom: 15),
      itemBuilder: (BuildContext context, int index) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(6)),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "#25 Гоо Даль-ийн дэвэлт...",
                        maxLines: 1,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: MyColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Энэ хэсэгт аудио подкастын тайлбар байна. Аудиог огт тоглуулаагүй, эхлүүлээгүй байвал ингэж харагдана, текст багтахгүй хэтэрсэн бол...",
                        style: TextStyle(
                          color: MyColors.gray,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: MyColors.input,
                  child: IconButton(
                    splashRadius: 20,
                    padding: EdgeInsets.zero,
                    onPressed: () {},
                    icon: const Icon(
                      Icons.play_arrow_rounded,
                      size: 30,
                      color: MyColors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text('1 цаг 25 мин',
                    style: TextStyle(fontSize: 12, color: MyColors.black)),
                Spacer(),
                IconButton(
                    splashRadius: 20,
                    onPressed: () {},
                    icon: Icon(IconlyLight.arrow_down, color: MyColors.gray)),
                IconButton(
                    splashRadius: 20,
                    onPressed: () {},
                    icon: Icon(Icons.more_horiz, color: MyColors.gray)),
              ],
            ),
            const SizedBox(height: 12)
          ],
        );
      },
      itemCount: 3,
      separatorBuilder: (BuildContext context, int index) => const Divider(
        endIndent: 18,
        indent: 18,
      ),
    );
  }

  Future<List<Products>> getProducts() {
    return Connection.getProducts(context, "0");
  }

  Future<List<Products>> getalbumListLogged() {
    return Connection.getalbumListLogged(context);
  }
}
