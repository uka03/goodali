import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/models/article_model.dart';
import 'package:goodali/screens/HomeScreen/readTab/article_detail.dart';
import 'package:goodali/screens/ListItems/article_item.dart';

class ArticleScreen extends StatefulWidget {
  final List<ArticleModel> articleModel;
  const ArticleScreen({Key? key, required this.articleModel}) : super(key: key);

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          physics: const NeverScrollableScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                pinned: true,
                floating: true,
                // snap: true,
                elevation: 0,
                iconTheme: const IconThemeData(color: MyColors.black),
                backgroundColor: Colors.white,
                bottom: PreferredSize(
                    preferredSize:
                        const Size(double.infinity, kToolbarHeight - 10),
                    child: Container(
                      padding: const EdgeInsets.only(left: 20),
                      alignment: Alignment.topLeft,
                      child: const Text("Бичвэр",
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: MyColors.black)),
                    )),
              ),
            ];
          },
          body: ListView.separated(
            itemCount: widget.articleModel.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ArticleDetail())),
                  child: ArtcileItem(
                    articleModel: widget.articleModel[index],
                  )),
            ),
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(
                    color: MyColors.border1, endIndent: 20, indent: 20),
          )),
    );
  }
}
