import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Utils/utils.dart';
import 'package:goodali/Widgets/custom_readmore_text.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/Widgets/top_snack_bar.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/models/course_lessons_model.dart';
import 'package:goodali/models/course_lessons_tasks_model.dart';
import 'package:goodali/models/courses_item.dart';
import 'package:goodali/screens/ProfileScreen/courseLessons.dart/course_lesson.dart';
import 'package:iconly/iconly.dart';

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
  String id = "";

  List<CourseLessonsTasksModel> allTasks = [];

  List<String> tasksName = [];
  bool isLoading = true;

  List<CourseLesson> lessonIdData = [];

  String taskType = "Унших материал";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(noCard: true),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(children: [
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ImageView(
                  imgPath: widget.coursesItems.banner ?? "",
                  width: 190,
                  height: 190),
              //     Container(
              //   color: Colors.blueGrey,
              //   width: 190,
              //   height: 190,
              // )
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
            FutureBuilder(
              future: future,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  List<Lesson?> lessons = snapshot.data;

                  if (lessons.isNotEmpty) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: lessons.length,
                      itemBuilder: (context, index) {
                        int allTasks = lessons[index]?.allTask ?? 0;
                        int doneTasks = lessons[index]?.done ?? 0;

                        String tasks =
                            doneTasks.toString() + "/" + allTasks.toString();

                        return ListTile(
                          iconColor: MyColors.black,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          onTap: () => _openLesson(
                              lessons[index]?.name ?? "",
                              lessons[index]!.id.toString(),
                              lessons[index]!.isBought!),
                          subtitle: Row(children: [
                            Text(
                              tasks,
                              style: const TextStyle(fontSize: 12),
                            ),
                            // const Spacer(),
                            // Text(lessons[index]?.expiry == null ||
                            //         lessons[index]?.expiry == ""
                            //     ? "null"
                            //     : dateTimeFormatter(
                            //         lessons[index]?.expiry ?? "")),
                          ]),
                          trailing: const Icon(IconlyLight.arrow_right_2,
                              size: 18, color: MyColors.gray),
                          title: Text(
                            lessons[index]?.name ?? "",
                            style: const TextStyle(
                              color: MyColors.black,
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
      ),
    );
  }

  Future<void> _refresh() async {
    setState(() {
      getCoursesLessons();
    });
  }

  _openLesson(String name, String id, int isOpened) {
    if (isOpened == 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => CourseLessonType(title: name, id: id)));
    } else {
      TopSnackBar.errorFactory(msg: "Түгжээтэй контент").show(context);
    }
  }

  Future<List<Lesson?>> getCoursesLessons() async {
    List<Lesson?> courseLessons = [];
    courseLessons = await Connection.getCoursesLessons(
        context, widget.coursesItems.id.toString());

    return courseLessons;
  }
}
