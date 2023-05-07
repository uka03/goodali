import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/models/courses_item.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/HomeScreen/header_widget.dart';
import 'package:goodali/screens/ProfileScreen/courseLessons.dart/my_courses_detail.dart';

class MyCourseMain extends StatefulWidget {
  final Products courseItem;
  final List<Products> courseListItem;
  final bool isFromHome;
  const MyCourseMain({Key? key, required this.courseItem, required this.courseListItem, this.isFromHome = false}) : super(key: key);

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

  Future<void> _refresh() async {
    setState(() {
      getBoughtCoursesItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: kIsWeb ? null : const SimpleAppBar(noCard: true),
        body: Column(
          children: [
            Visibility(
              visible: kIsWeb,
              child: HeaderWidget(
                title: title,
                isProfile: true,
              ),
            ),
            Expanded(
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * (kIsWeb ? 0.4 : 1),
                  child: RefreshIndicator(
                    onRefresh: _refresh,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          Container(
                            height: 56,
                            padding: const EdgeInsets.only(left: 20),
                            alignment: Alignment.centerLeft,
                            child: Text(title, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: MyColors.black)),
                          ),
                          FutureBuilder(
                              future: getBoughtCoursesItems(),
                              builder: (context, AsyncSnapshot snapshot) {
                                if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                                  List<CoursesItems> coursesItemList = snapshot.data;
                                  return ListView.builder(
                                    itemCount: coursesItemList.length,
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      allTasks = coursesItemList[index].allTask ?? 0;
                                      doneTasks = coursesItemList[index].done ?? 0;

                                      String tasks = doneTasks.toString() + "/" + allTasks.toString() + " даалгавар";
                                      return Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: ((context) => MyCoursesDetail(
                                                          lessonName: coursesItemList[index].name ?? "",
                                                          coursesItems: coursesItemList[index],
                                                          title: title,
                                                        ))));
                                          },
                                          child: SizedBox(
                                            height: 48,
                                            width: double.infinity,
                                            child: Row(
                                              children: [
                                                (coursesItemList[index].banner != "Image failed to upload")
                                                    ? ClipRRect(
                                                        borderRadius: BorderRadius.circular(8),
                                                        child: ImageView(
                                                          imgPath: coursesItemList[index].banner ?? "",
                                                          height: 48,
                                                          width: 48,
                                                        ),
                                                        //     Container(
                                                        //   color: Colors.blueGrey,
                                                        //   width: 48,
                                                        //   height: 48,
                                                        // )
                                                      )
                                                    : Container(
                                                        decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)),
                                                        height: 48,
                                                        width: 48,
                                                      ),
                                                const SizedBox(width: 15),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(coursesItemList[index].name ?? "",
                                                        style: const TextStyle(color: MyColors.black, fontSize: 14, fontWeight: FontWeight.bold)),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      tasks,
                                                      style: const TextStyle(color: MyColors.gray, fontSize: 12),
                                                    )
                                                  ],
                                                ),
                                                const Spacer(),
                                                allTasks == doneTasks
                                                    ? SvgPicture.asset("assets/images/done_icon.svg")
                                                    : SvgPicture.asset("assets/images/undone_icon.svg"),
                                                const SizedBox(width: 10),
                                              ],
                                            ),
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
                              }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Future<List<CoursesItems>> getBoughtCoursesItems() async {
    return Connection.getBoughtCoursesItems(context, widget.courseItem.id.toString());
  }
}
