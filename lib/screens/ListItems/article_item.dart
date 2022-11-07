import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Utils/utils.dart';

import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/models/article_model.dart';

class ArtcileItem extends StatelessWidget {
  final ArticleModel articleModel;
  const ArtcileItem({Key? key, required this.articleModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 30.0, left: 20, right: 20, bottom: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: ImageView(
              imgPath: articleModel.banner ?? "",
              width: 70,
              height: 70,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(articleModel.title ?? "",
                      style: const TextStyle(
                        fontSize: 16,
                        color: MyColors.black,
                      )),
                  const SizedBox(height: 4),
                  articleModel.createdAt == "" || articleModel.createdAt == null
                      ? Text(dateTimeFormatter(articleModel.createdAt ?? ""),
                          style: const TextStyle(
                            fontSize: 12,
                            color: MyColors.primaryColor,
                          ))
                      : Container(),
                  const SizedBox(height: 10),
                  Text(
                    parseHtmlString(articleModel.body ?? ""),
                    style: const TextStyle(
                        fontSize: 12, color: MyColors.gray, height: 1.5),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
