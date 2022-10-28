import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/custom_elevated_button.dart';
import 'package:goodali/Widgets/filter_button.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/models/post_list_model.dart';
import 'package:goodali/models/tag_model.dart';
import 'package:goodali/screens/ForumScreen/post_detail.dart';
import 'package:goodali/screens/HomeScreen/readTab/article_screen.dart';
import 'package:goodali/screens/ListItems/post_item.dart';
import 'package:iconly/iconly.dart';

class NatureOfHuman extends StatefulWidget {
  const NatureOfHuman({Key? key}) : super(key: key);

  @override
  State<NatureOfHuman> createState() => _NatureOfHumanState();
}

class _NatureOfHumanState extends State<NatureOfHuman> {
  late final tagFuture = getTagList();
  List<int> checkedTag = [];

  List<bool> isHearted = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        color: MyColors.primaryColor,
        onRefresh: _refresh,
        child: FutureBuilder(
          future: getPostList(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData &&
                ConnectionState.done == snapshot.connectionState) {
              List<PostListModel> postList = snapshot.data;
              if (postList.isNotEmpty) {
                return ListView.separated(
                    itemCount: postList.length,
                    itemBuilder: (BuildContext context, int index) {
                      isHearted.add(false);
                      return GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => PostDetail(
                                    onRefresh: () {
                                      _refresh();
                                    },
                                    postItem: postList[index],
                                    isHearted: isHearted[index]))),
                        child: PostItem(
                            postItem: postList[index],
                            isHearted: isHearted[index]),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(
                          endIndent: 18,
                          indent: 18,
                        ));
              } else {
                return Container();
              }
            } else {
              return const Center(
                  child:
                      CircularProgressIndicator(color: MyColors.primaryColor));
            }
          },
        ),
      ),
      floatingActionButton: FilterButton(onPress: () {
        showModalTag(context, tagFuture, checkedTag);
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  showModalTag(BuildContext context, Future tagFuture, List<int> checkedTag) {
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
            ));
  }

  Future<List<TagModel>> getTagList() async {
    return await Connection.getTagList(context);
  }

  Future<void> _refresh() async {
    setState(() {
      getPostList();
    });
  }

  Future getPostList() {
    return Connection.getPostList(context, {"post_type": 0});
  }
}
