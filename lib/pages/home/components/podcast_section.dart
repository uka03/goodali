import 'package:flutter/material.dart';
import 'package:goodali/connection/models/product_response.dart';
import 'package:goodali/pages/podcast/components/podcast_item.dart';
import 'package:goodali/pages/podcast/podcast_page.dart';
import 'package:goodali/shared/components/custom_title.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/utils.dart';

class PodcastSection extends StatelessWidget {
  const PodcastSection({
    super.key,
    required this.podcasts,
  });
  final List<ProductResponseData?> podcasts;

  @override
  Widget build(BuildContext context) {
    return podcasts.isNotEmpty
        ? Column(
            children: [
              CustomTitle(
                title: 'Подкаст',
                onArrowPressed: () {
                  Navigator.pushNamed(context, PodcastPage.routeName);
                },
              ),
              VSpacer(),
              ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: getListViewlength(podcasts.length),
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
                  final podcast = podcasts[index];
                  return podcast != null
                      ? PodcastItem(podcast: podcast)
                      : SizedBox();
                },
              ),
            ],
          )
        : SizedBox();
  }
}
