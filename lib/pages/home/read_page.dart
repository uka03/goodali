import 'package:flutter/material.dart';
import 'package:goodali/pages/article/article_page.dart';
import 'package:goodali/pages/article/components/article_item.dart';
import 'package:goodali/pages/home/provider/home_provider.dart';
import 'package:goodali/shared/components/custom_title.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/utils.dart';
import 'package:skeletons/skeletons.dart';

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
        Skeleton(
          isLoading: homeProvider.articles?.isEmpty == true,
          skeleton: ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 3,
            separatorBuilder: (context, index) => Divider(height: 0),
            itemBuilder: (context, index) {
              return ArticleSkeleton();
            },
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: getListViewlength(homeProvider.articles?.length),
            separatorBuilder: (context, index) => Divider(height: 0),
            itemBuilder: (context, index) {
              final article = homeProvider.articles?[index];
              return ArticleItem(article: article);
            },
          ),
        ),
      ],
    );
  }
}

class ArticleSkeleton extends StatelessWidget {
  const ArticleSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonAvatar(
            style: SkeletonAvatarStyle(
              height: 73,
              width: 73,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          HSpacer(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonParagraph(
                  style: SkeletonParagraphStyle(
                    lineStyle: SkeletonLineStyle(
                      height: 14,
                    ),
                    lines: 2,
                  ),
                ),
                VSpacer(size: 6),
                SkeletonParagraph(
                  style: SkeletonParagraphStyle(
                    lines: 1,
                    lineStyle: SkeletonLineStyle(
                      width: 50,
                      height: 12,
                    ),
                  ),
                ),
                VSpacer(size: 4),
                SkeletonParagraph(
                  style: SkeletonParagraphStyle(
                    lines: 2,
                    lineStyle: SkeletonLineStyle(
                      height: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
