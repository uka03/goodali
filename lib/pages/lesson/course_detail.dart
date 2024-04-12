import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:goodali/connection/models/course_response.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/auth/components/auth_input.dart';
import 'package:goodali/pages/lesson/provider/lecture_provider.dart';
import 'package:goodali/pages/lesson/task_video_player.dart';
import 'package:goodali/shared/components/appbar_with_back.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/shared/components/general_scaffold.dart';
import 'package:goodali/shared/components/keyboard_hider.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/constants.dart';
import 'package:goodali/utils/primary_button.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/toasts.dart';
import 'package:provider/provider.dart';

class CourseDetail extends StatefulWidget {
  const CourseDetail({super.key, this.task, this.lesson, required this.initialPage});
  final TaskResponse? task;
  final LessonResponse? lesson;
  final int initialPage;

  @override
  State<CourseDetail> createState() => _CourseDetailState();
}

class _CourseDetailState extends State<CourseDetail> {
  late final PageController controller = PageController(initialPage: widget.initialPage);
  int selectedPage = 0;
  int totalPage = 0;
  TaskResponse? task;
  bool isFullScreen = false;

  @override
  void initState() {
    super.initState();
    selectedPage = widget.initialPage;
    controller.addListener(() {
      if (controller.page == controller.page?.toInt()) {
        setState(() {
          selectedPage = controller.page?.toInt() ?? 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LessonProvider>(
      builder: (context, provider, _) {
        final itemLenght = provider.coursesTasks.length;
        return GeneralScaffold(
          appBar: !isFullScreen
              ? AppbarWithBackButton(
                  title: widget.lesson?.name,
                  onleading: () {
                    provider.getTasks(widget.lesson?.id);
                  },
                )
              : null,
          bottomBar: !isFullScreen
              ? Container(
                  margin: kIsWeb ? EdgeInsets.symmetric(horizontal: 155) : null,
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 32),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: GoodaliColors.grayColor,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        child: Text(
                          "${selectedPage + 1}/$itemLenght",
                          style: GoodaliTextStyles.bodyText(context),
                        ),
                      ),
                      HSpacer(),
                      Expanded(
                        child: PrimaryButton(
                          height: 50,
                          text: selectedPage + 1 >= provider.coursesTasks.length ? "Дуусгах" : "Дараах",
                          textFontSize: 16,
                          onPressed: () async {
                            if (task?.type == 4 && task?.watchVideo != true) {
                              Toast.error(context, description: "Та видеог дуустал нь үзсэн дараагүй байна.");
                              return;
                            }
                            if (task?.isAnswer == 1) {
                              if (task?.answerData?.isEmpty == true) {
                                Toast.error(context, description: "Та хариулт бичээгүй байна.");
                                return;
                              }

                              provider.setAnswer(id: task?.id, answer: task?.answerData ?? "");
                            } else {
                              provider.setAnswer(id: task?.id, answer: "");
                            }
                            if (selectedPage + 1 >= provider.coursesTasks.length) {
                              await provider.getTasks(widget.lesson?.id);
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            } else {
                              controller.nextPage(
                                duration: Duration(microseconds: 500),
                                curve: Curves.linear,
                              );
                            }
                          },
                        ),
                      )
                    ],
                  ),
                )
              : null,
          child: PageView.builder(
            controller: controller,
            itemCount: provider.coursesTasks.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              task = provider.coursesTasks[index];
              final answerController = TextEditingController(text: task?.answerData ?? "");

              return KeyboardHider(
                child: SingleChildScrollView(
                  child: Container(
                    margin: kIsWeb ? EdgeInsets.symmetric(horizontal: 155) : null,
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 150),
                    child: Column(
                      children: [
                        if (task?.banner?.isNotEmpty == true && task?.banner != "Image failed to upload")
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            child: Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: CachedNetworkImage(
                                  imageUrl: task?.banner.toUrl() ?? placeholder,
                                  height: 260,
                                  width: 260,
                                ),
                              ),
                            ),
                          ),
                        if (task?.type == 4 && task?.videoUrl?.isNotEmpty == true)
                          Column(
                            children: [
                              TaskVideoPlayer(
                                task: task,
                                onExitScreen: () {
                                  if (isFullScreen) {
                                    setState(() {
                                      isFullScreen = false;
                                    });
                                  }
                                },
                                onFullScreen: () {
                                  if (!isFullScreen) {
                                    setState(() {
                                      isFullScreen = true;
                                    });
                                  }
                                },
                              ),
                              VSpacer(),
                              CustomButton(
                                onPressed: () {
                                  setState(() {
                                    task?.watchVideo = !(task?.watchVideo ?? false);
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: task?.watchVideo == true ? GoodaliColors.successColor : GoodaliColors.borderColor, width: 2),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: task?.watchVideo == true ? GoodaliColors.successColor : GoodaliColors.whiteColor,
                                          border: Border.all(color: task?.watchVideo == true ? GoodaliColors.successColor : GoodaliColors.borderColor, width: 2),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.check,
                                            size: 15,
                                            color: GoodaliColors.whiteColor,
                                          ),
                                        ),
                                      ),
                                      HSpacer(),
                                      Expanded(
                                        child: Text(
                                          "Видеог дуустал нь үзсэн.",
                                          style: GoodaliTextStyles.titleText(
                                            context,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        if (task?.isAnswer == 1)
                          Column(
                            children: [
                              Text(
                                task?.question ?? "",
                                style: GoodaliTextStyles.titleText(context, fontSize: 20),
                              ),
                              AuthInput(
                                isTyping: true,
                                onClose: () {
                                  answerController.clear();
                                  task?.answerData = "";
                                },
                                hintText: "Хариулт",
                                controller: answerController,
                                onChanged: (value) {
                                  task?.answerData = value;
                                },
                                maxLength: 2000,
                                keyboardType: TextInputType.text,
                              ),
                              VSpacer(),
                            ],
                          ),
                        HtmlWidget(task?.body ?? ""),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
