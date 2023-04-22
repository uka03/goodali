import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:goodali/Providers/auth_provider.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/ListItems/course_list_item.dart';

import 'package:provider/provider.dart';

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
    return Consumer<Auth>(builder: (context, value, child) {
      return FutureBuilder(
        future: value.isAuth ? getTrainingDetailLogged() : getTrainingDetail(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            List<Products> listItem = snapshot.data;

            return kIsWeb
                ? SizedBox(
                    child: Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: /* GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: listItem.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                              crossAxisCount: 2,
                            ),
                            // itemBuilder: (BuildContext context, int index) => CourseListListItem(products: listItem[index])),
                            itemBuilder: (BuildContext context, int index) {
                              return LayoutBuilder(
                                builder: (BuildContext context, BoxConstraints constraints) {
                                  final double aspectRatio = constraints.maxWidth / 2; // Adjust the denominator to control the height
                                  return AspectRatio(
                                    aspectRatio: aspectRatio,
                                    child: CourseListListItem(products: listItem[index]),
                                  );
                                },
                              );
                            }), */
                            Wrap(
                          spacing: 15, // Horizontal spacing between children
                          runSpacing: 15, // Vertical spacing between children
                          children: List<Widget>.generate(
                            listItem.length,
                            (int index) => SizedBox(
                              width: MediaQuery.of(context).size.width / 3 - 15, // Adjust the width of the item
                              child: CourseListListItem(products: listItem[index]),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: listItem.length,
                    itemBuilder: (BuildContext context, int index) => CourseListListItem(products: listItem[index]));
          } else {
            return const Center(
              child: CircularProgressIndicator(color: MyColors.primaryColor),
            );
          }
        },
      );
    });
  }

  Future<List<Products>> getTrainingDetail() {
    return Connection.getTrainingDetail(context, widget.id.toString());
  }

  Future<List<Products>> getTrainingDetailLogged() {
    print("logged ");
    return Connection.getTrainingDetailLogged(context, widget.id.toString());
  }
}
