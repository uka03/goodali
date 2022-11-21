import 'package:flutter/material.dart';
import 'package:goodali/Providers/auth_provider.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/custom_elevated_button.dart';
import 'package:goodali/Widgets/filter_button.dart';
import 'package:goodali/Widgets/filter_modal.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/Providers/forum_tag_notifier.dart';
import 'package:goodali/models/post_list_model.dart';
import 'package:goodali/models/tag_model.dart';
import 'package:goodali/screens/ForumScreen/post_detail.dart';
import 'package:goodali/screens/ListItems/post_item.dart';
import 'package:provider/provider.dart';

class NatureOfHuman extends StatefulWidget {
  final List<TagModel> tagList;
  const NatureOfHuman({Key? key, required this.tagList}) : super(key: key);

  @override
  State<NatureOfHuman> createState() => _NatureOfHumanState();
}

class _NatureOfHumanState extends State<NatureOfHuman> {
  List<Map<String, dynamic>> checkedTag = [];

  List<PostListModel> filteredList = [];
  List<PostListModel> postList = [];
  List<TagModel> tagList = [];
  List<bool> isHearted = [];

  @override
  void initState() {
    getTagList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        color: MyColors.primaryColor,
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
                          return InkWell(
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
                                onRefresh: getPostList,
                                postItem: filteredList.isNotEmpty
                                    ? filteredList[index]
                                    : postList[index],
                                isHearted: isHearted[index]),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(
                              endIndent: 20,
                              indent: 20,
                            ));
                  } else {
                    return Container();
                  }
                } else {
                  return const Center(
                      child: CircularProgressIndicator(
                          color: MyColors.primaryColor));
                }
              },
            );
          } else {
            return const Center(
                child: Text(
              "Нэвтэрч орон үргэлжлүүлнэ үү.",
              style: TextStyle(color: MyColors.gray),
            ));
          }
        }),
      ),
      floatingActionButton: FilterButton(onPress: () {
        showModalTag(context, checkedTag);
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  showModalTag(BuildContext context, List<Map<String, dynamic>> checkedTag) {
    showModalBottomSheet(
        context: context,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height - 80,
          minHeight: MediaQuery.of(context).size.height / 2 + 80,
        ),
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        builder: (_) => FilterModal(
              onTap: (checked) {
                setState(() {
                  checkedTag = checked;
                });
                filterPost(tagList);
                Navigator.pop(context, filteredList);
              },
              tagList: tagList,
            ));
  }

  Future<void> _refresh() async {
    setState(() {
      getPostList();
    });
  }

  filterPost(List<TagModel> tagList) {
    List<Map<String, dynamic>> selectedTagsName = [];
    setState(() {
      for (var item in postList) {
        for (var id in checkedTag) {
          if (item.tags!.isNotEmpty) {
            if (item.tags?.first.id == id &&
                !filteredList.any((element) => element.id == item.id)) {
              filteredList.add(item);
            } else {
              filteredList = [];
            }
          }
          for (var name in tagList) {
            if (name.id == id) {
              selectedTagsName.add({"name ": name.name, "id": name.id});
              Provider.of<ForumTagNotifier>(context, listen: false)
                  .setTags(selectedTagsName);
            }
          }
        }
      }
      print(filteredList);
      if (checkedTag.isEmpty) {
        filteredList.clear();
      }
    });
  }

  Future getPostList() {
    return Connection.getPostList(context, {"post_type": 0});
  }

  Future<void> getTagList() async {
    var data = await Connection.getTagList(context);
    setState(() {
      tagList = data;
    });
  }
}
