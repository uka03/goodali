import 'package:flutter/material.dart';
import 'package:goodali/Providers/auth_provider.dart';
import 'package:goodali/Providers/forum_tag_notifier.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/custom_elevated_button.dart';
import 'package:goodali/Widgets/filter_button.dart';
import 'package:goodali/Widgets/filter_modal.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/models/post_list_model.dart';
import 'package:goodali/models/tag_model.dart';
import 'package:goodali/screens/ForumScreen/post_detail.dart';
import 'package:goodali/screens/ListItems/post_item.dart';
import 'package:provider/provider.dart';

class MyFriendTab extends StatefulWidget {
  final List<TagModel> tagList;
  const MyFriendTab({Key? key, required this.tagList}) : super(key: key);

  @override
  State<MyFriendTab> createState() => _MyFriendTabState();
}

class _MyFriendTabState extends State<MyFriendTab> {
  List<bool> isHearted = [];
  List<Map<String, dynamic>> checkedTag = [];
  List<PostListModel> filteredList = [];
  List<PostListModel> postList = [];
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
                      postList = snapshot.data;
                      if (postList.isNotEmpty) {
                        return ListView.separated(
                            itemCount: filteredList.isNotEmpty
                                ? filteredList.length
                                : postList.length,
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
                                            postItem: filteredList.isNotEmpty
                                                ? filteredList[index]
                                                : postList[index],
                                            isHearted: isHearted[index]))),
                                child: PostItem(
                                    isMySpecial: true,
                                    onRefresh: getPostList,
                                    postItem: filteredList.isNotEmpty
                                        ? filteredList[index]
                                        : postList[index],
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
              return const Center(
                  child: Text(
                "Нэвтэрч орон үргэлжлүүлнэ үү.",
                style: TextStyle(color: MyColors.gray),
              ));
            }
          },
        ),
      ),
      floatingActionButton: FilterButton(onPress: () {
        showModalTag(context, checkedTag);
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

  showModalTag(BuildContext context, List<Map<String, dynamic>> checkedTag) {
    List<TagModel> tagList = [];
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        builder: (_) => FilterModal(
              onTap: (checkList) {
                setState(() {
                  checkedTag = checkList;
                });
                filterPost(tagList);
                Navigator.pop(context, filteredList);
              },
              tagList: tagList,
            ));
  }

  filterPost(List<TagModel> tagList) {
    List<Map<String, dynamic>> selectedTagsName = [];
    setState(() {
      for (var item in postList) {
        for (var id in checkedTag) {
          if (item.tags!.isNotEmpty) {
            if (item.tags?.first.id == id["id"] &&
                !filteredList.any((element) => element.id == item.id)) {
              filteredList.add(item);
            }
          }
          for (var name in tagList) {
            if (name.id == id["id"]) {
              selectedTagsName.add({"name": name.name, "id": name.id});
              Provider.of<ForumTagNotifier>(context, listen: false)
                  .setTags(selectedTagsName);
            }
          }
        }
      }

      if (checkedTag.isEmpty) {
        filteredList.clear();
      }
    });
  }
}
