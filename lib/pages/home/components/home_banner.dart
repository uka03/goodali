import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:goodali/connection/models/banner_response.dart';
import 'package:goodali/pages/lesson/lesson_detail.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/shared/components/custom_indicator.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/constants.dart';
import 'package:skeletons/skeletons.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner(
      {super.key,
      required this.banners,
      required this.bannerIndex,
      required this.onChanged});
  final List<BannerResponseData> banners;
  final int bannerIndex;
  final Function(int index) onChanged;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Skeleton(
          isLoading: banners.isEmpty == true,
          skeleton: bannerSkeleton(context),
          child: banner(context),
        ),
        Positioned.fill(
          bottom: 10,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: CustomIndicator(
              dotSize: 8,
              color: GoodaliColors.blackColor,
              current: bannerIndex,
              activeDotSize: 15,
              length: banners.length,
            ),
          ),
        )
      ],
    );
  }

  CarouselSlider banner(BuildContext context) {
    return CarouselSlider(
      items: banners.map(
        (banner) {
          return CustomButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LessonDetail(
                      id: banner.productId,
                    ),
                  ));
            },
            child: Padding(
              padding: kIsWeb
                  ? EdgeInsets.symmetric(horizontal: 30.0)
                  : EdgeInsets.zero,
              child: ClipRRect(
                borderRadius:
                    kIsWeb ? BorderRadius.circular(16) : BorderRadius.zero,
                child: CachedNetworkImage(
                  imageUrl: banner.banner?.toUrl() ?? placeholder,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ).toList(),
      options: CarouselOptions(
        padEnds: kIsWeb,
        aspectRatio: kIsWeb ? 16 / 6 : 1.6,
        viewportFraction: kIsWeb ? 0.8 : 1,
        enlargeCenterPage: false,
        initialPage: 0,
        enableInfiniteScroll: true,
        disableCenter: kIsWeb,
        autoPlay: !kIsWeb,
        scrollDirection: Axis.horizontal,
        onPageChanged: (index, _) {
          onChanged(index);
        },
      ),
    );
  }

  CarouselSlider bannerSkeleton(BuildContext context) {
    return CarouselSlider(
      items: List.generate(
        4,
        (index) => SkeletonAvatar(
          style: SkeletonAvatarStyle(
            width: double.infinity,
          ),
        ),
      ),
      options: CarouselOptions(
        padEnds: kIsWeb,
        aspectRatio: kIsWeb ? 16 / 6 : 1.6,
        viewportFraction: kIsWeb ? 0.8 : 1,
        enlargeCenterPage: false,
        initialPage: 0,
        enableInfiniteScroll: true,
        disableCenter: kIsWeb,
        autoPlay: !kIsWeb,
        scrollDirection: Axis.horizontal,
        onPageChanged: (index, _) {
          onChanged(index);
        },
      ),
    );
  }
}
