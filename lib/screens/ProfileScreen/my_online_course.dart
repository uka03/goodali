import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/simple_appbar.dart';

class MyOnlineCourse extends StatefulWidget {
  const MyOnlineCourse({Key? key}) : super(key: key);

  @override
  State<MyOnlineCourse> createState() => _MyOnlineCourseState();
}

class _MyOnlineCourseState extends State<MyOnlineCourse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              "Очирын бороо",
              style: TextStyle(
                  fontSize: 32,
                  color: MyColors.black,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
