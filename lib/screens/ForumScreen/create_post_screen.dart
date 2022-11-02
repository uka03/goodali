import 'package:flutter/material.dart';
import 'package:goodali/Providers/auth_provider.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/custom_appbar.dart';
import 'package:goodali/Widgets/custom_elevated_button.dart';
import 'package:goodali/Widgets/custom_textfield.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/Widgets/top_snack_bar.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/models/tag_model.dart';
import 'package:goodali/screens/Auth/login.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({Key? key}) : super(key: key);

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  late final tagFuture = getTagList();
  TextEditingController titleController = TextEditingController();
  TextEditingController textController = TextEditingController();
  List<int> selectedTabs = [];
  bool loginWithBio = false;
  List<String> postTypes = [
    'Хүний байгаль',
    'Нууц бүлгэм',
    'Миний нандин (Зөвхөн танд)'
  ];

  List<TagModel> tagList = [];
  bool _noTabsSelected = false;
  int postType = 0;

  @override
  void initState() {
    checkLoginWithBio();
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
        title: "Пост нэмэх",
        noCard: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              CustomTextField(
                  controller: titleController,
                  hintText: "Гарчиг",
                  maxLength: 50),
              const SizedBox(height: 40),
              const Text("Та юу бодож байна?",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: MyColors.black)),
              const SizedBox(height: 30),
              CustomTextField(
                  controller: textController,
                  hintText: "Энд бичнэ үү",
                  maxLines: null,
                  maxLength: 1000),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: CustomElevatedButton(
            text: "Нийтлэх",
            onPress: () {
              bool isAuth = Provider.of<Auth>(context, listen: false).isAuth;
              if (isAuth) {
                showModalTag();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text("Та нэвтэрч орон үргэлжлүүлнэ үү"),
                    backgroundColor: MyColors.error,
                    behavior: SnackBarBehavior.floating,
                    action: SnackBarAction(
                        onPressed: () => loginWithBio
                            ? Provider.of<Auth>(context, listen: false)
                                .authenticateWithBiometrics(context)
                            : showLoginModal(),
                        label: 'Нэвтрэх',
                        textColor: Colors.white)));
              }
            }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  showLoginModal() {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: true,
        useRootNavigator: true,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        builder: (BuildContext context) => const LoginBottomSheet());
  }

  showModalTag() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        builder: (_) => StatefulBuilder(
              builder: (BuildContext context,
                  void Function(void Function()) setState) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        width: 38,
                        height: 6,
                        decoration: BoxDecoration(
                            color: MyColors.gray,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      const SizedBox(height: 20),
                      const Text("Холбогдох сэдэв",
                          style: TextStyle(
                              fontSize: 22,
                              color: MyColors.black,
                              fontWeight: FontWeight.bold)),
                      FutureBuilder(
                        future: tagFuture,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData &&
                              ConnectionState.done ==
                                  snapshot.connectionState) {
                            tagList = snapshot.data;
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.fromLTRB(12, 20, 20, 0),
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                children: tagList.map((i) {
                                  bool isSelected = false;
                                  if (selectedTabs.contains(i.id)) {
                                    isSelected = true;
                                  }
                                  return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      child: GestureDetector(
                                          onTap: () {
                                            if (!selectedTabs.contains(i.id)) {
                                              selectedTabs.add(i.id ?? 0);
                                            } else {
                                              selectedTabs.remove(i.id);
                                            }
                                            setState(() {});
                                          },
                                          child: Container(
                                            child: Text(
                                              i.name!,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: isSelected
                                                      ? Colors.white
                                                      : MyColors.gray),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 14, vertical: 12),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: MyColors.border1,
                                                    width: 0.8),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: isSelected
                                                    ? MyColors.primaryColor
                                                    : Colors.white),
                                          )));
                                }).toList(),
                              ),
                            );
                          } else {
                            return const Center(
                                child: CircularProgressIndicator(
                                    color: MyColors.primaryColor,
                                    strokeWidth: 2));
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      _noTabsSelected
                          ? const Padding(
                              padding: EdgeInsets.only(left: 20.0),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Text("Холбогдох сэдэвээ сонгоно уу",
                                    style: TextStyle(
                                        color: MyColors.error, fontSize: 12)),
                              ),
                            )
                          : const SizedBox(),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: CustomElevatedButton(
                            text: "Сонгох",
                            onPress: () {
                              if (selectedTabs.isEmpty) {
                                setState(() => _noTabsSelected = true);
                              } else {
                                setState(() => _noTabsSelected = false);
                                Navigator.pop(context);
                                showPostTypeSheet();
                              }
                            }),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ));
  }

  showPostTypeSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        builder: (_) => StatefulBuilder(
              builder: (BuildContext context,
                  void Function(void Function()) setState) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 38,
                        height: 6,
                        decoration: BoxDecoration(
                            color: MyColors.gray,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      const SizedBox(height: 20),
                      const Text("Хаана постлох вэ",
                          style: TextStyle(
                              fontSize: 18,
                              color: MyColors.black,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: postTypes
                            .map((i) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                child: RadioListTile(
                                  controlAffinity:
                                      ListTileControlAffinity.trailing,
                                  activeColor: MyColors.primaryColor,
                                  groupValue: postType,
                                  value: postTypes.indexOf(i),
                                  onChanged: (value) {
                                    setState(() => postType = value as int);
                                  },
                                  title: Text(i,
                                      style: const TextStyle(
                                          color: MyColors.black)),
                                )))
                            .toList(),
                      ),
                      CustomElevatedButton(
                          text: "Нийтлэх",
                          onPress: () {
                            Navigator.pop(context);
                            insertPost();
                          }),
                      const SizedBox(height: 10),
                    ],
                  ),
                );
              },
            ));
  }

  Future<List<TagModel>> getTagList() async {
    tagList = await Connection.getTagList(context);
    return tagList;
  }

  insertPost() async {
    Map body = {
      "title": titleController.text,
      "body": textController.text,
      "post_type": postType,
      "tags": selectedTabs
    };
    print(body);
    var data = await Connection.insertPost(context, body);
    Navigator.pop(context);
    if (data['success']) {
      showTopSnackBar(context,
          const CustomTopSnackBar(type: 1, text: "Амжилттай нийтлэгдлээ"));
    } else {
      showTopSnackBar(
          context,
          const CustomTopSnackBar(
              type: 0, text: "Алдаа гарлаа дахин оролдоно уу"));
    }
  }
}
