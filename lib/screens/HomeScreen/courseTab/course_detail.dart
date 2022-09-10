import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/custom_elevated_button.dart';
import 'package:goodali/Widgets/info.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/models/products_model.dart';

import 'package:goodali/screens/HomeScreen/courseTab/course_list.dart';

class CourseDetail extends StatefulWidget {
  final Products courseProducts;
  const CourseDetail({Key? key, required this.courseProducts})
      : super(key: key);

  @override
  State<CourseDetail> createState() => _CourseDetailState();
}

class _CourseDetailState extends State<CourseDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const SimpleAppBar(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.yellowAccent,
                  child: Center(
                    child: Text("Error while fetching image"),
                  )),
              // ImageViewer(
              //   imgPath: widget.courseProducts.banner ?? "",
              //   height: 200,
              // )
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Text(widget.courseProducts.title ?? "",
                          style: const TextStyle(
                              color: MyColors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              height: 1.7)),
                      const SizedBox(height: 10),
                      const Text("Цахим сургалт",
                          style: TextStyle(
                            color: MyColors.primaryColor,
                          )),
                      const SizedBox(height: 20),
                      HtmlWidget(widget.courseProducts.body ?? "",
                          textStyle: const TextStyle(
                              fontSize: 14, height: 1.8, color: MyColors.gray)),

                      // const CircleAvatar(
                      //   radius: 70,
                      //   backgroundColor: MyColors.border2,
                      // ),
                      // const SizedBox(height: 30),
                      // const Text(
                      //   "Цогтын Амгалан",
                      //   style: TextStyle(
                      //       fontSize: 20,
                      //       color: MyColors.black,
                      //       fontWeight: FontWeight.bold),
                      // ),
                      // const SizedBox(height: 10),
                      // const Text("Удирдагч багш",
                      //     style: TextStyle(
                      //         fontSize: 12, color: MyColors.primaryColor)),
                      // const SizedBox(height: 20),
                      // const Align(
                      //   alignment: Alignment.topLeft,
                      //   child: Text("* Setgel sudlaach",
                      //       style: TextStyle(color: MyColors.black)),
                      // ),
                      const SizedBox(height: 30),
                      CustomElevatedButton(
                        text: "Худалдаж авах",
                        onPress: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CourseList(
                                      id: widget.courseProducts.id
                                          .toString())));
                        },
                      ),
                      const SizedBox(height: 30),
                    ],
                  )),
            ],
          ),
        ));
  }
}
