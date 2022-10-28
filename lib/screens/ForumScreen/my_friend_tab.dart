import 'package:flutter/material.dart';
import 'package:goodali/Providers/auth_provider.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/custom_elevated_button.dart';
import 'package:goodali/Widgets/filter_button.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/models/post_list_model.dart';
import 'package:goodali/models/tag_model.dart';
import 'package:goodali/screens/Auth/login.dart';
import 'package:goodali/screens/ForumScreen/post_detail.dart';
import 'package:goodali/screens/HomeScreen/readTab/article_screen.dart';
import 'package:goodali/screens/ListItems/post_item.dart';
import 'package:provider/provider.dart';

class MyFriendTab extends StatefulWidget {
  final VoidCallback goToFirstTab;
  const MyFriendTab({Key? key, required this.goToFirstTab}) : super(key: key);

  @override
  State<MyFriendTab> createState() => _MyFriendTabState();
}

class _MyFriendTabState extends State<MyFriendTab> {
  List<bool> isHearted = [];
  late final tagFuture = getTagList();
  List<int> checkedTag = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Consumer<Auth>(
          builder: (BuildContext context, value, Widget? child) {
            if (value.isAuth) {
              return FutureBuilder(
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
                                    isMySpecial: true,
                                    postItem: postList[index],
                                    isHearted: isHearted[index]),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(
                                      endIndent: 18,
                                      indent: 18,
                                    ));
                      } else {
                        return Container();
                      }
                    } else {
                      return const Center(
                          child: CircularProgressIndicator(
                              color: MyColors.primaryColor));
                    }
                  });
            } else {
              return Center(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 280,
                    child: Text(
                      "Та онлайн сургалтанд бүртгүүлснээр нууцлалтай ярианд нэгдэх боломжтой",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: MyColors.gray),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                      child: const Text(
                        "Сургалт харах",
                      ),
                      onPressed: () {
                        if (value.isAuth) {
                          widget.goToFirstTab();
                        } else {
                          showModalBottomSheet(
                              context: context,
                              isDismissible: false,
                              enableDrag: true,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12))),
                              builder: (BuildContext context) =>
                                  const LoginBottomSheet());
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 24),
                          elevation: 0,
                          primary: MyColors.primaryColor)),
                ],
              ));
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

  Future<List<TagModel>> getTagList() async {
    return await Connection.getTagList(context);
  }

  Future<void> _refresh() async {
    setState(() {
      getPostList();
    });
  }

  Future getPostList() {
    return Connection.getPostList(context, {"post_type": 2});
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
}
