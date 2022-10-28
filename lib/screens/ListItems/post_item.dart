import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
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
    isLiked = widget.isHearted;
    likeCount = widget.postItem.likes ?? 0;
    comments = widget.postItem.replys ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: const [
              Text(
                "Nickname",
                style: TextStyle(color: MyColors.gray),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.circle, color: MyColors.gray, size: 5),
              // SizedBox(width: 8),
              // Text(
              //   "2022.06.22",
              //   style: TextStyle(color: MyColors.gray),
              // ),
              // Spacer(),
            ],
          ),
          const SizedBox(height: 23),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.postItem.title ?? "",
                style: const TextStyle(
                    color: MyColors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                height: 26,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: MyColors.primaryColor)),
                child: Center(
                  child: Text(
                    "Tag name",
                    style:
                        TextStyle(color: MyColors.primaryColor, fontSize: 11),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.postItem.body ?? "",
              style: const TextStyle(
                  height: 1.35, fontSize: 17, color: MyColors.black),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              widget.isMySpecial == false
                  ? Wrap(
                      spacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isLiked = !isLiked;
                            });
                            if (isLiked) {
                              likeCount++;
                              insertLike(widget.postItem.id ?? 0);
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
              const SizedBox(width: 15),
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
              IconButton(
                  splashRadius: 20,
                  onPressed: () {},
                  icon: const Icon(Icons.more_horiz, color: MyColors.gray)),
            ],
          )
        ],
      ),
    );
  }

  insertLike(int id) async {
    return Connection.insertPostLiske(context, {"post_id": id});
  }
}
