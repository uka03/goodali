import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:goodali/Providers/auth_provider.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/Widgets/top_snack_bar.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/models/post_list_model.dart';
import 'package:goodali/screens/Auth/login.dart';
import 'package:goodali/screens/ListItems/post_item.dart';
import 'package:goodali/screens/ListItems/reply_item.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostDetail extends StatefulWidget {
  final PostListModel postItem;
  final bool isHearted;
  final VoidCallback onRefresh;
  const PostDetail({Key? key, required this.postItem, required this.isHearted, required this.onRefresh}) : super(key: key);

  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  final TextEditingController _commentController = TextEditingController();
  List<PostReplys> comments = [];
  bool loginWithBio = false;

  @override
  void initState() {
    checkLoginWithBio();
    comments = widget.postItem.replys ?? [];
    super.initState();
  }

  checkLoginWithBio() async {
    final prefs = await SharedPreferences.getInstance();
    loginWithBio = prefs.getBool("login_biometric") ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(
        noCard: true,
        title: "Сэтгэгдэл",
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * (kIsWeb ? 0.4 : 1),
          child: SingleChildScrollView(
            child: Column(children: [
              PostItem(
                postItem: widget.postItem,
                isHearted: widget.isHearted,
                onRefresh: widget.onRefresh,
              ),
              Row(
                children: [
                  const SizedBox(width: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: ImageView(imgPath: widget.postItem.avatar ?? "", height: 32, width: 32),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      height: 40,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        color: MyColors.input,
                      ),
                      child: kIsWeb
                          ? Row(
                              children: [
                                const SizedBox(width: 10),
                                Expanded(
                                  child: SizedBox(
                                    height: 70,
                                    child: Center(
                                      child: TextField(
                                        controller: _commentController,
                                        cursorColor: MyColors.primaryColor,
                                        maxLines: null,
                                        onChanged: (value) {},
                                        decoration: const InputDecoration(
                                            border: InputBorder.none, hintText: 'Сэтгэгдэл бичих...', hintStyle: TextStyle(color: MyColors.gray)),
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(IconlyBold.send, color: MyColors.primaryColor),
                                  onPressed: () {
                                    if (_commentController.text.length < 30) {
                                      TopSnackBar.errorFactory(
                                              title: "Анхаарна уу", msg: "Таны сэтгэгдэл хамгийн багадаа 30 тэмдэгт ашигласан байх шаардлагатай.")
                                          .show(context);
                                    } else {
                                      writeComment();
                                    }
                                  },
                                )
                              ],
                            )
                          : TextField(
                              readOnly: true,
                              onTap: () {
                                bool isAuth = Provider.of<Auth>(context, listen: false).isAuth;
                                if (isAuth) {
                                  showReplyModal();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: const Text("Та нэвтэрч орон үргэлжлүүлнэ үү"),
                                      backgroundColor: MyColors.error,
                                      behavior: SnackBarBehavior.floating,
                                      action: SnackBarAction(
                                          onPressed: () => loginWithBio
                                              ? Provider.of<Auth>(context, listen: false).authenticateWithBiometrics(context)
                                              : showLoginModal(),
                                          label: 'Нэвтрэх',
                                          textColor: Colors.white)));
                                }
                              },
                              cursorColor: MyColors.primaryColor,
                              decoration: const InputDecoration(border: InputBorder.none, hintText: "Сэтгэгдэл бичих"),
                            ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Divider(color: MyColors.border1, endIndent: 20, indent: 20),
              comments.isEmpty
                  ? Column(
                      children: [
                        const SizedBox(height: 60),
                        Center(
                          child: SvgPicture.asset("assets/images/no_chat_history.svg", semanticsLabel: 'Acme Logo'),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "Сэтгэгдэл байхгүй байна",
                          style: TextStyle(color: MyColors.gray),
                        ),
                        const SizedBox(height: 40),
                      ],
                    )
                  : ListView.builder(
                      itemCount: comments.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ReplyItem(postReplys: comments[index]);
                      })
            ]),
          ),
        ),
      ),
    );
  }

  showReplyModal() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) {
          return StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setState) {
            return SingleChildScrollView(
                child: Container(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                            border: InputBorder.none, hintText: 'Сэтгэгдэл бичих...', hintStyle: TextStyle(color: MyColors.gray)),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(IconlyBold.send, color: MyColors.primaryColor),
                    onPressed: () {
                      if (_commentController.text.length < 30) {
                        TopSnackBar.errorFactory(title: "Анхаарна уу", msg: "Таны сэтгэгдэл хамгийн багадаа 30 тэмдэгт ашигласан байх шаардлагатай.")
                            .show(context);
                      } else {
                        writeComment();
                        Navigator.pop(context);
                      }
                    },
                  )
                ],
              ),
            ));
          });
        });
  }

  showLoginModal() {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: true,
        useRootNavigator: true,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        builder: (BuildContext context) => const LoginBottomSheet(isRegistered: true));
  }

  writeComment() async {
    Map commentData = {"body": _commentController.text, "post_id": widget.postItem.id};
    bool isCommented = await Connection.insertPostReply(context, commentData);

    if (isCommented) {
      TopSnackBar.successFactory(title: "Сэтгэгдэл илгээгдлээ").show(context);
      widget.onRefresh();
    } else {
      TopSnackBar.errorFactory(title: "Алдаа гарлаа", msg: "Дахин оролдоно уу").show(context);
    }
    return isCommented;
  }
}
