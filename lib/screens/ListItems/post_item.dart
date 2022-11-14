import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Utils/utils.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/Widgets/top_snack_bar.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/models/post_list_model.dart';
import 'package:iconly/iconly.dart';

class PostItem extends StatefulWidget {
  final PostListModel postItem;
  final bool isHearted;
  final bool? isMySpecial;
  const PostItem(
      {Key? key,
      required this.postItem,
      required this.isHearted,
      this.isMySpecial = false})
      : super(key: key);

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  List<PostReplys> comments = [];
  bool isLiked = false;
  int likeCount = 0;
  @override
  void initState() {
    isLiked = widget.postItem.selfLike!;

    likeCount = widget.postItem.likes ?? 0;
    comments = widget.postItem.replys ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 30),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: ImageView(
                    imgPath: widget.postItem.avatar ?? "",
                    height: 24,
                    width: 24),
              ),
              const SizedBox(width: 10),
              Text(
                widget.postItem.nickName ?? "",
                style: const TextStyle(color: MyColors.black),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.circle, color: MyColors.gray, size: 5),
              const SizedBox(width: 8),
              Text(
                dateTimeFormatter(widget.postItem.createdAt!),
                style: const TextStyle(color: MyColors.gray),
              ),
              const Spacer(),
              GestureDetector(
                  onTap: () {
                    showModal();
                  },
                  child: const Icon(Icons.more_horiz,
                      color: MyColors.gray, size: 20)),
            ],
          ),
          const SizedBox(height: 23),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.postItem.title ?? "",
                  maxLines: 2,
                  style: const TextStyle(
                      color: MyColors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                height: 26,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: MyColors.primaryColor)),
                child: Center(
                  child: Text(
                    widget.postItem.tags?[0].name ?? "",
                    style: const TextStyle(
                        color: MyColors.primaryColor, fontSize: 11),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.postItem.body ?? "",
              style: const TextStyle(
                  height: 1.35, fontSize: 16, color: MyColors.black),
            ),
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              widget.isMySpecial == false
                  ? Wrap(
                      spacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (!widget.postItem.selfLike!) {
                              setState(() {
                                isLiked = true;
                                likeCount++;
                              });
                              insertLike(widget.postItem.id ?? 0);
                            } else if (widget.postItem.selfLike!) {
                              setState(() {
                                isLiked = false;
                                likeCount--;
                              });
                              postDislike(widget.postItem.id ?? 0);
                            }
                          },
                          child: isLiked
                              ? const Icon(IconlyBold.heart,
                                  color: MyColors.primaryColor)
                              : const Icon(IconlyLight.heart,
                                  color: MyColors.gray),
                        ),
                        Text(likeCount.toString(),
                            style: TextStyle(
                                color: isLiked
                                    ? MyColors.primaryColor
                                    : MyColors.gray,
                                fontSize: 16))
                      ],
                    )
                  : const SizedBox(),
              const SizedBox(width: 20),
              Wrap(
                spacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Icon(IconlyLight.chat, color: MyColors.gray),
                  Text(comments.isEmpty ? "0" : comments.length.toString(),
                      style:
                          const TextStyle(color: MyColors.gray, fontSize: 16))
                ],
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  insertLike(int id) async {
    bool unliked = await Connection.insertPostLiske(context, {"post_id": id});
  }

  postDislike(int id) async {
    bool liked = await Connection.postDislike(context, {"post_id": id});
    if (liked) {
      setState(() {
        isLiked = false;
      });
    }
  }

  showModal() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        builder: (_) => Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 40,
                      height: 6,
                      decoration: BoxDecoration(
                          color: MyColors.gray,
                          borderRadius: BorderRadius.circular(3)),
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextButton(
                      onPressed: () {},
                      child: const Text("Хуваалцах",
                          style: TextStyle(color: MyColors.black))),
                  TextButton(
                      onPressed: () {},
                      child: const Text("Линк хуулах",
                          style: TextStyle(color: MyColors.black))),
                  TextButton(
                      onPressed: () {
                        TopSnackBar.successFactory(
                                msg:
                                    "Постыг админд мэдэгдлээ. Зохисгүй үг агуулгатай пост байвал бид арга хэмжээ авах болно. Баярлалаа")
                            .show(context);
                      },
                      child: const Text("Мэдэгдэх",
                          style: TextStyle(color: MyColors.primaryColor)))
                ],
              ),
            ));
  }
}
