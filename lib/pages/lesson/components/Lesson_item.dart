import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:goodali/connection/models/product_response.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/lesson/course_page.dart';
import 'package:goodali/pages/lesson/lesson_detail.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/constants.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';

class LessonItem extends StatelessWidget {
  const LessonItem({
    super.key,
    required this.lesson,
    this.isBought = false,
  });

  final ProductResponseData? lesson;
  final bool isBought;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Stack(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: lesson?.banner?.toUrl() ?? placeholder,
            height: kIsWeb ? null : 190,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          height: 130,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.transparent,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Positioned(
          left: 20,
          top: 30,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lesson?.name ?? "",
                style: GoodaliTextStyles.titleText(
                  context,
                  fontSize: 20,
                  textColor: GoodaliColors.whiteColor,
                ),
              ),
              VSpacer.sm(),
              isBought
                  ? Text(
                      "Огноо: ${lesson?.createdAt} - ${lesson?.expireAt}",
                      style: GoodaliTextStyles.titleText(
                        context,
                        textColor: GoodaliColors.whiteColor,
                      ),
                    )
                  : SizedBox()
            ],
          ),
        ),
        Positioned(
          bottom: 20,
          left: 20,
          child: CustomButton(
            onPressed: () {
              if (isBought) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CoursePage(
                      data: lesson,
                    ),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LessonDetail(
                      data: lesson,
                    ),
                  ),
                );
              }
            },
            child: Container(
              height: 40,
              width: 120,
              decoration: BoxDecoration(
                  color: GoodaliColors.inputColor,
                  borderRadius: BorderRadius.circular(6)),
              child: const Row(
                children: [
                  SizedBox(width: 15),
                  Text(
                    "Цааш үзэх",
                    style: TextStyle(
                        color: GoodaliColors.blackColor,
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Icon(
                    Icons.keyboard_arrow_right,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }
}
