import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/screens/ForumScreen/create_post_screen.dart';
import 'package:iconly/iconly.dart';

class NatureOfHuman extends StatefulWidget {
  const NatureOfHuman({Key? key}) : super(key: key);

  @override
  State<NatureOfHuman> createState() => _NatureOfHumanState();
}

class _NatureOfHumanState extends State<NatureOfHuman> {
  bool isHearted = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return Container(
    //     child: ListView.separated(
    //       itemCount: itemCount,
    //         itemBuilder: ,
    //         separatorBuilder: separatorBuilder,
    //         ));
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: MyColors.border1))),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        "Nickname",
                        style: TextStyle(color: MyColors.gray),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.circle, color: MyColors.gray, size: 5),
                      SizedBox(width: 8),
                      Text(
                        "2022.06.22",
                        style: TextStyle(color: MyColors.gray),
                      ),
                      Spacer(),
                      Container(
                        width: 58,
                        height: 26,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.lightGreen[300]),
                        child: Center(
                          child: Text(
                            "Tag name",
                            style: TextStyle(color: Colors.white, fontSize: 11),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 23),
                  Text(
                    "Sain l huntei suu, ter boltol gantsaaraa hichneen udaan yawsan ch hamaaq. Muu amidray gewel gantsaaraa hen ch chadna.",
                    style: TextStyle(
                        height: 1.35, fontSize: 20, color: MyColors.black),
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
                                isHearted = !isHearted;
                              });
                            },
                            child: isHearted
                                ? Icon(IconlyBold.heart,
                                    color: MyColors.primaryColor)
                                : Icon(IconlyLight.heart, color: MyColors.gray),
                          ),
                          Text("24",
                              style:
                                  TextStyle(color: MyColors.gray, fontSize: 16))
                        ],
                      ),
                      SizedBox(width: 20),
                      Wrap(
                        spacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Icon(IconlyLight.chat, color: MyColors.gray),
                          Text("3",
                              style:
                                  TextStyle(color: MyColors.gray, fontSize: 16))
                        ],
                      ),
                      Spacer(),
                      IconButton(
                          splashRadius: 20,
                          onPressed: () {},
                          icon: Icon(Icons.more_horiz, color: MyColors.gray)),
                    ],
                  )
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: MyColors.border1))),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 26),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        "Nickname",
                        style: TextStyle(color: MyColors.gray),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.circle, color: MyColors.gray, size: 5),
                      SizedBox(width: 8),
                      Text(
                        "2022.06.22",
                        style: TextStyle(color: MyColors.gray),
                      ),
                      Spacer(),
                      Container(
                        width: 58,
                        height: 26,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: MyColors.primaryColor),
                        child: Center(
                          child: Text(
                            "Tag name",
                            style: TextStyle(color: Colors.white, fontSize: 11),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                    style: TextStyle(
                        height: 1.35, fontSize: 20, color: MyColors.black),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Wrap(
                        spacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Icon(IconlyLight.heart, color: MyColors.gray),
                          Text("24",
                              style:
                                  TextStyle(color: MyColors.gray, fontSize: 16))
                        ],
                      ),
                      SizedBox(width: 20),
                      Wrap(
                        spacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Icon(IconlyLight.chat, color: MyColors.gray),
                          Text("3",
                              style:
                                  TextStyle(color: MyColors.gray, fontSize: 16))
                        ],
                      ),
                      Spacer(),
                      IconButton(
                          splashRadius: 20,
                          onPressed: () {},
                          icon: Icon(Icons.more_horiz, color: MyColors.gray)),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: floatActionButtons(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget floatActionButtons() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: MyColors.input,
            child: IconButton(
              splashRadius: 10,
              onPressed: () {},
              icon: const Icon(IconlyLight.filter, color: MyColors.gray),
            ),
          ),
          const SizedBox(width: 18),
          CircleAvatar(
            radius: 24,
            backgroundColor: MyColors.primaryColor,
            child: IconButton(
              splashRadius: 10,
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => CreatePost()));
              },
              icon: const Icon(IconlyLight.edit, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
