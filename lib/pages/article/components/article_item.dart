import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:goodali/connection/models/article_response.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/article/article_detail.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/constants.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/utils.dart';
import 'package:intl/intl.dart';

class ArticleItem extends StatelessWidget {
  const ArticleItem({
    super.key,
    required this.article,
  });

  final ArticleResponseData? article;

  @override
  Widget build(BuildContext context) {
    String? purchaseDate;

    if (article?.createdAt?.isNotEmpty == true) {
      final parsedDate =
          DateFormat('E, d MMM yyyy HH:mm:ss').parse(article!.createdAt!);
      purchaseDate = DateFormat('yyyy.MM.dd').format(parsedDate);
    }
    return CustomButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticleDetail(
                article: article,
              ),
            ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: article?.banner?.toUrl() ?? placeholder,
                height: 73,
                width: 73,
                fit: BoxFit.cover,
              ),
            ),
            HSpacer(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article?.title ?? "",
                    style: GoodaliTextStyles.titleText(
                      context,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  VSpacer(size: 6),
                  Text(
                    purchaseDate ?? "",
                    style: GoodaliTextStyles.bodyText(
                      context,
                      textColor: GoodaliColors.primaryColor,
                    ),
                  ),
                  VSpacer(size: 12),
                  Text(
                    removeHtmlTags(article?.body ?? ""),
                    style: GoodaliTextStyles.bodyText(context),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
