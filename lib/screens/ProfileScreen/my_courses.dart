import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/ListItems/album_detail_item.dart';
import 'package:goodali/screens/ProfileScreen/my_online_course.dart';
import 'package:iconly/iconly.dart';

class MyCourses extends StatefulWidget {
  const MyCourses({Key? key}) : super(key: key);

  @override
  State<MyCourses> createState() => _MyCoursesState();
}

class _MyCoursesState extends State<MyCourses> {
  String albumName = "";
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([getAllLectures()]),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          // List<Products> myAlbums = snapshot.data[0];
          List<Products> allLectures = snapshot.data[0];
          List<Products> allListProducts = [...allLectures];

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  allLecturesWidget(allLectures)
                ],
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

  Widget albums(List<Products> myAlbums) {
    return ListView.builder(
        itemCount: myAlbums.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: ((context, index) {
          albumName = myAlbums[index].title ?? "";
          return Text(myAlbums[index].title ?? "",
              style: const TextStyle(
                  color: MyColors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold));
        }));
  }

  Widget allLecturesWidget(List<Products> allLectures) {
    return ListView.builder(
        itemCount: allLectures.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          if (albumName != allLectures[index].albumTitle) {
            albumName = allLectures[index].albumTitle ?? "fff";
          }
          // albumName = allLectures[index].albumTitle ?? "fff";
          print("albumName $albumName");
          print(allLectures[index].albumTitle);
          return Column(
            children: [
              if (albumName == allLectures[index].albumTitle) Text(albumName),
              AlbumDetailItem(
                  isBought: true,
                  products: allLectures[index],
                  albumName: albumName,
                  productsList: allLectures),
            ],
          );
        });
  }

  Widget onlineCourses() {
    return Column(
      children: [
        const SizedBox(height: 10),
        const Text("Онлайн сургалт",
            textAlign: TextAlign.left,
            style: TextStyle(
                color: MyColors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Stack(children: [
                  Container(
                    height: 170,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.pink[300],
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  Positioned(
                    left: 20,
                    top: 30,
                    child: Text(
                      "Очирын бороо",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    top: 62,
                    child: Row(
                      children: [
                        Text(
                          "Эхлэх огноо:",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          " 2022.06.18",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const MyOnlineCourse())),
                      child: Container(
                        height: 40,
                        width: 130,
                        decoration: BoxDecoration(
                            color: MyColors.input,
                            borderRadius: BorderRadius.circular(6)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              " Дэлгэрэнгүй",
                              style: TextStyle(
                                  color: MyColors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            Icon(IconlyLight.arrow_right_2)
                          ],
                        ),
                      ),
                    ),
                  )
                ]),
              );
            }),
      ],
    );
  }

  Future<List<Products>> getBougthAlbums() {
    return Connection.getBougthAlbums(context);
  }

  Future<List<Products>> getAllLectures() async {
    return Connection.getAllLectures(context);
  }
}
