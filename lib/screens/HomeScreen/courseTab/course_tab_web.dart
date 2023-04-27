import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/HomeScreen/header_widget.dart';
import 'package:goodali/screens/ListItems/course_products_item.dart';
import 'package:goodali/screens/ListItems/course_products_item_web.dart';

class CourseTabbarWeb extends StatefulWidget {
  final bool? isHomeScreen;
  const CourseTabbarWeb({Key? key, this.isHomeScreen = true}) : super(key: key);

  @override
  State<CourseTabbarWeb> createState() => _CourseTabbarState();
}

class _CourseTabbarState extends State<CourseTabbarWeb> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isHomeScreen == false ? const SimpleAppBar(noCard: true) : null,
      body: Column(
        children: [
          const Visibility(
            visible: kIsWeb,
            child: HeaderWidget(
              title: 'Онлайн сургалт',
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: FutureBuilder(
                  future: getProducts(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                      List<Products> products = snapshot.data;

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 255, bottom: 60),
                            child: Text("Онлайн сургалт", style: TextStyle(color: MyColors.black, fontSize: 24, fontWeight: FontWeight.bold)),
                          ),
                          onlineCourses(products)
                        ],
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(color: MyColors.primaryColor),
                      );
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Widget onlineCourses(List<Products> products) {
    if (products.isNotEmpty) {
      return kIsWeb
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 255),
              child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 2.5,
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (BuildContext context, int index) => CourseProductsListItemWeb(
                        courseProducts: products[index],
                        courseProductsList: products,
                      )),
            )
          : ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: products.length,
              itemBuilder: (BuildContext context, int index) => CourseProductsListItem(
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
