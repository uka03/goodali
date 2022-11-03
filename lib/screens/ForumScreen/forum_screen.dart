import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/custom_appbar.dart';
import 'package:goodali/Widgets/my_delegate.dart';
import 'package:goodali/Providers/forum_tag_notifier.dart';
import 'package:goodali/screens/ForumScreen/create_post_screen.dart';
import 'package:goodali/screens/ForumScreen/human_nature_tab.dart';
import 'package:goodali/screens/ForumScreen/my_friend_tab.dart';
import 'package:goodali/screens/ForumScreen/tuudeg_gal_tab.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class ForumScreen extends StatefulWidget {
  final VoidCallback goToFirstTab;

  const ForumScreen({Key? key, required this.goToFirstTab}) : super(key: key);

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Түүдэг гал',
        actionButton2: IconButton(
            onPressed: () {},
            icon: const Icon(IconlyLight.bookmark,
                size: 28, color: MyColors.black)),
        actionButton1: IconButton(
            onPressed: () {},
            icon:
                const Icon(IconlyLight.heart, size: 28, color: MyColors.black)),
        isCartButton: false,
      ),
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          physics: const NeverScrollableScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                collapsedHeight: 80,
                expandedHeight: 80,
                backgroundColor: Colors.white,
                flexibleSpace: Container(
                  margin: const EdgeInsets.all(18),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    color: MyColors.input,
                  ),
                  child: Row(
                    children: [
                      const Icon(IconlyLight.edit),
                      const SizedBox(width: 14),
                      SizedBox(
                        width: 200,
                        child: TextField(
                          onTap: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const CreatePost()));
                          },
                          cursorColor: MyColors.primaryColor,
                          decoration: const InputDecoration(
                              border: InputBorder.none, hintText: "Пост нэмэх"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPersistentHeader(
                  floating: false,
                  pinned: true,
                  delegate: MyDelegate(
                      const TabBar(
                        isScrollable: true,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        tabs: [
                          SizedBox(
                              width: 110, child: Tab(text: "Хүний байгаль")),
                          SizedBox(width: 110, child: Tab(text: "Нууц бүлгэм")),
                          SizedBox(width: 110, child: Tab(text: "Миний нандин"))
                        ],
                        labelColor: MyColors.primaryColor,
                        unselectedLabelColor: MyColors.black,
                        indicatorColor: MyColors.primaryColor,
                      ),
                      container:
                          // context
                          //         .watch<ForumTagNotifier>()
                          //         .selectedForumNames
                          //         .isEmpty?
                          null
                      // : Consumer<ForumTagNotifier>(
                      //     builder:
                      //         (BuildContext context, value, Widget? child) {
                      //       return SizedBox(
                      //         height: 40,
                      //         width: MediaQuery.of(context).size.width,
                      //         child: ListView(
                      //             scrollDirection: Axis.horizontal,
                      //             children: value.selectedForumNames
                      //                 .map((e) => Padding(
                      //                       padding: const EdgeInsets.only(
                      //                           left: 8.0),
                      //                       child: Chip(
                      //                         padding:
                      //                             const EdgeInsets.all(2.0),
                      //                         side: const BorderSide(
                      //                             color: MyColors.border2,
                      //                             width: 0.5),
                      //                         backgroundColor: Colors.white,
                      //                         label: Text(
                      //                           e,
                      //                           style: const TextStyle(
                      //                               color: MyColors.black),
                      //                         ),
                      //                         deleteIcon: const Icon(
                      //                             Icons.close,
                      //                             size: 20),
                      //                         onDeleted: () {
                      //                           value.removeTags(e);
                      //                         },
                      //                       ),
                      //                     ))
                      //                 .toList()),
                      //       );
                      //     },
                      //   )
                      ))
            ];
          },
          body: TabBarView(children: [
            const NatureOfHuman(),
            NuutsBulgem(goToFirstTab: widget.goToFirstTab),
            MyFriendTab(goToFirstTab: widget.goToFirstTab)
          ]),
        ),
      ),
    );
  }
}
