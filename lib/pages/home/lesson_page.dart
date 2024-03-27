import 'package:flutter/material.dart';
import 'package:goodali/pages/home/provider/home_provider.dart';
import 'package:goodali/pages/lesson/components/Lesson_item.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';

class LessonPage extends StatelessWidget {
  const LessonPage({super.key, required this.homeProvider});
  final HomeProvider homeProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "Онлайн сургалт",
            style: GoodaliTextStyles.titleText(context, fontSize: 24),
          ),
        ),
        VSpacer(),
        ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 16),
          itemCount: homeProvider.lessons?.length ?? 0,
          separatorBuilder: (context, index) => VSpacer(),
          itemBuilder: (context, index) {
            final lesson = homeProvider.lessons?[index];
            return LessonItem(lesson: lesson);
          },
        )
      ],
    );
  }
}
