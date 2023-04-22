import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:goodali/Providers/auth_provider.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/custom_elevated_button.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/models/products_model.dart';

import 'package:goodali/screens/HomeScreen/courseTab/course_list.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourseDetail extends StatefulWidget {
  final Products? courseProducts;
  final int? id;
  const CourseDetail({Key? key, this.courseProducts, this.id}) : super(key: key);

  @override
  State<CourseDetail> createState() => _CourseDetailState();
}

class _CourseDetailState extends State<CourseDetail> {
  Products courseDetail = Products();
  bool isAuth = false;
  String username = "";
  @override
  void initState() {
    getUserName();
    super.initState();
  }

  getUserName() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      username = pref.getString("email") ?? "";
    });
    // print('appbar $username');
  }

  @override
  Widget build(BuildContext context) {
    isAuth = Provider.of<Auth>(context).isAuth;

    return Scaffold(
      appBar: const SimpleAppBar(),
      body: widget.id != null
          ? searchResult()
          : SizedBox(
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * (kIsWeb ? 0.4 : 1),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ImageView(
                                imgPath: widget.courseProducts?.banner ?? "",
                                height: kIsWeb ? 378 : 200,
                                width: double.infinity,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 20),
                                          Text(widget.courseProducts?.name ?? "",
                                              style: const TextStyle(color: MyColors.black, fontSize: 24, fontWeight: FontWeight.bold, height: 1.7)),
                                          const SizedBox(height: 10),
                                          const Text("Цахим сургалт",
                                              style: TextStyle(
                                                color: MyColors.primaryColor,
                                              )),
                                          const SizedBox(height: 20),
                                          HtmlWidget(widget.courseProducts?.body ?? "",
                                              textStyle: const TextStyle(fontSize: 14, height: 1.8, fontFamily: "Gilroy", color: MyColors.gray)),
                                          const SizedBox(height: 30),
                                        ],
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (username != "surgalt9@gmail.com" && isAuth)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: CustomElevatedButton(
                            text: "Худалдаж авах",
                            onPress: () {
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => CourseList(id: widget.courseProducts?.id.toString() ?? "")));
                            },
                          ),
                        ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget searchResult() {
    return FutureBuilder(
      future: getProducts(),
      builder: (BuildContext context, AsyncSnapshot<List<Products>> snapshot) {
        if (snapshot.hasData) {
          List<Products> courseList = snapshot.data ?? [];

          if (courseList.isNotEmpty) {
            for (var item in courseList) {
              if (item.id == widget.id) {
                courseDetail = item;
              }
            }

            return SizedBox(
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * (kIsWeb ? 0.4 : 1),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ImageView(
                                imgPath: courseDetail.banner ?? "",
                                height: kIsWeb ? 378 : 200,
                                width: double.infinity,
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 20),
                                      Text(courseDetail.name ?? "",
                                          style: const TextStyle(color: MyColors.black, fontSize: 24, fontWeight: FontWeight.bold, height: 1.7)),
                                      const SizedBox(height: 10),
                                      const Text("Цахим сургалт",
                                          style: TextStyle(
                                            color: MyColors.primaryColor,
                                          )),
                                      const SizedBox(height: 20),
                                      HtmlWidget(courseDetail.body ?? "",
                                          textStyle: const TextStyle(fontSize: 14, height: 1.8, color: MyColors.gray)),
                                      const SizedBox(height: 30),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ),
                      if (username != "surgalt9@gmail.com" && isAuth)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: CustomElevatedButton(
                            text: "Худалдаж авах",
                            onPress: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => CourseList(id: courseDetail.id.toString())));
                            },
                          ),
                        ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Container();
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
