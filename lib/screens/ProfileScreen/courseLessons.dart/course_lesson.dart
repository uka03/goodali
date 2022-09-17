import 'package:flutter/material.dart';
import 'package:goodali/Widgets/simple_appbar.dart';

class CourseLesson extends StatefulWidget {
  const CourseLesson({Key? key}) : super(key: key);

  @override
  State<CourseLesson> createState() => _CourseLessonState();
}

class _CourseLessonState extends State<CourseLesson> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: const SimpleAppBar(), body: Container());
  }
}
