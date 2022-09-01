import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/models/article_model.dart';

class ArtcileItem extends StatelessWidget {
  final ArticleModel articleModel;
  const ArtcileItem({Key? key, required this.articleModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
              color: MyColors.secondary,
              borderRadius: BorderRadius.circular(12)),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(articleModel.title ?? "",
                    style: TextStyle(
                      fontSize: 16,
                      color: MyColors.black,
                    )),
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("4 min unshih",
                        style: TextStyle(
                          fontSize: 12,
                          color: MyColors.primaryColor,
                        )),
                    SizedBox(width: 5),
                    Icon(Icons.circle, color: MyColors.primaryColor, size: 4),
                    SizedBox(width: 5),
                    Text("2022.03.18",
                        style: TextStyle(
                          fontSize: 12,
                          color: MyColors.primaryColor,
                        ))
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  articleModel.body ?? "",
                  style: TextStyle(
                      fontSize: 12, color: MyColors.gray, height: 1.5),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
