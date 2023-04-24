import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/custom_elevated_button.dart';
import 'package:goodali/Widgets/filter_button.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/models/article_model.dart';
import 'package:goodali/models/tag_model.dart';
import 'package:goodali/screens/HomeScreen/header_widget.dart';
import 'package:goodali/screens/HomeScreen/readTab/article_detail.dart';
import 'package:goodali/screens/ListItems/article_item.dart';
import 'package:iconly/iconly.dart';

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
      appBar: kIsWeb ? null : const SimpleAppBar(noCard: true),
      body: Column(
        children: [
          const Visibility(
            visible: kIsWeb,
            child: HeaderWidget(
              title: 'Нүүр / Бичвэр',
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
                child: FutureBuilder(
              future: futureGetArticle,
              builder: (BuildContext context, AsyncSnapshot<List<ArticleModel>> snapshot) {
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

                  return SizedBox(
                    child: Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * (kIsWeb ? 0.4 : 1),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            SizedBox(
                                height: 40,
                                child: Container(
                                  padding: const EdgeInsets.only(left: 20),
                                  alignment: Alignment.topLeft,
                                  child: Row(
                                    children: [
                                      const Text("Бичвэр", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: MyColors.black)),
                                      const Spacer(),
                                      kIsWeb
                                          ? TextButton.icon(
                                              onPressed: () {
                                                showWebModalTag(context, checkedTag);
                                              },
                                              icon: const Icon(
                                                IconlyLight.filter,
                                                size: 24.0,
                                                color: Color(0xff393837),
                                              ),
                                              label: const Text(
                                                'Шүүлтүүр',
                                                style: TextStyle(color: Color(0xff393837)),
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
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
                                            builder: (context) =>
                                                ArticleDetail(articleItem: widget.id != null ? searchList[index] : artcileList[index]))),
                                    child: ArtcileItem(
                                        articleModel: filteredList.isNotEmpty
                                            ? filteredList[index]
                                            : widget.id != null
                                                ? searchList[index]
                                                : artcileList[index],
                                        isFromHome: false));
                              },
                              separatorBuilder: (BuildContext context, int index) =>
                                  const Divider(color: MyColors.border1, endIndent: 20, indent: 20),
                            ),
                            const SizedBox(height: 60),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator(color: MyColors.primaryColor));
                }
              },
            )),
          ),
        ],
      ),
      floatingActionButton: kIsWeb
          ? null
          : FilterButton(onPress: () {
              showModalTag(context, checkedTag);
            }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  showWebModalTag(BuildContext context, List<int> checkedTag) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent, // Change this to transparent
        isScrollControlled: true,
        isDismissible: true,
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
        builder: (_) => StatefulBuilder(
              builder: (BuildContext context, void Function(void Function()) setState) {
                return Column(
                  children: [
                    const Spacer(),
                    Container(
                      width: MediaQuery.of(context).size.width / 4,
                      color: Colors.white,
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            alignment: Alignment.topRight,
                            child: IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                          ),
                          const SizedBox(height: 20),
                          const Text("Шүүлтүүр", style: TextStyle(fontSize: 22, color: MyColors.black, fontWeight: FontWeight.bold)),
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
                                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                            Text(e.name ?? "", style: const TextStyle(color: MyColors.black)),
                                            const SizedBox(width: 15),
                                            SizedBox(
                                              height: 24,
                                              width: 24,
                                              child: IgnorePointer(
                                                child: Checkbox(
                                                    fillColor: MaterialStateProperty.all<Color>(MyColors.primaryColor),
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                                    side: const BorderSide(color: MyColors.border1),
                                                    splashRadius: 5,
                                                    onChanged: (_) {},
                                                    value: checkedTag.contains(e.id)),
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
                                log(checkedTag.length.toString(), name: "checkedTag length");
                                filterPost();
                              }),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    const Spacer(),
                  ],
                );
              },
            ));
  }

  showModalTag(BuildContext context, List<int> checkedTag) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        builder: (_) => StatefulBuilder(
              builder: (BuildContext context, void Function(void Function()) setState) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 38,
                        height: 6,
                        decoration: BoxDecoration(color: MyColors.gray, borderRadius: BorderRadius.circular(10)),
                      ),
                      const SizedBox(height: 20),
                      const Text("Шүүлтүүр", style: TextStyle(fontSize: 22, color: MyColors.black, fontWeight: FontWeight.bold)),
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
                                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                        Text(e.name ?? "", style: const TextStyle(color: MyColors.black)),
                                        const SizedBox(width: 15),
                                        SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: IgnorePointer(
                                            child: Checkbox(
                                                fillColor: MaterialStateProperty.all<Color>(MyColors.primaryColor),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                                side: const BorderSide(color: MyColors.border1),
                                                splashRadius: 5,
                                                onChanged: (_) {},
                                                value: checkedTag.contains(e.id)),
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
                            log(checkedTag.length.toString(), name: "checkedTag length");
                            filterPost();
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
      for (var article in artcileList) {
        for (var id in checkedTag) {
          if (article.tags!.isNotEmpty) {
            if (article.tags?.first.id == id && !filteredList.any((element) => element.id == article.id)) {
              filteredList.add(article);
            }
          }
        }
      }

      if (checkedTag.isEmpty) {
        filteredList.clear();
      }
    });
    Navigator.pop(context);
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
