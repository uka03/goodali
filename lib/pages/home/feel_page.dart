import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/feel/feel_detail.dart';
import 'package:goodali/pages/home/provider/home_provider.dart';
import 'package:goodali/pages/podcast/components/podcast_item.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';

class FeelPage extends StatelessWidget {
  const FeelPage({super.key, required this.homeProvider});
  final HomeProvider homeProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VSpacer(),
        Text(
          "Мүүд",
          style: GoodaliTextStyles.titleText(
            context,
            fontSize: 24,
          ),
        ),
        VSpacer(size: 20),
        ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: homeProvider.moodMain?.length ?? 0,
          separatorBuilder: (context, index) => Divider(),
          itemBuilder: (context, index) {
            final mood = homeProvider.moodMain?[index];
            return PodcastItem(
              podcast: mood,
            );
          },
        ),
        GridView.builder(
          padding: EdgeInsets.all(16),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: homeProvider.moodList?.length ?? 0,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 0.8,
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final mood = homeProvider.moodList?[index];
            return CustomButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FeelDetail(
                      data: mood,
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(80),
                      child: CachedNetworkImage(
                        imageUrl: mood?.banner.toUrl() ?? "",
                        width: MediaQuery.of(context).size.width / 3 - 30,
                        height: MediaQuery.of(context).size.width / 3 - 30,
                        fit: BoxFit.cover,
                      )),
                  const SizedBox(height: 10),
                  Text(
                    mood?.title ?? "",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: GoodaliColors.blackColor,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        Container(),
      ],
    );
  }
}
