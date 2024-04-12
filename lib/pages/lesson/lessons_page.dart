import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:goodali/pages/lesson/components/Lesson_item.dart';
import 'package:goodali/pages/lesson/provider/lecture_provider.dart';
import 'package:goodali/shared/components/appbar_with_back.dart';
import 'package:goodali/shared/components/general_scaffold.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:provider/provider.dart';

class LessonsPage extends StatefulWidget {
  const LessonsPage({super.key});

  static String routeName = "/lessons_page";

  @override
  State<LessonsPage> createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> {
  late LessonProvider lessonProvider;
  @override
  void initState() {
    lessonProvider = Provider.of<LessonProvider>(context, listen: false);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      lessonProvider.getLessons();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LessonProvider>(builder: (context, provider, _) {
      return GeneralScaffold(
        appBar: AppbarWithBackButton(),
        child: Container(
          margin: kIsWeb ? EdgeInsets.symmetric(horizontal: 155) : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: Text(
                  "Онлайн сургалт",
                  style: GoodaliTextStyles.titleText(context, fontSize: 32),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.all(16),
                  shrinkWrap: true,
                  itemCount: provider.lessons.length,
                  separatorBuilder: (context, index) => Divider(height: 0),
                  itemBuilder: (context, index) {
                    final lesson = provider.lessons[index];
                    return LessonItem(lesson: lesson);
                  },
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
