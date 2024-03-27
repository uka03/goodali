import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:goodali/connection/models/course_response.dart';
import 'package:goodali/pages/lesson/course_detail.dart';
import 'package:goodali/pages/lesson/provider/lecture_provider.dart';
import 'package:goodali/shared/components/appbar_with_back.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/shared/components/general_scaffold.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:provider/provider.dart';

class CourseTasks extends StatefulWidget {
  const CourseTasks({super.key, this.lesson});

  final LessonResponse? lesson;

  @override
  State<CourseTasks> createState() => _CourseTasksState();
}

class _CourseTasksState extends State<CourseTasks> {
  late final LessonProvider lessonProvider;
  @override
  void initState() {
    super.initState();
    lessonProvider = Provider.of<LessonProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      lessonProvider.getTasks(widget.lesson?.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LessonProvider>(builder: (context, provider, _) {
      return GeneralScaffold(
        appBar: AppbarWithBackButton(
          title: widget.lesson?.name ?? "",
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            lessonProvider.getTasks(widget.lesson?.id);
          },
          child: ListView.separated(
            padding: EdgeInsets.all(16),
            itemCount: provider.coursesTasks.length,
            separatorBuilder: (context, index) => VSpacer(size: 25),
            itemBuilder: (context, index) {
              final task = provider.coursesTasks[index];
              String? title;
              bool isDone = task.isAnswered == 1;
              switch (task.type) {
                case 0:
                  title = "Унших материал";
                  break;
                case 1:
                  title = "Бичих";
                  break;
                case 2:
                  title = "Сонсох";
                  break;
                case 3:
                  title = "Хийх";
                  break;
                case 4:
                  title = "Үзэх";
                  break;
                case 5:
                  title = "Мэдрэх";
                  break;
                case 6:
                  title = "Судлах";
                  break;
                default:
              }
              return CustomButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CourseDetail(
                        task: task,
                        lesson: widget.lesson,
                        initialPage: index,
                      ),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${index + 1}. ${title ?? ""}"),
                          Text(isDone ? "Дууссан" : "Хийгээгүй",
                              style: GoodaliTextStyles.bodyText(context,
                                  textColor: GoodaliColors.grayColor)),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: isDone
                            ? GoodaliColors.successColor
                            : GoodaliColors.whiteColor,
                        border: Border.all(
                            color: isDone
                                ? GoodaliColors.successColor
                                : GoodaliColors.borderColor,
                            width: 2),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.check,
                          size: 15,
                          color: GoodaliColors.whiteColor,
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      );
    });
  }
}
