import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/custom_readmore_text.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/models/course_lessons_model.dart';
import 'package:goodali/models/courses_item.dart';

class MyCoursesDetail extends StatefulWidget {
  final CoursesItems coursesItems;
  final String lessonName;
  final String? body;
  const MyCoursesDetail(
      {Key? key,
      required this.coursesItems,
      required this.lessonName,
      this.body})
      : super(key: key);

  @override
  State<MyCoursesDetail> createState() => _MyCoursesDetailState();
}

class _MyCoursesDetailState extends State<MyCoursesDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(noCard: true),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(children: [
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: ImageView(
                imgPath: widget.coursesItems.banner ?? "",
                width: 190,
                height: 190),
          ),
          const SizedBox(height: 20),
          Text(
            widget.lessonName,
            style: const TextStyle(
                fontSize: 20,
                color: MyColors.black,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomReadMoreText(
                text: "widget.coursesItems. ??",
                textAlign: TextAlign.center,
              )),
          const SizedBox(height: 10),
          const Divider(endIndent: 20, indent: 20),
          FutureBuilder(
            future: getCoursesLessons(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                List<CourseLessons> courseLessons = snapshot.data;
                if (courseLessons.isNotEmpty) {
                  return ListView.builder(
                    itemCount: courseLessons.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 0,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 36.0, left: 6.0, right: 6.0, bottom: 6.0),
                          child: ExpansionTile(
                            title: Text(courseLessons[index].name ?? ""),
                            children: <Widget>[
                              Text('Big Bang'),
                              Text('Birth of the Sun'),
                              Text('Earth is Born'),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Container();
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    color: MyColors.primaryColor,
                  ),
                );
              }
            },
          )
        ]),
      ),
    );
  }

  Future<List<CourseLessons>> getCoursesLessons() async {
    return Connection.getCoursesLessons(
        context, widget.coursesItems.id.toString());
  }
}
