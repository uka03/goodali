import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:goodali/connection/models/article_response.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/article/components/article_item.dart';
import 'package:goodali/pages/article/provider/article_provider.dart';
import 'package:goodali/shared/components/appbar_with_back.dart';
import 'package:goodali/shared/components/general_scaffold.dart';
import 'package:goodali/utils/constants.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:provider/provider.dart';

class ArticleDetail extends StatefulWidget {
  const ArticleDetail({super.key, this.article});

  static String routeName = "/article_detail";
  final ArticleResponseData? article;

  @override
  State<ArticleDetail> createState() => _ArticleDetailState();
}

class _ArticleDetailState extends State<ArticleDetail> {
  late ArticleResponseData? article;
  late ArticleProvider? articleProvider;
  @override
  void initState() {
    super.initState();
    article = widget.article;
    articleProvider = Provider.of<ArticleProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      articleProvider?.getArticleList(article?.id.toString() ?? "");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ArticleProvider>(
      builder: (context, provider, _) {
        return GeneralScaffold(
          appBar: AppbarWithBackButton(),
          child: SingleChildScrollView(
            child: Container(
              margin: kIsWeb ? EdgeInsets.symmetric(horizontal: 155) : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CachedNetworkImage(
                    imageUrl: article?.banner.toUrl() ?? placeholder,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Text(
                          article?.title ?? "",
                          textAlign: TextAlign.center,
                          style: GoodaliTextStyles.titleText(
                            context,
                            fontSize: 20,
                          ),
                        ),
                        VSpacer(),
                        HtmlWidget(
                          article?.body ?? "",
                          textStyle: GoodaliTextStyles.bodyText(
                            context,
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Төстэй бичвэрүүд",
                      style: GoodaliTextStyles.titleText(context, fontSize: 24),
                    ),
                  ),
                  ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: provider.articleList.length,
                    separatorBuilder: (context, index) => Divider(height: 0),
                    itemBuilder: (context, index) {
                      final article = provider.articleList[index];
                      return ArticleItem(article: article);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
