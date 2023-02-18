import 'package:flutter/material.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/models/article_model.dart';
import 'package:goodali/screens/HomeScreen/readTab/article_detail.dart';
import 'package:goodali/screens/HomeScreen/readTab/article_screen.dart';
import 'package:goodali/screens/HomeScreen/readTab/online_book.dart';
import 'package:goodali/screens/ListItems/article_item.dart';
import 'package:iconly/iconly.dart';

class ReadTabbar extends StatefulWidget {
  const ReadTabbar({Key? key}) : super(key: key);

  @override
  State<ReadTabbar> createState() => _ReadTabbarState();
}

class _ReadTabbarState extends State<ReadTabbar>
    with AutomaticKeepAliveClientMixin<ReadTabbar> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: FutureBuilder(
        future: getArticle(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            List<ArticleModel> articleList = snapshot.data;
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // for (var item in articleList)
                //   if (item.isSpecial == 1)
                //     Padding(
                //       padding: const EdgeInsets.only(top: 20, left: 20),
                //       child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             const Text("Онцлох",
                //                 style: TextStyle(
                //                     color: MyColors.black,
                //                     fontSize: 20,
                //                     fontWeight: FontWeight.bold)),
                //             ArtcileItem(articleModel: item),
                //           ]),
                //     ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Бичвэр",
                            style: TextStyle(
                                color: MyColors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold)),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const ArticleScreen()));
                            },
                            child: const Icon(IconlyLight.arrow_right))
                      ],
                    )),
                article(context, articleList)
              ],
            );
          } else {
            return const Center(
                child: CircularProgressIndicator(color: MyColors.primaryColor));
          }
        },
      ),
    );
  }

  Widget onlineBook(BuildContext context) {
    return SizedBox(
      height: 200,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const OnlineBook())),
              child: Container(
                margin: const EdgeInsets.all(15),
                width: 130,
                color: Colors.red,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(15),
              width: 130,
              color: Colors.red,
            ),
            Container(
              margin: const EdgeInsets.all(15),
              width: 130,
              color: Colors.red,
            ),
            Container(
              margin: const EdgeInsets.all(15),
              width: 130,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget article(BuildContext context, List<ArticleModel> articleList) {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: articleList.length > 6 ? 6 : articleList.length,
        separatorBuilder: (BuildContext context, int index) =>
            const Divider(color: MyColors.border1, endIndent: 20, indent: 20),
        itemBuilder: (context, index) => GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ArticleDetail(articleItem: articleList[index]))),
            child: ArtcileItem(articleModel: articleList[index])));
  }

  Future<List<ArticleModel>> getArticle() {
    return Connection.getArticle(context);
  }

  @override
  bool get wantKeepAlive => true;
}
