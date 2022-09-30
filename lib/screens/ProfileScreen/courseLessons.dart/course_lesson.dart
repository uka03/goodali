import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/models/course_lessons_tasks_model.dart';
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
  // late final future =
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SimpleAppBar(title: widget.title, noCard: true),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: MyColors.primaryColor))
            : taskList.isEmpty
                ? const Center(
                    child: Text("Хичээл хоосон байна",
                        style: TextStyle(color: MyColors.gray)),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: taskList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => CourseTasks(
                                              initialPage: index.toDouble(),
                                              title: widget.title,
                                              courseTasks: taskList)))
                                  .then((value) {
                                if (value != null) {
                                  initialPage = value;
                                }
                                setState(() {
                                  print("pop hiisnii daraa");
                                  getCoursesTasks(widget.id);
                                });
                              });
                            },
                            focusColor: MyColors.input,
                            splashColor: MyColors.input,
                            hoverColor: MyColors.input,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20),
                              child: Row(
                                children: [
                                  Text(
                                      (index + 1).toString() +
                                          ". " +
                                          tasksName[index],
                                      style: const TextStyle(
                                          color: MyColors.black, fontSize: 16)),
                                  const Spacer(),
                                  taskList[index].isAnswered == 0
                                      ? Container(
                                          height: 20,
                                          width: 20,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  width: 1.5,
                                                  color: MyColors.border1)),
                                        )
                                      : const CircleAvatar(
                                          radius: 11,
                                          backgroundColor: MyColors.success,
                                          child: Icon(
                                            Icons.done,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        )
                                ],
                              ),
                            ),
                          );
                        }),
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
    setState(() {
      taskList = allTasks;
    });

    return allTasks;
  }
}
