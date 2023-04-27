import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/models/products_model.dart';

import 'package:goodali/screens/HomeScreen/courseTab/course_detail.dart';
import 'package:goodali/screens/ProfileScreen/courseLessons.dart/my_course_main.dart';
import 'package:iconly/iconly.dart';

class CourseProductsListItemWeb extends StatefulWidget {
  final Products courseProducts;
  final List<Products> courseProductsList;
  final bool isBought;
  final bool isHomeScreen;
  const CourseProductsListItemWeb(
      {Key? key, required this.courseProducts, this.isBought = false, this.isHomeScreen = false, required this.courseProductsList})
      : super(key: key);

  @override
  State<CourseProductsListItemWeb> createState() => _CourseProductsListItemState();
}

class _CourseProductsListItemState extends State<CourseProductsListItemWeb> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: ImageView(
          imgPath: widget.courseProducts.banner ?? "",
          height: widget.isHomeScreen ? 270 : 360,
          width: double.infinity,
        ),
      ),
      Container(
        height: widget.isHomeScreen ? 270 : 360,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.5),
              Colors.transparent,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
      Container(
        padding: const EdgeInsets.all(20),
        height: widget.isHomeScreen ? 270 : 360,
        child: Column(
          children: [
            Text(
              widget.courseProducts.name ?? "",
              style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            InkWell(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => widget.isBought
                          ? MyCourseMain(
                              courseItem: widget.courseProducts,
                              courseListItem: widget.courseProductsList,
                              isFromHome: widget.isHomeScreen,
                            )
                          : CourseDetail(
                              courseProducts: widget.courseProducts,
                              isHomeScreen: widget.isHomeScreen,
                            ))),
              child: Container(
                height: 40,
                width: 120,
                decoration: BoxDecoration(color: MyColors.input, borderRadius: BorderRadius.circular(6)),
                child: Row(
                  children: const [
                    SizedBox(width: 15),
                    Text(
                      "Цааш үзэх",
                      style: TextStyle(color: MyColors.black, fontWeight: FontWeight.bold),
                    ),
                    // Spacer(),
                    Icon(IconlyLight.arrow_right_2, size: 18),
                    SizedBox(width: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
