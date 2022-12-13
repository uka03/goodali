import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/custom_elevated_button.dart';
import 'package:goodali/Widgets/filter_button.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/models/article_model.dart';
import 'package:goodali/models/tag_model.dart';
import 'package:goodali/screens/HomeScreen/readTab/article_detail.dart';
import 'package:goodali/screens/ListItems/article_item.dart';

class ArticleScreen extends StatefulWidget {
  final int? id;
  const ArticleScreen({Key? key, this.id}) : super(key: key);

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  late final futureGetArticle = getArticle();
  bool isLoading = true;
  List<TagModel> tagList = [];

  List<int> checkedTag = [];
  List<ArticleModel> filteredList = [];
  List<ArticleModel> artcileList = [];

  @override
  void initState() {
    getTagList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(title: "", noCard: true),
      body: SingleChildScrollView(
          child: FutureBuilder(
        future: futureGetArticle,
        builder:
            (BuildContext context, AsyncSnapshot<List<ArticleModel>> snapshot) {
          if (snapshot.hasData) {
            artcileList = snapshot.data ?? [];
            List<ArticleModel> searchList = [];
            if (widget.id != null) {
              for (var item in artcileList) {
                if (item.id == widget.id) {
                  searchList.add(item);
                }
              }
            }
            log(filteredList.length.toString(), name: "filteredList Length");

            return Column(
              children: [
                const SizedBox(height: 10),
                SizedBox(
                    height: 40,
                    child: Container(
                      padding: const EdgeInsets.only(left: 20),
                      alignment: Alignment.topLeft,
                      child: const Text("Бичвэр",
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: MyColors.black)),
                    )),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: filteredList.isNotEmpty
                      ? filteredList.length
                      : widget.id != null
                          ? searchList.length
                          : artcileList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ArticleDetail(
                                    articleItem: widget.id != null
                                        ? searchList[index]
                                        : artcileList[index]))),
                        child: ArtcileItem(
                          articleModel: filteredList.isNotEmpty
                              ? filteredList[index]
                              : widget.id != null
                                  ? searchList[index]
                                  : artcileList[index],
                        ));
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(
                          color: MyColors.border1, endIndent: 20, indent: 20),
                ),
                const SizedBox(height: 60),
              ],
            );
          } else {
            return const Center(
                child: CircularProgressIndicator(color: MyColors.primaryColor));
          }
        },
      )),
      floatingActionButton: FilterButton(onPress: () {
        showModalTag(context, checkedTag);
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  showModalTag(BuildContext context, List<int> checkedTag) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        builder: (_) => StatefulBuilder(
              builder: (BuildContext context,
                  void Function(void Function()) setState) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 38,
                        height: 6,
                        decoration: BoxDecoration(
                            color: MyColors.gray,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      const SizedBox(height: 20),
                      const Text("Шүүлтүүр",
                          style: TextStyle(
                              fontSize: 22,
                              color: MyColors.black,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Wrap(
                            children: tagList
                                .map(
                                  (e) => InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (!checkedTag.contains(e.id)) {
                                          checkedTag.add(e.id!);
                                        } else {
                                          checkedTag.remove(e.id);
                                        }
                                      });
                                    },
                                    child: SizedBox(
                                      height: 45,
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(e.name ?? "",
                                                style: const TextStyle(
                                                    color: MyColors.black)),
                                            const SizedBox(width: 15),
                                            SizedBox(
                                              height: 24,
                                              width: 24,
                                              child: IgnorePointer(
                                                child: Checkbox(
                                                    fillColor:
                                                        MaterialStateProperty
                                                            .all<Color>(MyColors
                                                                .primaryColor),
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4)),
                                                    side: const BorderSide(
                                                        color:
                                                            MyColors.border1),
                                                    splashRadius: 5,
                                                    onChanged: (_) {},
                                                    value: checkedTag
                                                        .contains(e.id)),
                                              ),
                                            ),
                                          ]),
                                    ),
                                  ),
                                )
                                .toList()),
                      ),
                      const SizedBox(height: 10),
                      CustomElevatedButton(
                          text: "Шүүх",
                          onPress: () {
                            log(checkedTag.length.toString(),
                                name: "checkedTag length");
                            filterPost();
                            Navigator.pop(context, checkedTag);
                          }),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ));
  }

  filterPost() {
    setState(() {
      for (var item in artcileList) {
        for (var id in checkedTag) {
          if (item.tags?.first.id == id &&
              !filteredList.any((element) => element.id == item.id)) {
            filteredList.add(item);
          }
        }
      }
      print(artcileList.length);
      print(filteredList.length);
      if (checkedTag.isEmpty) {
        filteredList.clear();
      }
    });
  }

  Future<void> getTagList() async {
    tagList = await Connection.getTagList(context);
    setState(() {
      isLoading = false;
    });
  }

  Future<List<ArticleModel>> getArticle() {
    return Connection.getArticle(context);
  }
}
  // Expanded(
  //                         child: FutureBuilder(
  //                           future: tagFuture,
  //                           builder:
  //                               (BuildContext context, AsyncSnapshot snapshot) {
  //                             if (snapshot.hasData &&
  //                                 ConnectionState.done ==
  //                                     snapshot.connectionState) {
  //                               List<TagModel> tagList = snapshot.data;
  //                               return ListView.builder(
  //                                   itemCount: tagList.length,
  //                                   itemBuilder:
  //                                       (BuildContext context, int index) {
  //                                     return CheckboxListTile(
  //                                         title:
  //                                             Text(tagList[index].name ?? ""),
  //                                         activeColor: MyColors.primaryColor,
  //                                         onChanged: (bool? value) {
                                           
  //                                         },
  //                                         value: checkedTag
  //                                             .contains(tagList[index].id));
  //                                   });
  //                             } else {
  //                               return const Center(
  //                                   child: CircularProgressIndicator(
  //                                       color: MyColors.primaryColor,
  //                                       strokeWidth: 2));
  //                             }
  //                           },
  //                         ),
  //                       ),