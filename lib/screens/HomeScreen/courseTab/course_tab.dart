import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/ListItems/article_item.dart';

import 'package:goodali/screens/ListItems/course_products_item.dart';

class CourseTabbar extends StatefulWidget {
  final bool? isHomeScreen;
  const CourseTabbar({Key? key, this.isHomeScreen = true}) : super(key: key);

  @override
  State<CourseTabbar> createState() => _CourseTabbarState();
}

class _CourseTabbarState extends State<CourseTabbar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isHomeScreen == false
          ? const SimpleAppBar(noCard: true)
          : null,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: FutureBuilder(
              future: getProducts(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  List<Products> products = snapshot.data;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var item in products)
                        if (item.isSpecial == 1)
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                const Text("Онцлох",
                                    style: TextStyle(
                                        color: MyColors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: CourseProductsListItem(
                                      courseProducts: item,
                                      courseProductsList: products,
                                    )),
                              ]),
                      const Padding(
                        padding: EdgeInsets.only(top: 30.0, bottom: 20),
                        child: Text("Онлайн сургалт",
                            style: TextStyle(
                                color: MyColors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold)),
                      ),
                      onlineCourses(products)
                    ],
                  );
                } else {
                  return const Center(
                    child:
                        CircularProgressIndicator(color: MyColors.primaryColor),
                  );
                }
              }),
        ),
      ),
    );
  }

  Widget onlineCourses(List<Products> products) {
    if (products.isNotEmpty) {
      return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: products.length,
          itemBuilder: (BuildContext context, int index) =>
              CourseProductsListItem(
                courseProducts: products[index],
                courseProductsList: products,
              ));
    } else {
      return Center(
        child: Container(
            margin: const EdgeInsets.only(top: 100),
            child: const Text(
              "",
              style: TextStyle(color: MyColors.gray, fontSize: 16),
            )),
      );
    }
  }

  Future<List<Products>> getProducts() {
    return Connection.getProducts(context, "2");
  }
}
