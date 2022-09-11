import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/custom_readmore_text.dart';
import 'package:goodali/Widgets/simple_appbar.dart';

class MyCoursesDetail extends StatefulWidget {
  const MyCoursesDetail({Key? key}) : super(key: key);

  @override
  State<MyCoursesDetail> createState() => _MyCoursesDetailState();
}

class _MyCoursesDetailState extends State<MyCoursesDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(noCard: true),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(children: [
          const SizedBox(height: 20),
          Container(
            height: 190,
            width: 190,
            color: Colors.pink,
          ),
          const SizedBox(height: 20),
          Text(
            "Удмын зохиолын хувьсал",
            style: const TextStyle(
                fontSize: 20,
                color: MyColors.black,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomReadMoreText(
                text: "widget.products.body ??",
                textAlign: TextAlign.center,
              )),
          const SizedBox(height: 20),
          const Divider(endIndent: 20, indent: 20),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }
}
