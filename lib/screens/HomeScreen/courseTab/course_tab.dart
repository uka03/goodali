import 'package:flutter/material.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/models/products_model.dart';

import 'package:goodali/screens/ListItems/course_products_item.dart';

class CourseTabbar extends StatefulWidget {
  const CourseTabbar({Key? key}) : super(key: key);

  @override
  State<CourseTabbar> createState() => _CourseTabbarState();
}

class _CourseTabbarState extends State<CourseTabbar> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 30.0, bottom: 20),
              child: Text("Онлайн сургалт",
                  style: TextStyle(
                      color: MyColors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
            ),
            onlineCourses()
          ],
        ),
      ),
    );
  }

  Widget onlineCourses() {
    return FutureBuilder(
      future: getProducts(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          List<Products> products = snapshot.data;
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
        } else {
          return const Center(
            child: CircularProgressIndicator(color: MyColors.primaryColor),
          );
        }
      },
    );
  }

  Future<List<Products>> getProducts() {
    return Connection.getProducts(context, "2");
  }
}
