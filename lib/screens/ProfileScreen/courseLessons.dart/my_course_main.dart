import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Utils/utils.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/models/courses_item.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/ProfileScreen/courseLessons.dart/my_courses_detail.dart';
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
  String title = '';
  int allTasks = 0;
  int doneTasks = 0;

  @override
  void initState() {
    title = widget.courseItem.name ?? "";

    super.initState();
  }

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
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: MyColors.black)),
                      )),
                ),
              ];
            },
            body: FutureBuilder(
                future: getBoughtCoursesItems(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    List<CoursesItems> coursesItemList = snapshot.data;
                    return ListView.builder(
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        allTasks = coursesItemList[index].allTask ?? 0;
                        doneTasks = coursesItemList[index].done ?? 0;

                        String tasks = doneTasks.toString() +
                            "/" +
                            allTasks.toString() +
                            " даалгавар";
                        print("tasks $tasks");
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => MyCoursesDetail(
                                        lessonName:
                                            coursesItemList[index].name ?? "",
                                        coursesItems:
                                            coursesItemList[index]))));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            height: 70,
                            width: double.infinity,
                            child: Row(
                              children: [
                                (coursesItemList[index].banner !=
                                        "Image failed to upload")
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: ImageView(
                                          imgPath:
                                              coursesItemList[index].banner ??
                                                  "",
                                          height: 48,
                                          width: 48,
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        height: 48,
                                        width: 48,
                                      ),
                                const SizedBox(width: 15),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        coursesItemList[index]
                                                .name
                                                ?.capitalize() ??
                                            "",
                                        style: const TextStyle(
                                            color: MyColors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 8),
                                    Text(
                                      tasks,
                                      style: const TextStyle(
                                          color: MyColors.gray, fontSize: 12),
                                    )
                                  ],
                                ),
                                const Spacer(),
                                allTasks == doneTasks
                                    ? const CircleAvatar(
                                        radius: 11,
                                        backgroundColor: MyColors.success,
                                        child: Icon(
                                          Icons.done,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      )
                                    : Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                width: 1,
                                                color: MyColors.gray)),
                                      ),
                                const SizedBox(width: 10),
                              ],
                            ),
                          ),
                        );
                      },
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

  Future<List<CoursesItems>> getBoughtCoursesItems() async {
    return Connection.getBoughtCoursesItems(
        context, widget.courseItem.id.toString());
  }
}
