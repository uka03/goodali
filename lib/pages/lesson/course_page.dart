import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:goodali/connection/models/product_response.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/lesson/course_items.dart';
import 'package:goodali/pages/lesson/provider/lecture_provider.dart';
import 'package:goodali/shared/components/appbar_with_back.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/shared/components/general_scaffold.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/constants.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:provider/provider.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key, this.data});

  final ProductResponseData? data;

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  late final LessonProvider lessonProvider;
  @override
  void initState() {
    super.initState();
    lessonProvider = Provider.of<LessonProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      lessonProvider.getCourseItems(id: widget.data?.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LessonProvider>(builder: (context, provider, _) {
      return GeneralScaffold(
        appBar: AppbarWithBackButton(),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.data?.name ?? "",
                  style: GoodaliTextStyles.titleText(context, fontSize: 32),
                ),
                VSpacer(),
                ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: provider.courseItems.length,
                  separatorBuilder: (context, index) => VSpacer(size: 20),
                  itemBuilder: (context, index) {
                    final item = provider.courseItems[index];
                    return CustomButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CourseItems(item: item),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: CachedNetworkImage(
                                imageUrl: item.banner?.toUrl() ?? placeholder,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          HSpacer(),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name ?? "",
                                  style: GoodaliTextStyles.titleText(context),
                                ),
                                Text(
                                  "${item.done ?? 0}/${item.allTasks ?? 0} даалгавар",
                                  style: GoodaliTextStyles.bodyText(context,
                                      textColor: GoodaliColors.grayColor),
                                )
                              ],
                            ),
                          ),
                          HSpacer(),
                          Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: item.allTasks == item.done
                                  ? GoodaliColors.successColor
                                  : GoodaliColors.whiteColor,
                              border: Border.all(
                                  color: item.allTasks == item.done
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
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
