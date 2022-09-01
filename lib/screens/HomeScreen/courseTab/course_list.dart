import 'package:flutter/material.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/ListItems/course_list_item.dart';
import 'package:iconly/iconly.dart';

class CourseList extends StatefulWidget {
  final String id;
  const CourseList({Key? key, required this.id}) : super(key: key);

  @override
  State<CourseList> createState() => _CourseListState();
}

class _CourseListState extends State<CourseList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const SimpleAppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width - 120,
                child: const Text("Та өөрт тохирох багц сонгоно уу",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: MyColors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    )),
              ),
              const SizedBox(height: 24),
              courseList()
            ],
          ),
        ));
  }

  Widget courseList() {
    return FutureBuilder(
      future: getTrainingDetail(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          List<Products> listItem = snapshot.data;
          return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: listItem.length,
              itemBuilder: (BuildContext context, int index) =>
                  CourseListListItem(products: listItem[index]));
        } else {
          return const Center(
            child: CircularProgressIndicator(color: MyColors.primaryColor),
          );
        }
      },
    );
  }

  Future<List<Products>> getTrainingDetail() {
    return Connection.getTrainingDetail(context, widget.id.toString());
  }
}
