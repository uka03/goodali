import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Utils/utils.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/ListItems/album_detail_item.dart';
import 'package:goodali/screens/ListItems/course_products_item.dart';
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
      future: Future.wait([getAllLectures(), getBoughtCourses()]),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<Products> allLectures = snapshot.data[0];
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
                  isBought: true,
                  products: allLectures[index],
                  albumName: albumName,
                  productsList: allLectures),
            ],
          );
        });
  }

  Widget onlineCourses(List<Products> myCourses) {
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
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) {
              return CourseProductsListItem(
                  isBought: true,
                  courseProducts: myCourses[index],
                  courseProductsList: myCourses);
            }),
      ],
    );
  }

  Future<List<Products>> getAllLectures() async {
    return Connection.getAllLectures(context);
  }

  Future<List<Products>> getBoughtCourses() async {
    return Connection.getBoughtCourses(context);
  }
}
