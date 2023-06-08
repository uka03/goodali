import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/models/course_lessons_tasks_model.dart';

class TaskType0 extends StatefulWidget {
  final CourseLessonsTasksModel courseTask;
  final TextEditingController textController;

  const TaskType0({Key? key, required this.courseTask, required this.textController}) : super(key: key);

  @override
  State<TaskType0> createState() => _TaskType0State();
}

class _TaskType0State extends State<TaskType0> {
  final GlobalKey _orderFormKey = GlobalKey();
  bool isTyping = false;
  BoxDecoration? boxSetting;
  TextEditingController _controller = TextEditingController();

  BoxDecoration defaultBoxSetting = const BoxDecoration(
    border: Border(bottom: BorderSide(color: MyColors.border1)),
  );

  BoxDecoration boxHasFocus = const BoxDecoration(
    border: Border(bottom: BorderSide(color: MyColors.primaryColor, width: 1.5)),
  );

  @override
  void initState() {
    _controller = widget.textController;
    _controller.text = widget.courseTask.answerData ?? "";
    log('[TaskType0] {initState} answerData: ${widget.courseTask.answerData}');

    boxSetting = defaultBoxSetting;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        if (widget.courseTask.isAnswer == 1)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.courseTask.question ?? "", style: const TextStyle(color: MyColors.black, fontWeight: FontWeight.bold, fontSize: 20)),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: TextField(
                  key: _orderFormKey,
                  controller: widget.textController,
                  cursorColor: MyColors.primaryColor,
                  maxLength: 2000,
                  maxLines: null,
                  onChanged: (value) {
                    setState(() {
                      isTyping = true;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Хариулт",
                    suffixIcon: isTyping
                        ? GestureDetector(
                            onTap: () {
                              _controller.clear();
                              setState(() {
                                isTyping = false;
                              });
                            },
                            child: const Icon(Icons.close, color: MyColors.black),
                          )
                        : const SizedBox(),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: MyColors.border1),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: MyColors.primaryColor, width: 1.5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        if (widget.courseTask.body != "" || widget.courseTask.body!.isNotEmpty)
          HtmlWidget(
            widget.courseTask.body ?? "",
            textStyle: const TextStyle(fontFamily: "Gilroy", height: 1.6),
          ),
      ],
    ));
  }
}
