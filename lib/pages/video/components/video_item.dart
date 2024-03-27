import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:goodali/connection/models/video_response.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/video/video_player.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/utils/constants.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:intl/intl.dart';

class VideoItem extends StatelessWidget {
  const VideoItem({
    super.key,
    required this.video,
    this.onItemPressed,
  });

  final VideoResponseData? video;

  final Function(VideoResponseData? video)? onItemPressed;

  @override
  Widget build(BuildContext context) {
    String? purchaseDate;

    if (video?.createdAt?.isNotEmpty == true) {
      final parsedDate =
          DateFormat('E, d MMM yyyy HH:mm:ss').parse(video!.createdAt!);
      purchaseDate = DateFormat('yyyy.MM.dd').format(parsedDate);
    }
    return CustomButton(
      onPressed: () {
        if (onItemPressed != null) {
          onItemPressed!(video);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoPlayer(
                video: video,
              ),
            ),
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            height: 190,
            width: double.infinity,
            imageUrl: video?.banner?.toUrl() ?? placeholder,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video?.title ?? "",
                  style: GoodaliTextStyles.titleText(context),
                ),
                Text(
                  purchaseDate ?? "",
                  style: GoodaliTextStyles.bodyText(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
