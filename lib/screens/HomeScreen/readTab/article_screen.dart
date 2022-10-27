import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/custom_elevated_button.dart';
import 'package:goodali/Widgets/filter_button.dart';
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
  late final tagFuture = getTagList();
  List<int> checkedTag = [];
  List<ArticleModel> filteredList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          physics: const NeverScrollableScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                pinned: true,
                floating: true,
                elevation: 0,
                iconTheme: const IconThemeData(color: MyColors.black),
                backgroundColor: Colors.white,
                bottom: PreferredSize(
                    preferredSize:
                        const Size(double.infinity, kToolbarHeight - 10),
                    child: Container(
                      padding: const EdgeInsets.only(left: 20),
                      alignment: Alignment.topLeft,
                      child: const Text("Бичвэр",
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: MyColors.black)),
                    )),
              ),
            ];
          },
          body: FutureBuilder(
            future: getArticle(),
            builder: (BuildContext context,
                AsyncSnapshot<List<ArticleModel>> snapshot) {
              if (snapshot.hasData) {
                List<ArticleModel> artcileList = snapshot.data ?? [];
                List<ArticleModel> searchList = [];
                if (widget.id != null) {
                  for (var item in artcileList) {
                    if (item.id == widget.id) {
                      searchList.add(item);
                    }
                    for (var id in checkedTag) {
                      if (item.tags?.first.id == id) {
                        filteredList.add(item);
                      }
                    }
                  }
                }
                log(filteredList.length.toString());

                return ListView.separated(
                  itemCount: filteredList.isNotEmpty
                      ? filteredList.length
                      : widget.id != null
                          ? searchList.length
                          : artcileList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(top: 20.0, left: 20, right: 20),
                      child: GestureDetector(
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
                          )),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(
                          color: MyColors.border1, endIndent: 20, indent: 20),
                );
              } else {
                return const Center(
                    child: CircularProgressIndicator(
                        color: MyColors.primaryColor));
              }
            },
          )),
      floatingActionButton: FilterButton(onPress: () {
        showModalTag();
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  showModalTag() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        builder: (_) => SizedBox(
              height: MediaQuery.of(context).size.height - 100,
              child: StatefulBuilder(
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
                        Expanded(
                          child: FutureBuilder(
                            future: tagFuture,
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData &&
                                  ConnectionState.done ==
                                      snapshot.connectionState) {
                                List<TagModel> tagList = snapshot.data;
                                return ListView.builder(
                                    itemCount: tagList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return CheckboxListTile(
                                          title:
                                              Text(tagList[index].name ?? ""),
                                          activeColor: MyColors.primaryColor,
                                          onChanged: (bool? value) {
                                            if (value == true) {
                                              setState(() {
                                                checkedTag.add(
                                                    tagList[index].id ?? 0);
                                              });
                                            } else {
                                              setState(() {
                                                checkedTag
                                                    .remove(tagList[index].id);
                                              });
                                            }
                                          },
                                          value: checkedTag
                                              .contains(tagList[index].id));
                                    });
                              } else {
                                return const Center(
                                    child: CircularProgressIndicator(
                                        color: MyColors.primaryColor,
                                        strokeWidth: 2));
                              }
                            },
                          ),
                        ),
                        CustomElevatedButton(
                            text: "Шүүх",
                            onPress: () {
                              Navigator.pop(context, checkedTag);
                            }),
                        const SizedBox(height: 20),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              ),
            )).then((value) => setState(() {
          checkedTag = value;
        }));
  }

  Future<List<TagModel>> getTagList() async {
    return await Connection.getTagList(context);
  }

  Future<List<ArticleModel>> getArticle() {
    return Connection.getArticle(context);
  }
}
