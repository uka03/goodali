import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/image_viewer.dart';
import 'package:goodali/models/products_model.dart';

import 'package:goodali/screens/HomeScreen/courseTab/course_detail.dart';
import 'package:iconly/iconly.dart';

class CourseProductsListItem extends StatefulWidget {
  final Products courseProducts;
  const CourseProductsListItem({Key? key, required this.courseProducts})
      : super(key: key);

  @override
  State<CourseProductsListItem> createState() => _CourseProductsListItemState();
}

class _CourseProductsListItemState extends State<CourseProductsListItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Stack(children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12), color: Colors.pink[100]),
          height: 170,
          width: double.infinity,
          child: Text("error while fetching image"),
        ),
        // ImageViewer(imgPath: widget.courseProducts.banner ?? "")
        Positioned(
          left: 20,
          top: 30,
          child: Text(
            widget.courseProducts.name ?? "",
            style: const TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),

        // Positioned(
        //   left: 20,
        //   top: 62,
        //   child: Row(
        //     children: [
        //      const Text(
        //         "Эхлэх огноо:",
        //         style: TextStyle(color: Colors.white),
        //       ),
        //       Text(
        //         " 2022.06.18",
        //         style:
        //             TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        //       ),
        //     ],
        //   ),
        // ),
        Positioned(
          bottom: 20,
          left: 20,
          child: GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        CourseDetail(courseProducts: widget.courseProducts))),
            // MaterialPageRoute(
            //     builder: (_) =>
            //         CourseList(id: widget.products.id.toString()))),
            child: Container(
              height: 40,
              width: 120,
              decoration: BoxDecoration(
                  color: MyColors.input,
                  borderRadius: BorderRadius.circular(6)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Text(
                    "Цааш үзэх",
                    style: TextStyle(
                        color: MyColors.black, fontWeight: FontWeight.bold),
                  ),
                  Icon(IconlyLight.arrow_right_2)
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }
}
