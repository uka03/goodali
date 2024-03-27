import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:goodali/connection/models/product_response.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/album/album_detail.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/utils/constants.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';

class LectureCard extends StatelessWidget {
  const LectureCard({super.key, required this.lecture});
  final ProductResponseData? lecture;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPressed: () {
        Navigator.pushNamed(
          context,
          AlbumDetail.routeName,
          arguments: lecture,
        );
      },
      child: SizedBox(
        width: 170,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: lecture?.banner?.toUrl() ?? placeholder,
                width: 170,
                height: 170,
                fit: BoxFit.cover,
              ),
            ),
            VSpacer(size: 10),
            Text(
              lecture?.title ?? "",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoodaliTextStyles.bodyText(context, fontSize: 14),
            ),
            VSpacer(size: 4),
            Text(
              "${lecture?.audioCount ?? 0} аудио",
              style: GoodaliTextStyles.bodyText(context, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
