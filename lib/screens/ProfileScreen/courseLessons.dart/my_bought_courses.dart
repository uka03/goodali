import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Utils/urls.dart';
import 'package:goodali/controller/audioplayer_controller.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/controller/default_audio_handler.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/ListItems/album_detail_item.dart';
import 'package:goodali/screens/ListItems/course_products_item.dart';
import 'package:just_audio/just_audio.dart';

typedef OnTap = Function(Products products);

class MyCourses extends StatefulWidget {
  final OnTap onTap;
  const MyCourses({Key? key, required this.onTap}) : super(key: key);

  @override
  State<MyCourses> createState() => _MyCoursesState();
}

class _MyCoursesState extends State<MyCourses> {
  AudioPlayerController audioPlayerController = AudioPlayerController();
  List<Products> allLectures = [];
  List<MediaItem> mediaItems = [];
  String albumName = "";
  int currentIndex = 0;
  List<int> savedPos = [];

  @override
  void initState() {
    getAllLectures();
    super.initState();
  }

  onPlayButtonClicked(int index) async {
    if (activeList.first.title == allLectures.first.title &&
        activeList.first.id == allLectures.first.id) {
      await audioHandler.skipToQueueItem(index);
      await audioHandler.seek(
        Duration(milliseconds: allLectures[index].position!),
      );
      await audioHandler.play();
      currentlyPlaying.value = allLectures[index];
    } else if (activeList.first.title != allLectures.first.title ||
        activeList.first.id != allLectures.first.id) {
      activeList = allLectures;
      await initiliazePodcast();
      await audioHandler.skipToQueueItem(index);
      await audioHandler.seek(
        Duration(milliseconds: allLectures[index].position!),
      );
      await audioHandler.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([getAllLectures(), getBoughtCourses()]),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          allLectures = snapshot.data[0];
          List<Products> myCourses = snapshot.data[1];
          List<Products> allListProducts = [...allLectures, ...myCourses];

          if (allListProducts.isEmpty) {
            return Column(
              children: [
                const SizedBox(height: 80),
                SvgPicture.asset("assets/images/empty_bought.svg"),
                const SizedBox(height: 20),
                const Text(
                  "Авсан бүтээгдэхүүн байхгүй...",
                  style: TextStyle(fontSize: 14, color: MyColors.gray),
                ),
              ],
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    onlineCourses(myCourses),
                    const SizedBox(height: 10),
                    allLecturesWidget(allLectures),
                  ],
                ),
              ),
            );
          }
        } else {
          return const Center(
              child: CircularProgressIndicator(color: MyColors.primaryColor));
        }
      },
    );
  }

  Widget allLecturesWidget(List<Products> allLectures) {
    if (allLectures.isEmpty) {
      return Container();
    } else {
      return ListView.builder(
          itemCount: allLectures.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            String empty = "";
            if (albumName == allLectures[index].albumTitle) {
              empty = "";
            } else {
              empty = albumName;
            }
            if (albumName != allLectures[index].albumTitle) {
              albumName = allLectures[index].albumTitle ?? "";
              empty = albumName;
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(empty,
                    style: const TextStyle(
                        color: MyColors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                AlbumDetailItem(
                    index: index,
                    isBought: true,
                    products: allLectures[index],
                    albumName: albumName,
                    productsList: allLectures,
                    onTap: () {
                      onPlayButtonClicked(index);
                    }),
              ],
            );
          });
    }
  }

  Widget onlineCourses(List<Products> myCourses) {
    if (myCourses.isEmpty) {
      return Container();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Text("Онлайн сургалт",
              style: TextStyle(
                  color: MyColors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: myCourses.length,
              itemBuilder: (BuildContext context, int index) {
                return CourseProductsListItem(
                    isBought: true,
                    courseProducts: myCourses[index],
                    courseProductsList: myCourses);
              }),
        ],
      );
    }
  }

  Future<List<Products>> getAllLectures() async {
    allLectures = await Connection.getAllLectures(context);
    // _initiliazeLecture(allLectures);
    return allLectures;
  }

  Future<List<Products>> getBoughtCourses() async {
    return Connection.getBoughtCourses(context);
  }
}
