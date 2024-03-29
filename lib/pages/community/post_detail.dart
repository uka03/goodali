import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:goodali/connection/models/login_response.dart';
import 'package:goodali/connection/models/post_response.dart';
import 'package:goodali/connection/models/tag_response.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/auth/provider/auth_provider.dart';
import 'package:goodali/pages/community/provider/community_provider.dart';
import 'package:goodali/shared/components/appbar_with_back.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/shared/components/custom_input.dart';
import 'package:goodali/shared/components/general_scaffold.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/constants.dart';
import 'package:goodali/utils/globals.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/toasts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostDetail extends StatefulWidget {
  const PostDetail({super.key, this.post});
  final PostResponseData? post;

  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  late CommunityProvider communityProvider;
  late AuthProvider authProvider;
  final focus = FocusNode();
  LoginResponse? me;

  @override
  void initState() {
    super.initState();
    communityProvider = Provider.of<CommunityProvider>(context, listen: false);
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final res = await authProvider.getMe();
      setState(() {
        me = res;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    TagResponseData? firstTag;
    String? purchaseDate;
    if (widget.post?.tags?.isNotEmpty == true) {
      firstTag = widget.post?.tags?.first;
    }

    if (widget.post?.createdAt?.isNotEmpty == true) {
      final parsedDate =
          DateFormat('E, d MMM yyyy HH:mm:ss').parse(widget.post!.createdAt!);
      purchaseDate = DateFormat('yyyy.MM.dd').format(parsedDate);
    }

    return GeneralScaffold(
      appBar: AppbarWithBackButton(
        title: "Сэтгэгдэл",
      ),
      child: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(16),
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
                              imageUrl:
                                  widget.post?.avatar?.toUrl(isUser: true) ??
                                      userPlaceholder,
                              width: 30,
                              height: 30,
                              fit: BoxFit.cover,
                            ),
                          ),
                          HSpacer(size: 10),
                          Text(
                            widget.post?.nickname ?? "",
                            style: GoodaliTextStyles.bodyText(context,
                                fontSize: 14),
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
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: GoodaliColors.primaryColor,
                          )),
                      child: Text(
                        firstTag?.name ?? "",
                        style: GoodaliTextStyles.bodyText(context,
                            textColor: GoodaliColors.primaryColor),
                      ),
                    )
                  ],
                ),
                VSpacer(),
                Text(widget.post?.body ?? ""),
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
                          final isresp = await communityProvider.postDisLike(
                              id: widget.post!.id!);
                          if (isresp) {
                            setState(() {
                              widget.post?.selfLike = false;
                              widget.post?.likes =
                                  (widget.post?.likes ?? 0) - 1;
                            });
                          }
                        } else {
                          final isresp = await communityProvider.postLike(
                              id: widget.post!.id!);
                          if (isresp) {
                            setState(() {
                              widget.post!.selfLike = true;
                              widget.post?.likes =
                                  (widget.post?.likes ?? 0) + 1;
                            });
                          }
                        }
                      },
                    ),
                    HSpacer(),
                    actionBtn(
                      context,
                      count: widget.post?.replyList?.length,
                      iconPath: "assets/icons/ic_chat.png",
                      onPressed: () {},
                    ),
                  ],
                ),
                VSpacer(size: 40),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        imageUrl:
                            me?.avatar?.toUrl(isUser: true) ?? userPlaceholder,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                    HSpacer(),
                    Expanded(
                      child: CustomInput(
                        prefixIcon: null,
                        withIcon: false,
                        readOnly: true,
                        hintText: "Сэтгэгдэл бичих",
                        controller: TextEditingController(),
                        onTap: () {
                          showReplyModal();
                          FocusScope.of(context).requestFocus(focus);
                        },
                      ),
                    ),
                  ],
                ),
                VSpacer(),
                Divider(),
                widget.post?.replyList?.isNotEmpty == true
                    ? ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: widget.post?.replyList?.length ?? 0,
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(),
                        itemBuilder: (context, index) {
                          final comment = widget.post?.replyList?[index];

                          return Container(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  comment?.nickname ?? "",
                                  style: GoodaliTextStyles.titleText(
                                    context,
                                    fontSize: 14,
                                  ),
                                ),
                                VSpacer(size: 10),
                                Text(
                                  comment?.text ?? "",
                                  style: GoodaliTextStyles.bodyText(context),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "assets/images/chat_empty.png",
                              height: 150,
                            ),
                            VSpacer(size: 30),
                            Text(
                              "Сэтгэгдэл байхгүй байна.",
                              style: GoodaliTextStyles.bodyText(context,
                                  fontSize: 14),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showReplyModal() {
    final commtentController = TextEditingController();

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) {
          return StatefulBuilder(builder:
              (BuildContext context, void Function(void Function()) setState) {
            return SingleChildScrollView(
                child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              decoration: BoxDecoration(color: GoodaliColors.primaryBGColor),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 80,
                    height: 70,
                    child: Center(
                      child: TextField(
                        focusNode: focus,
                        autofocus: true,
                        onSubmitted: (value) {
                          postReply(commtentController.text);
                        },
                        controller: commtentController,
                        cursorColor: GoodaliColors.primaryColor,
                        maxLines: null,
                        textInputAction: TextInputAction.send,
                        onChanged: (value) {},
                        decoration: const InputDecoration(
                            filled: false,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            border: InputBorder.none,
                            hintText: 'Сэтгэгдэл бичих...',
                            hintStyle:
                                TextStyle(color: GoodaliColors.grayColor)),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send,
                        color: GoodaliColors.primaryColor),
                    onPressed: () {
                      postReply(commtentController.text);
                    },
                  )
                ],
              ),
            ));
          });
        });
  }

  postReply(String text) async {
    if (text.length < 30) {
      Toast.error(context,
          description:
              "Таны сэтгэгдэл хамгийн багадаа 30 тэмдэгт ашигласан байх шаардлагатай.",
          title: "Анхаарна уу");
    } else {
      showLoader();
      final response = await communityProvider.postReply(
        body: text,
        postId: widget.post?.id,
      );
      if (response && context.mounted) {
        Toast.success(context, description: "Амжилтай");
      }
      dismissLoader();
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
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