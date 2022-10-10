import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/filter_button.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/models/post_list_model.dart';
import 'package:goodali/screens/ForumScreen/post_detail.dart';
import 'package:goodali/screens/ListItems/post_item.dart';
import 'package:iconly/iconly.dart';

class NatureOfHuman extends StatefulWidget {
  const NatureOfHuman({Key? key}) : super(key: key);

  @override
  State<NatureOfHuman> createState() => _NatureOfHumanState();
}

class _NatureOfHumanState extends State<NatureOfHuman> {
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
      floatingActionButton: FilterButton(onPress: () {}),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
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
