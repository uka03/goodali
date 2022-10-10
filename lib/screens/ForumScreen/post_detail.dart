import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/Widgets/top_snack_bar.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/models/post_list_model.dart';
import 'package:goodali/screens/ListItems/post_item.dart';
import 'package:goodali/screens/ListItems/reply_item.dart';
import 'package:iconly/iconly.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class PostDetail extends StatefulWidget {
  final PostListModel postItem;
  final bool isHearted;
  const PostDetail({Key? key, required this.postItem, required this.isHearted})
      : super(key: key);

  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  final TextEditingController _commentController = TextEditingController();
  List<PostReplys> comments = [];

  @override
  void initState() {
    comments = widget.postItem.replys ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(
        noCard: true,
        title: "Сэтгэгдэл",
      ),
      body: Column(
        children: [
          PostItem(postItem: widget.postItem, isHearted: widget.isHearted),
          Container(
            margin: const EdgeInsets.all(18),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: MyColors.input,
            ),
            child: Row(
              children: [
                const Icon(IconlyLight.edit),
                const SizedBox(width: 14),
                SizedBox(
                  width: 200,
                  child: TextField(
                    onTap: () {
                      showReplyModal();
                    },
                    cursorColor: MyColors.primaryColor,
                    decoration: const InputDecoration(
                        border: InputBorder.none, hintText: "Сэтгэгдэл бичих"),
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: MyColors.border1, endIndent: 20, indent: 20),
          comments.isEmpty
              ? Expanded(
                  child: Center(
                    child: SvgPicture.asset("assets/images/no_chat_history.svg",
                        semanticsLabel: 'Acme Logo'),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                      itemCount: comments.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ReplyItem(postReplys: comments[index]);
                      }),
                )
        ],
      ),
    );
  }

  showReplyModal() {
    showModalBottomSheet(
        context: context,
        useRootNavigator: true,
        isScrollControlled: true,
        builder: (_) {
          return StatefulBuilder(builder:
              (BuildContext context, void Function(void Function()) setState) {
            bool isTyped = false;

            return SingleChildScrollView(
                child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 80,
                    height: 70,
                    child: Center(
                      child: TextField(
                        controller: _commentController,
                        cursorColor: MyColors.primaryColor,
                        maxLines: null,
                        onChanged: (value) {},
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Сэтгэгдэл бичих...',
                            hintStyle: TextStyle(color: MyColors.gray)),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(IconlyBold.send,
                        color: MyColors.primaryColor),
                    onPressed: () {
                      if (_commentController.text.length < 30) {
                        showTopSnackBar(
                            context,
                            const CustomTopSnackBar(
                              type: 0,
                              text:
                                  "Таны сэтгэгдэл хамгийн багадаа 30 тэмдэгт ашигласан байх шаардлагатай.",
                            ));
                      } else {
                        writeComment();
                      }
                    },
                  )
                ],
              ),
            ));
          });
        });
  }

  writeComment() async {
    Map commentData = {
      "body": _commentController.text,
      "post_id": widget.postItem.id
    };
    bool isCommented = await Connection.insertPostReply(context, commentData);
    Navigator.pop(context);
    if (isCommented) {
      showTopSnackBar(context,
          const CustomTopSnackBar(type: 1, text: "Сэтгэгдэл илгээгдлээ"));
    } else {
      showTopSnackBar(
          context, const CustomTopSnackBar(type: 0, text: "Дахин оролдоно уу"));
    }
    return isCommented;
  }
}
