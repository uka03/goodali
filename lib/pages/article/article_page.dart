import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:goodali/pages/article/components/article_item.dart';
import 'package:goodali/pages/article/provider/article_provider.dart';
import 'package:goodali/shared/components/appbar_with_back.dart';
import 'package:goodali/shared/components/custom_appbar.dart';
import 'package:goodali/shared/components/general_scaffold.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:provider/provider.dart';

class ArticlePage extends StatefulWidget {
  const ArticlePage({super.key});

  static String routeName = "/article_page";

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  late ArticleProvider articleProvider;
  @override
  void initState() {
    articleProvider = Provider.of<ArticleProvider>(context, listen: false);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arg = ModalRoute.of(context)?.settings.arguments as Map<String, int?>?;
      articleProvider.getArticles(id: arg?["id"]);
    });
  }

  @override
  void dispose() {
    super.dispose();
    articleProvider.articles = [];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ArticleProvider>(builder: (context, provider, _) {
      return GeneralScaffold(
        appBar: kIsWeb ? CustomWebAppbar() : AppbarWithBackButton() as PreferredSizeWidget,
        child: Container(
          margin: kIsWeb ? EdgeInsets.symmetric(horizontal: 155) : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: Text(
                  "Бичвэр",
                  style: GoodaliTextStyles.titleText(context, fontSize: 32),
                ),
              ),
              Expanded(
                child: kIsWeb
                    ? GridView.builder(
                        padding: EdgeInsets.all(16),
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: provider.articles.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 2,
                          crossAxisCount: 3,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) {
                          final article = provider.articles[index];
                          return ArticleItem(article: article);
                        },
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: provider.articles.length,
                        separatorBuilder: (context, index) => Divider(height: 0),
                        itemBuilder: (context, index) {
                          final article = provider.articles[index];
                          return ArticleItem(article: article);
                        },
                      ),
              )
            ],
          ),
        ),
      );
    });
  }
}
