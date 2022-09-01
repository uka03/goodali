import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/screens/ProfileScreen/my_online_course.dart';
import 'package:iconly/iconly.dart';

class MyCourses extends StatefulWidget {
  const MyCourses({Key? key}) : super(key: key);

  @override
  State<MyCourses> createState() => _MyCoursesState();
}

class _MyCoursesState extends State<MyCourses> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    if (index == 0) {
      return Column(
        children: [
          const SizedBox(height: 80),
          SvgPicture.asset("assets/images/empty_bought.svg"),
          const SizedBox(height: 20),
          const Text(
            "Авсан бүтээгдэхүүн байхгүй...",
            style: TextStyle(fontSize: 14, color: MyColors.gray),
          ),
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text("Онлайн сургалт",
                style: TextStyle(
                    color: MyColors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            onlineCourses()
          ],
        ),
      );
    }
  }

  Widget onlineCourses() {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Stack(children: [
              Container(
                height: 170,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.pink[300],
                    borderRadius: BorderRadius.circular(12)),
              ),
              Positioned(
                left: 20,
                top: 30,
                child: Text(
                  "Очирын бороо",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Positioned(
                left: 20,
                top: 62,
                child: Row(
                  children: [
                    Text(
                      "Эхлэх огноо:",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      " 2022.06.18",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                child: GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const MyOnlineCourse())),
                  child: Container(
                    height: 40,
                    width: 130,
                    decoration: BoxDecoration(
                        color: MyColors.input,
                        borderRadius: BorderRadius.circular(6)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          " Дэлгэрэнгүй",
                          style: TextStyle(
                              color: MyColors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        Icon(IconlyLight.arrow_right_2)
                      ],
                    ),
                  ),
                ),
              )
            ]),
          );
        });
  }
}
