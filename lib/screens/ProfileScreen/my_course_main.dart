import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/ProfileScreen/my_courses_detail.dart';
import 'package:goodali/screens/blank.dart';

class MyCourseMain extends StatefulWidget {
  final Products courseItem;
  final List<Products> courseListItem;
  const MyCourseMain(
      {Key? key, required this.courseItem, required this.courseListItem})
      : super(key: key);

  @override
  State<MyCourseMain> createState() => _MyCourseMainState();
}

class _MyCourseMainState extends State<MyCourseMain> {
  String title = 'Очирын бороо';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
            physics: const NeverScrollableScrollPhysics(),
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  pinned: true,
                  floating: true,
                  elevation: 0,
                  iconTheme: const IconThemeData(color: MyColors.black),
                  backgroundColor: Colors.white,
                  bottom: PreferredSize(
                      preferredSize:
                          const Size(double.infinity, kToolbarHeight),
                      child: Container(
                        padding: const EdgeInsets.only(left: 20),
                        alignment: Alignment.topLeft,
                        child: Text(title,
                            style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: MyColors.black)),
                      )),
                ),
              ];
            },
            body: FutureBuilder(
                future: getBoughtCoursesItems(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) =>
                                    const MyCoursesDetail())));
                      },
                      child: ListView.builder(
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Container(
                                    color: Colors.purple,
                                    height: 48,
                                    width: 48,
                                  ),
                                  const SizedBox(width: 15),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                          widget.courseListItem[index].name ??
                                              "",
                                          style: const TextStyle(
                                              color: MyColors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        "4/4 daalgwar",
                                        style: TextStyle(
                                            color: MyColors.gray, fontSize: 12),
                                      )
                                    ],
                                  ),
                                  const Spacer(),
                                  const CircleAvatar(
                                    radius: 11,
                                    backgroundColor: MyColors.success,
                                    child: Icon(
                                      Icons.done,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: MyColors.primaryColor,
                      ),
                    );
                  }
                })));
  }

  Future<List<Products>> getBoughtCoursesItems() async {
    return Connection.getBoughtCoursesItems(
        context, widget.courseItem.id.toString());
  }
}
