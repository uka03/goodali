import 'package:flutter/material.dart';
import 'package:goodali/connection/models/product_response.dart';
import 'package:goodali/pages/album/album_page.dart';
import 'package:goodali/pages/home/components/lecture_card.dart';
import 'package:goodali/shared/components/custom_title.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/utils.dart';

class LecturesSection extends StatelessWidget {
  const LecturesSection({super.key, required this.lectures});
  final List<ProductResponseData?> lectures;

  @override
  Widget build(BuildContext context) {
    return lectures.isNotEmpty
        ? Column(
            children: [
              CustomTitle(
                title: 'Цомог лекц',
                onArrowPressed: () {
                  Navigator.pushNamed(context, AlbumPage.routeName);
                },
              ),
              VSpacer(),
              SizedBox(
                height: 250,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: getListViewlength(lectures.length, max: 5),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  separatorBuilder: (context, index) => HSpacer(),
                  itemBuilder: (context, index) {
                    final lecture = lectures[index];
                    return LectureCard(lecture: lecture);
                  },
                ),
              ),
            ],
          )
        : SizedBox();
  }
}
