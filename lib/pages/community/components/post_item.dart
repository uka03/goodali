import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:goodali/connection/models/post_response.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/community/post_detail.dart';
import 'package:goodali/pages/community/provider/community_provider.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/shared/components/custom_read_more.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/constants.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/utils.dart';
import 'package:intl/intl.dart';

class PostItem extends StatefulWidget {
  const PostItem({super.key, this.post, required this.provider});
  final PostResponseData? post;
  final CommunityProvider provider;

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  @override
  Widget build(BuildContext context) {
    String? purchaseDate;

    if (widget.post?.createdAt?.isNotEmpty == true) {
      final parsedDate =
          DateFormat('E, d MMM yyyy HH:mm:ss').parse(widget.post!.createdAt!);
      purchaseDate = DateFormat('yyyy.MM.dd').format(parsedDate);
    }
    return CustomButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostDetail(
                post: widget.post,
              ),
            ));
      },
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        imageUrl: widget.post?.avatar?.toUrl(isUser: true) ??
                            userPlaceholder,
                        width: 30,
                        height: 30,
                        fit: BoxFit.cover,
                      ),
                    ),
                    HSpacer(size: 10),
                    Text(
                      widget.post?.nickname ?? "",
                      style: GoodaliTextStyles.bodyText(context, fontSize: 14),
                    ),
                    Container(
                      padding: EdgeInsets.all(3),
                      child: Text(
                        "•",
                        style: GoodaliTextStyles.bodyText(
                          context,
                          textColor: GoodaliColors.grayColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Text(
                      purchaseDate ?? "",
                      style: GoodaliTextStyles.bodyText(
                        context,
                        fontSize: 14,
                        textColor: GoodaliColors.grayColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          VSpacer(),
          widget.post?.tags?.isNotEmpty == true
              ? SizedBox(
                  height: 28,
                  child: ListView.separated(
                    reverse: true,
                    scrollDirection: Axis.horizontal,
                    itemCount:
                        getListViewlength(widget.post?.tags?.length, max: 3),
                    separatorBuilder: (context, index) => HSpacer(),
                    itemBuilder: (context, index) {
                      final tag = widget.post?.tags?[index];
                      return Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: GoodaliColors.primaryColor,
                                )),
                            child: Text(
                              tag?.name ?? "",
                              style: GoodaliTextStyles.bodyText(context,
                                  textColor: GoodaliColors.primaryColor),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                )
              : SizedBox(),
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.post?.title ?? "",
                  style: GoodaliTextStyles.titleText(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          VSpacer(),
          CustomReadMore(
            text: widget.post?.body ?? "",
            trimLines: 5,
          ),
          VSpacer(),
          Row(
            children: [
              actionBtn(
                context,
                count: widget.post?.likes,
                iconPath:
                    "assets/icons/ic_heart${widget.post?.selfLike == true ? "_active" : ""}.png",
                onPressed: () async {
                  if (widget.post?.id == null) return;
                  if (widget.post?.selfLike == true) {
                    final isresp =
                        await widget.provider.postDisLike(id: widget.post!.id!);
                    if (isresp) {
                      setState(() {
                        widget.post?.selfLike = false;
                        widget.post?.likes = (widget.post?.likes ?? 0) - 1;
                      });
                    }
                  } else {
                    final isresp =
                        await widget.provider.postLike(id: widget.post!.id!);
                    if (isresp) {
                      setState(() {
                        widget.post!.selfLike = true;
                        widget.post?.likes = (widget.post?.likes ?? 0) + 1;
                      });
                    }
                  }
                },
              ),
              HSpacer(),
              actionBtn(
                context,
                count: widget.post?.replyList.length,
                iconPath: "assets/icons/ic_chat.png",
                onPressed: () {},
              ),
            ],
          )
        ],
      ),
    );
  }

  Row actionBtn(
    BuildContext context, {
    int? count,
    required String iconPath,
    required Function() onPressed,
  }) {
    return Row(
      children: [
        CustomButton(
          onPressed: onPressed,
          child: Image.asset(
            iconPath,
            width: 24,
            height: 24,
            color: GoodaliColors.primaryColor,
          ),
        ),
        HSpacer(size: 10),
        Text(
          (count ?? 0).toString(),
          style: GoodaliTextStyles.bodyText(
            context,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
