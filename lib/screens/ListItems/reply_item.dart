import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/models/post_list_model.dart';
import 'package:iconly/iconly.dart';

class ReplyItem extends StatefulWidget {
  final PostReplys postReplys;
  const ReplyItem({Key? key, required this.postReplys}) : super(key: key);

  @override
  State<ReplyItem> createState() => _ReplyItemState();
}

class _ReplyItemState extends State<ReplyItem> {
  bool isLiked = false;
  int likeCount = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 23),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.postReplys.nickName ?? "",
                style: const TextStyle(
                    color: MyColors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              // Container(
              //   padding: const EdgeInsets.symmetric(horizontal: 4),
              //   height: 26,
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(4),
              //       border: Border.all(color: MyColors.primaryColor)),
              //   child: Center(
              //     child: Text(
              //       "Tag name",
              //       style:
              //           TextStyle(color: MyColors.primaryColor, fontSize: 11),
              //     ),
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.postReplys.text ?? "",
              style: const TextStyle(
                  height: 1.35, fontSize: 17, color: MyColors.black),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Wrap(
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
                      }
                    },
                    child: isLiked
                        ? const Icon(IconlyBold.heart,
                            color: MyColors.primaryColor)
                        : const Icon(IconlyLight.heart, color: MyColors.gray),
                  ),
                  Text(likeCount.toString(),
                      style: TextStyle(
                          color:
                              isLiked ? MyColors.primaryColor : MyColors.gray,
                          fontSize: 16))
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
