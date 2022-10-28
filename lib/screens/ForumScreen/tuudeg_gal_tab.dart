import 'package:flutter/material.dart';
import 'package:goodali/Providers/auth_provider.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/filter_button.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/models/post_list_model.dart';
import 'package:goodali/screens/Auth/login.dart';
import 'package:goodali/screens/ForumScreen/create_post_screen.dart';
import 'package:goodali/screens/ForumScreen/post_detail.dart';
import 'package:goodali/screens/HomeScreen/home_screen.dart';
import 'package:goodali/screens/ListItems/post_item.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class NuutsBulgem extends StatefulWidget {
  final void Function() goToFirstTab;
  const NuutsBulgem({Key? key, required this.goToFirstTab}) : super(key: key);

  @override
  State<NuutsBulgem> createState() => _NuutsBulgemState();
}

class _NuutsBulgemState extends State<NuutsBulgem> {
  List<bool> isHearted = [];
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
    return Connection.getPostList(context, {"post_type": 1});
  }
}
