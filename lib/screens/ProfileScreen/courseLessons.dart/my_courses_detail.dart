import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/custom_readmore_text.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/models/course_lessons_model.dart';
import 'package:goodali/models/course_lessons_tasks.dart';
import 'package:goodali/models/courses_item.dart';
import 'package:goodali/screens/ProfileScreen/courseLessons.dart/course_lessons_tasks.dart';
import 'package:video_player/video_player.dart';

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
  late final Future future = getCoursesLessons();

  int type = 0;

  List<CourseLessonsTasksModel> allTasks = [];
  List<String> tasksName = [];
  bool isLoading = true;

  String taskType = "Унших материал";

  @override
  void initState() {
    super.initState();
  }

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
                text:
                    "Чиний амьдралыг уг үндсээр нь хувиргах трансформац-хөтөлбөрийн эхний бүлгийг нээж байгаад баяр хүргэе! Удиртгал хэсгийг уншаагүй бол заавал уншихыг зөвлөж ",
                textAlign: TextAlign.center,
              )),
          const SizedBox(height: 10),
          const Divider(endIndent: 20, indent: 20),
          FutureBuilder(
            future: future,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                List<CourseLessons> courseLessons = snapshot.data;
                if (courseLessons.isNotEmpty) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: courseLessons.length,
                    itemBuilder: (context, index) {
                      return Card(
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 36.0, left: 6.0, right: 6.0, bottom: 6.0),
                            child: ExpansionTile(
                                collapsedIconColor: MyColors.gray,
                                collapsedTextColor: MyColors.gray,
                                iconColor: MyColors.gray,
                                textColor: MyColors.gray,
                                onExpansionChanged: (value) {
                                  if (value) {
                                    getCoursesTasks(
                                        courseLessons[index].id.toString());
                                  }
                                },
                                title: Text(courseLessons[index].name ?? ""),
                                children: [
                                  ListTile(
                                    title: const Text("Унших"),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CourseReadingTasks(
                                                      courseReadingTasks:
                                                          allTasks,
                                                      title:
                                                          courseLessons[index]
                                                              .name)));
                                    },
                                  ),
                                  ListTile(
                                    title: const Text("Бичих"),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CourseReadingTasks(
                                                      courseReadingTasks:
                                                          allTasks,
                                                      title:
                                                          courseLessons[index]
                                                              .name)));
                                    },
                                  ),
                                  ListTile(
                                    title: const Text("Сонсох"),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CourseReadingTasks(
                                                      courseReadingTasks:
                                                          allTasks,
                                                      title:
                                                          courseLessons[index]
                                                              .name)));
                                    },
                                  ),
                                  ListTile(
                                    title: const Text("Хийх"),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CourseReadingTasks(
                                                      courseReadingTasks:
                                                          allTasks,
                                                      title:
                                                          courseLessons[index]
                                                              .name)));
                                    },
                                  ),
                                  ListTile(
                                    title: const Text("Үзэх"),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CourseReadingTasks(
                                                      courseReadingTasks:
                                                          allTasks,
                                                      title:
                                                          courseLessons[index]
                                                              .name)));
                                    },
                                  ),
                                  ListTile(
                                    title: const Text("Мэдрэх"),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CourseReadingTasks(
                                                      courseReadingTasks:
                                                          allTasks,
                                                      title:
                                                          courseLessons[index]
                                                              .name)));
                                    },
                                  ),
                                  ListTile(
                                    title: const Text("Судлах"),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CourseReadingTasks(
                                                      courseReadingTasks:
                                                          allTasks,
                                                      title:
                                                          courseLessons[index]
                                                              .name)));
                                    },
                                  ),
                                ]),
                          ));
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

  Future<List<CourseLessonsTasksModel>> getCoursesTasks(String id) async {
    print("course lessons tasks $id");
    allTasks = await Connection.getCoursesTasks(
        context, widget.coursesItems.id.toString());
    print("kdffh ${allTasks.length}");
    setState(() {
      isLoading = false;
    });
    for (var item in allTasks) {
      if (item.type == 0 ||
          item.type == 2 ||
          item.type == 3 ||
          item.type == 5 ||
          item.type == 6) {
        taskType = "Унших материал";
      } else if (item.type == 1) {
        taskType = "Сонсох";
      } else if (item.type == 4) {
        taskType = "Видео";
      }
      tasksName.add(taskType);
      tasksName = tasksName.toSet().toList();
    }

    return allTasks;
  }
}
