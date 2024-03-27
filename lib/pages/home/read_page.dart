import 'package:flutter/material.dart';
import 'package:goodali/pages/article/article_page.dart';
import 'package:goodali/pages/article/components/article_item.dart';
import 'package:goodali/pages/home/provider/home_provider.dart';
import 'package:goodali/shared/components/custom_title.dart';
import 'package:goodali/utils/utils.dart';

class ReadPage extends StatelessWidget {
  const ReadPage({super.key, required this.homeProvider});
  final HomeProvider homeProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(),
        CustomTitle(
          title: "Бичвэр",
          onArrowPressed: () {
            Navigator.pushNamed(context, ArticlePage.routeName);
          },
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: getListViewlength(homeProvider.articles?.length),
          separatorBuilder: (context, index) => Divider(height: 0),
          itemBuilder: (context, index) {
            final article = homeProvider.articles?[index];
            return ArticleItem(article: article);
          },
        )
      ],
    );
  }
}
