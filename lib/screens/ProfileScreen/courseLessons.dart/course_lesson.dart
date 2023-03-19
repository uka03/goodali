import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/models/course_lessons_tasks_model.dart';
import 'package:goodali/screens/ProfileScreen/courseLessons.dart/course_lessons_tasks.dart';

class CourseLessonType extends StatefulWidget {
  final String id;
  final String title;
  final String banner;
  final String lessonName;
  const CourseLessonType({Key? key, required this.id, required this.title, required this.banner, required this.lessonName}) : super(key: key);

  @override
  State<CourseLessonType> createState() => _CourseLessonTypeState();
}

class _CourseLessonTypeState extends State<CourseLessonType> {
  List<CourseLessonsTasksModel> taskList = [];
  double initialPage = 0;
  List<CourseLessonsTasksModel> allTasks = [];
  List<String> tasksName = [];
  String taskType = "Унших материал";
  bool isLoading = true;

  @override
  void initState() {
    getCoursesTasks(widget.id);
    super.initState();
  }

  Future<void> _refresh() async {
    setState(() {
      getCoursesTasks(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SimpleAppBar(title: widget.title, noCard: true),
        body: isLoading
            ? const Center(child: CircularProgressIndicator(color: MyColors.primaryColor))
            : taskList.isEmpty
                ? const Center(
                    child: Text("Хичээл хоосон байна", style: TextStyle(color: MyColors.gray)),
                  )
                : RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: taskList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                              onTap: () => _onTap(index),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                              title:
                                  Text((index + 1).toString() + ". " + tasksName[index], style: const TextStyle(color: MyColors.black, fontSize: 16)),
                              subtitle: taskList[index].isAnswered == 0
                                  ? const Text("Хийгээгүй", style: TextStyle(fontSize: 12, color: MyColors.gray))
                                  : const Text("Дууссан", style: TextStyle(fontSize: 12, color: MyColors.gray)),
                              trailing: taskList[index].isAnswered == 0
                                  ? SvgPicture.asset("assets/images/undone_icon.svg")
                                  : SvgPicture.asset("assets/images/done_icon.svg"));
                        }),
                  ));
  }

  _onTap(int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => CourseTasks(
                  initialPage: index.toDouble(),
                  title: widget.title,
                  courseTasks: taskList,
                  banner: widget.banner,
                  lessonName: widget.lessonName,
                ))).then((value) {
      if (value != null) {
        initialPage = value;
      }
      if (mounted) {
        setState(() {
          getCoursesTasks(widget.id);
        });
      }
    });
  }

  Future<List<CourseLessonsTasksModel>> getCoursesTasks(String lessonID) async {
    // print("set hiij bga yu");
    allTasks = await Connection.getCoursesTasks(context, lessonID);
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
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

    for (var i = 0; i < allTasks.length; i++) {
      log('[CourseLessonType] {getCoursesTasks} answerData[$i]: ${allTasks[i].answerData}');
    }
    if (mounted) {
      setState(() {
        taskList = allTasks;
      });
    }

    return allTasks;
  }
}
