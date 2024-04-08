import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:skeletons/skeletons.dart';

class PodcastSkeleton extends StatelessWidget {
  const PodcastSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonAvatar(
                style: SkeletonAvatarStyle(
                  width: 40,
                  height: 40,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              HSpacer(),
              Expanded(
                child: Column(
                  children: [
                    SkeletonParagraph(
                      style: SkeletonParagraphStyle(
                        lines: 1,
                        lineStyle: SkeletonLineStyle(
                          height: 16,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    VSpacer.xs(),
                    SkeletonParagraph(
                      style: SkeletonParagraphStyle(
                        lines: 2,
                        lineStyle: SkeletonLineStyle(
                          height: 12,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              SkeletonAvatar(
                style: SkeletonAvatarStyle(
                  width: 40,
                  height: 40,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              HSpacer(),
              SizedBox(
                width: 100,
                child: SkeletonParagraph(
                  style: SkeletonParagraphStyle(
                    lines: 1,
                    lineStyle: SkeletonLineStyle(
                      height: 12,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
