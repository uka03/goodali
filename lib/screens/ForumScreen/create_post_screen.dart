import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:goodali/Providers/auth_provider.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/custom_elevated_button.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/Widgets/top_snack_bar.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/models/tag_model.dart';
import 'package:goodali/screens/Auth/login.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool hasTraining = false;

  List<String> postTypes = [];

  List<TagModel> tagList = [];
  bool _noTabsSelected = false;
  bool _noTyped = false;
  bool _noTyped1 = false;
  int postType = 0;

  @override
  void initState() {
    checkLoginWithBio();
    checkUserHasTraining();
    super.initState();
  }

  checkLoginWithBio() async {
    final prefs = await SharedPreferences.getInstance();
    loginWithBio = prefs.getBool("login_biometric") ?? false;
  }

  Future<void> checkUserHasTraining() async {
    hasTraining = await Provider.of<Auth>(context, listen: false).checkTraining();
    if (hasTraining) {
      postTypes = ['Хүний байгаль', 'Түүдэг гал', 'Миний нандин (Зөвхөн танд)'];
    } else {
      postTypes = ['Хүний байгаль', 'Миний нандин (Зөвхөн танд)'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const SimpleAppBar(
        title: "Пост нэмэх",
        noCard: true,
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * (kIsWeb ? 0.4 : 1),
          child: CustomScrollView(slivers: [
            SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const Text("Та юу бодож байна?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: MyColors.black)),
                      const SizedBox(height: 24),
                      TextField(
                        controller: titleController,
                        cursorColor: MyColors.primaryColor,
                        onChanged: (value) {
                          setState(() {
                            _noTyped = true;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Гарчиг",
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: MyColors.border1, width: 1),
                          ),
                          suffixIcon: _noTyped
                              ? GestureDetector(
                                  onTap: () {
                                    titleController.text = "";
                                    setState(() {
                                      _noTyped = false;
                                    });
                                  },
                                  child: const Icon(
                                    Icons.close_rounded,
                                    color: MyColors.gray,
                                  ))
                              : const SizedBox(),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: MyColors.primaryColor, width: 1.5),
                          ),
                        ),
                        maxLength: 30,
                      ),
                      const SizedBox(height: 50),
                      TextField(
                        controller: textController,
                        cursorColor: MyColors.primaryColor,
                        onChanged: (value) {
                          setState(() {
                            _noTyped1 = true;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Үндсэн хэсэг",
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: MyColors.border1, width: 1),
                          ),
                          suffixIcon: _noTyped1
                              ? GestureDetector(
                                  onTap: () {
                                    textController.text = "";
                                    setState(() {
                                      _noTyped1 = false;
                                    });
                                  },
                                  child: const Icon(
                                    Icons.close_rounded,
                                    color: MyColors.gray,
                                  ))
                              : const SizedBox(),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: MyColors.primaryColor, width: 1.5),
                          ),
                        ),
                        maxLength: 1200,
                        maxLines: null,
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: CustomElevatedButton(text: "Нийтлэх", onPress: _noTyped && _noTyped1 ? _onPressed : null),
                      ),
                      const SizedBox(height: 8),
                      const Text("Та өдөрт 2 удаа пост оруулах эрхтэй.", style: TextStyle(fontSize: 12, color: MyColors.gray)),
                      const SizedBox(height: 30)
                    ],
                  ),
                ))
          ]),
        ),
      ),
    );
  }

  _onPressed() {
    bool isAuth = Provider.of<Auth>(context, listen: false).isAuth;
    if (isAuth) {
      showModalTag();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("Та нэвтэрч орон үргэлжлүүлнэ үү"),
          backgroundColor: MyColors.error,
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
              onPressed: () => loginWithBio ? Provider.of<Auth>(context, listen: false).authenticateWithBiometrics(context) : showLoginModal(),
              label: 'Нэвтрэх',
              textColor: Colors.white)));
    }
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

  showModalTag() {
    if (kIsWeb) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) {
              return AlertDialog(
                contentPadding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                content: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Container(
                          alignment: Alignment.topRight,
                          child: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                        ),
                        const SizedBox(height: 20),
                        const Text("Холбогдох сэдэв", style: TextStyle(fontSize: 22, color: MyColors.black, fontWeight: FontWeight.bold)),
                        FutureBuilder(
                          future: tagFuture,
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData && ConnectionState.done == snapshot.connectionState) {
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
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                                                style: TextStyle(fontSize: 14, color: isSelected ? Colors.white : MyColors.gray),
                                              ),
                                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: MyColors.border1, width: 0.8),
                                                  borderRadius: BorderRadius.circular(12),
                                                  color: isSelected ? MyColors.primaryColor : Colors.white),
                                            )));
                                  }).toList(),
                                ),
                              );
                            } else {
                              return const Center(child: CircularProgressIndicator(color: MyColors.primaryColor, strokeWidth: 2));
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        _noTabsSelected
                            ? const Padding(
                                padding: EdgeInsets.only(left: 20.0),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text("Холбогдох сэдэвээ сонгоно уу", style: TextStyle(color: MyColors.error, fontSize: 12)),
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
                  ),
                ),
              );
            },
          );
        },
      );
    } else {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
          builder: (_) => StatefulBuilder(
                builder: (BuildContext context, void Function(void Function()) setState) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Container(
                          width: 38,
                          height: 6,
                          decoration: BoxDecoration(color: MyColors.gray, borderRadius: BorderRadius.circular(10)),
                        ),
                        const SizedBox(height: 20),
                        const Text("Холбогдох сэдэв", style: TextStyle(fontSize: 22, color: MyColors.black, fontWeight: FontWeight.bold)),
                        FutureBuilder(
                          future: tagFuture,
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData && ConnectionState.done == snapshot.connectionState) {
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
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                                                style: TextStyle(fontSize: 14, color: isSelected ? Colors.white : MyColors.gray),
                                              ),
                                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: MyColors.border1, width: 0.8),
                                                  borderRadius: BorderRadius.circular(12),
                                                  color: isSelected ? MyColors.primaryColor : Colors.white),
                                            )));
                                  }).toList(),
                                ),
                              );
                            } else {
                              return const Center(child: CircularProgressIndicator(color: MyColors.primaryColor, strokeWidth: 2));
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        _noTabsSelected
                            ? const Padding(
                                padding: EdgeInsets.only(left: 20.0),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text("Холбогдох сэдэвээ сонгоно уу", style: TextStyle(color: MyColors.error, fontSize: 12)),
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
  }

  showPostTypeSheet() {
    if (kIsWeb) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) {
              return AlertDialog(
                contentPadding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                content: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          alignment: Alignment.topRight,
                          child: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                        ),
                        const SizedBox(height: 20),
                        const Text("Хаана постлох вэ?", style: TextStyle(fontSize: 18, color: MyColors.black, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          children: postTypes
                              .map((i) => Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  child: RadioListTile(
                                    controlAffinity: ListTileControlAffinity.trailing,
                                    activeColor: MyColors.primaryColor,
                                    groupValue: postType,
                                    value: postTypes.indexOf(i),
                                    onChanged: (value) {
                                      setState(() => postType = value as int);
                                    },
                                    title: Text(i, style: const TextStyle(color: MyColors.black)),
                                  )))
                              .toList(),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: CustomElevatedButton(
                              text: "Нийтлэх",
                              onPress: () {
                                Navigator.pop(context);
                                insertPost();
                              }),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
    } else {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
          builder: (_) => StatefulBuilder(
                builder: (BuildContext context, void Function(void Function()) setState) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 38,
                          height: 6,
                          decoration: BoxDecoration(color: MyColors.gray, borderRadius: BorderRadius.circular(10)),
                        ),
                        const SizedBox(height: 20),
                        const Text("Хаана постлох вэ?", style: TextStyle(fontSize: 18, color: MyColors.black, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          children: postTypes
                              .map((i) => Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  child: RadioListTile(
                                    controlAffinity: ListTileControlAffinity.trailing,
                                    activeColor: MyColors.primaryColor,
                                    groupValue: postType,
                                    value: postTypes.indexOf(i),
                                    onChanged: (value) {
                                      setState(() => postType = value as int);
                                    },
                                    title: Text(i, style: const TextStyle(color: MyColors.black)),
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
  }

  Future<List<TagModel>> getTagList() async {
    tagList = await Connection.getTagList(context);
    return tagList;
  }

  insertPost() async {
    if (!hasTraining) {
      postType = postType == 0 ? 0 : 2;
    }
    Map body = {"title": titleController.text, "body": textController.text, "post_type": postType, "tags": selectedTabs};
    print(body);
    var data = await Connection.insertPost(context, body);

    if (data['success']) {
      TopSnackBar.successFactory(title: "Амжилттай шинэчлэгдлээ")
          .show(context)
          .then((value) => Navigator.of(context).popUntil((route) => route.isFirst));
    } else {
      TopSnackBar.errorFactory(msg: "Алдаа гарлаа дахин оролдоно уу").show(context);
    }
  }
}
