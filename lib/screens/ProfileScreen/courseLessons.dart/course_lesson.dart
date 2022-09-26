import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/models/course_lessons_tasks.dart';
import 'package:goodali/screens/ProfileScreen/courseLessons.dart/course_lessons_tasks.dart';

class CourseLessonType extends StatefulWidget {
  final String id;
  final String title;
  const CourseLessonType({Key? key, required this.id, required this.title})
      : super(key: key);

  @override
  State<CourseLessonType> createState() => _CourseLessonTypeState();
}

class _CourseLessonTypeState extends State<CourseLessonType> {
  late final future = getCoursesTasks(widget.id);
  List<CourseLessonsTasksModel> allTasks = [];
  List<String> tasksName = [];
  String taskType = "Унших материал";
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SimpleAppBar(title: widget.title, noCard: true),
        body: FutureBuilder(
          future: future,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData &&
                ConnectionState.done == snapshot.connectionState) {
              List<CourseLessonsTasksModel> taskList = snapshot.data;
              if (taskList.isEmpty) {
                return const Center(
                  child: Text("Хичээл хоосон байна",
                      style: TextStyle(color: MyColors.gray)),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: taskList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => CourseTasks(
                                      title: widget.title,
                                      courseTasks: taskList))),
                          focusColor: MyColors.input,
                          splashColor: MyColors.input,
                          hoverColor: MyColors.input,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            child: Row(
                              children: [
                                Text(
                                    (index + 1).toString() +
                                        ". " +
                                        tasksName[index],
                                    style: const TextStyle(
                                        color: MyColors.black, fontSize: 16)),
                                const Spacer(),
                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          width: 1.5, color: MyColors.border1)),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                );
              }
            } else {
              return const Center(
                  child:
                      CircularProgressIndicator(color: MyColors.primaryColor));
            }
          },
        ));
  }

  Future<List<CourseLessonsTasksModel>> getCoursesTasks(String lessonID) async {
    allTasks = await Connection.getCoursesTasks(context, lessonID);

    setState(() {
      isLoading = false;
    });
    for (var item in allTasks) {
      switch (item.type) {
        case 0:
          taskType = "Унших материал";
          break;
        case 1:
          taskType = "Бичих";
          break;
        case 2:
          taskType = "Сонсох";
          break;
        case 3:
          taskType = "Хийх";
          break;
        case 4:
          taskType = "Үзэх";
          break;
        case 5:
          taskType = "Мэдрэх";
          break;
        case 6:
          taskType = "Судлах";
          break;
        default:
      }

      tasksName.add(taskType);
    }

    return allTasks;
  }
}
