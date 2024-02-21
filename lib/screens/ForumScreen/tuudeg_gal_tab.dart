import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:goodali/Providers/auth_provider.dart';
import 'package:goodali/Providers/forum_tag_notifier.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/filter_button.dart';
import 'package:goodali/Widgets/filter_modal.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/models/post_list_model.dart';
import 'package:goodali/models/tag_model.dart';
import 'package:goodali/screens/Auth/login.dart';
import 'package:goodali/screens/ForumScreen/post_detail.dart';
import 'package:goodali/screens/HomeScreen/courseTab/course_tab.dart';
import 'package:goodali/screens/ListItems/post_item.dart';
import 'package:provider/provider.dart';

class NuutsBulgem extends StatefulWidget {
  const NuutsBulgem({Key? key}) : super(key: key);

  @override
  State<NuutsBulgem> createState() => _NuutsBulgemState();
}

class _NuutsBulgemState extends State<NuutsBulgem> {
  List<Map<String, dynamic>> checkedTag = [];
  List<bool> isHearted = [];
  List<PostListModel> filteredList = [];
  List<PostListModel> postList = [];
  List<TagModel> tagList = [];
  bool isAuth = false;
  bool hasTraining = false;
  bool loginWithBio = false;

  @override
  void initState() {
    isAuth = Provider.of<Auth>(context, listen: false).isAuth;
    hasTraining = Provider.of<Auth>(context, listen: false).hasTraining;

    getTagList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var login = Provider.of<Auth>(context, listen: false);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Consumer<ForumTagNotifier>(
          builder: (BuildContext context, value, Widget? child) {
            checkedTag = value.selectedForumNames;

            if (isAuth && hasTraining) {
              return FutureBuilder(
                  future: getPostList(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData && ConnectionState.done == snapshot.connectionState) {
                      postList = snapshot.data;
                      if (checkedTag.isNotEmpty) {
                        for (var item in checkedTag) {
                          filteredList = postList.where((element) => element.tags!.first.id == item["id"]).toList();
                        }
                      } else {
                        filteredList.clear();
                      }
                      if (postList.isNotEmpty) {
                        return ListView.separated(
                            itemCount: filteredList.isNotEmpty ? filteredList.length : postList.length,
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
                                            postItem: filteredList.isNotEmpty ? filteredList[index] : postList[index],
                                            isHearted: isHearted[index]))),
                                child: PostItem(
                                    postItem: filteredList.isNotEmpty ? filteredList[index] : postList[index],
                                    onRefresh: () {
                                      setState(() {
                                        getPostList();
                                      });
                                    },
                                    isHearted: isHearted[index]),
                              );
                            },
                            separatorBuilder: (BuildContext context, int index) => const Divider(
                                  endIndent: 18,
                                  indent: 18,
                                ));
                      } else {
                        return Container();
                      }
                    } else {
                      return const Center(child: CircularProgressIndicator(color: MyColors.primaryColor));
                    }
                  });
            } else if (isAuth && !hasTraining) {
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
                        if (isAuth) {
                          Navigator.push(
                              context, MaterialPageRoute(builder: (_) => const CourseTabbar(isHomeScreen: false)));
                        } else {
                          login.loginWithBio
                              ? login.authenticateWithBiometrics(context)
                              : showModalBottomSheet(
                                  context: context,
                                  isDismissible: false,
                                  enableDrag: true,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12), topRight: Radius.circular(12))),
                                  builder: (BuildContext context) => const LoginBottomSheet(isRegistered: true));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
                          elevation: 0,
                          backgroundColor: MyColors.primaryColor)),
                ],
              ));
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
      floatingActionButton: (kIsWeb || !hasTraining)
          ? null
          : FilterButton(onPress: () {
              showModalTag(context, checkedTag);
            }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future<void> _refresh() async {
    setState(() {
      getPostList();
    });
  }

  Future getPostList() {
    return Connection.getPostList(context, {"post_type": 1});
  }

  showModalTag(BuildContext context, List<Map<String, dynamic>> checkedTag) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
      builder: (_) => FilterModal(
        onTap: (checked) {
          setState(() {
            checkedTag = checked;
          });

          Navigator.pop(context);
        },
        tagList: tagList,
      ),
    );
  }

  Future<void> getTagList() async {
    var data = await Connection.getTagList(context);
    if (mounted) {
      setState(() {
        tagList = data;
      });
    }
  }
}
