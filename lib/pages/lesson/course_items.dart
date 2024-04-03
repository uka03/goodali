import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:goodali/connection/models/course_response.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/lesson/course_tasks.dart';
import 'package:goodali/pages/lesson/provider/lecture_provider.dart';
import 'package:goodali/shared/components/appbar_with_back.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/shared/components/general_scaffold.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/constants.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/toasts.dart';
import 'package:provider/provider.dart';

class CourseItems extends StatefulWidget {
  const CourseItems({super.key, this.item});

  final CourseItemResponse? item;

  @override
  State<CourseItems> createState() => _CourseItemsState();
}

class _CourseItemsState extends State<CourseItems> {
  late final LessonProvider lessonProvider;
  @override
  void initState() {
    super.initState();
    lessonProvider = Provider.of<LessonProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      lessonProvider.getCoursesLessons(id: widget.item?.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LessonProvider>(builder: (context, provider, _) {
      return GeneralScaffold(
        appBar: AppbarWithBackButton(),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () =>
                lessonProvider.getCoursesLessons(id: widget.item?.id),
            child: ListView(
              children: [
                Column(
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: widget.item?.banner.toUrl() ?? placeholder,
                          width: 190,
                          height: 190,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    VSpacer(),
                    Text(
                      widget.item?.name ?? "",
                      style: GoodaliTextStyles.titleText(context, fontSize: 26),
                    ),
                    ListView.separated(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 150),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: provider.coursesLessons.length,
                      separatorBuilder: (context, index) => VSpacer(),
                      itemBuilder: (context, index) {
                        final lesson = provider.coursesLessons[index];
                        return CustomButton(
                          onPressed: () {
                            if (lesson.isBought == 1) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CourseTasks(
                                    lesson: lesson,
                                  ),
                                ),
                              );
                            } else {
                              Toast.error(context,
                                  description: "Түгжээтэй контент");
                            }
                          },
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      lesson.name ?? "",
                                      style:
                                          GoodaliTextStyles.titleText(context),
                                    ),
                                    Text(
                                      "${lesson.done ?? 0}/${lesson.allTasks ?? 0}",
                                      style: GoodaliTextStyles.bodyText(context,
                                          textColor: GoodaliColors.grayColor),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_right_rounded,
                                color: GoodaliColors.grayColor,
                                size: 26,
                              )
                            ],
                          ),
                        );
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
