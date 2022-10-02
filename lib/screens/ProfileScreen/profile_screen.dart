import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:goodali/Providers/auth_provider.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/custom_appbar.dart';
import 'package:goodali/Widgets/custom_elevated_button.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/models/user_info.dart';
import 'package:goodali/screens/Auth/login.dart';
import 'package:goodali/screens/Auth/pincode_feild.dart';
import 'package:goodali/screens/ProfileScreen/courseLessons.dart/my_bought_courses.dart';
import 'package:goodali/screens/ProfileScreen/downloaded.dart';
import 'package:goodali/screens/ProfileScreen/edit_profile.dart';
import 'package:goodali/screens/ProfileScreen/settings.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserInfo userInfo = UserInfo();
  String? changedName;
  bool isChanged = false;
  String? avatarPath;
  bool loginWithBio = false;

  @override
  void initState() {
    print("jfnjdnfndkjnf");
    checkLoginWithBio();
    super.initState();
  }

  checkLoginWithBio() async {
    final prefs = await SharedPreferences.getInstance();
    loginWithBio = prefs.getBool("login_biometric") ?? false;
    print("getCheckBiometric $loginWithBio");
  }

  Future<UserInfo?> userData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var data = pref.getString('userData');
    if (data != null) {
      var json = jsonDecode(data);
      userInfo = UserInfo.fromJson(json);

      return userInfo;
    } else {
      print("hooson");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Би',
        actionButton2: Consumer<Auth>(
          builder: (context, value, child) => value.isAuth
              ? IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const Settings()));
                  },
                  icon: const Icon(Icons.more_horiz,
                      size: 28, color: MyColors.black))
              : Container(),
        ),
        actionButton1: null,
        isCartButton: false,
      ),
      body: Consumer<Auth>(
        builder: (BuildContext context, value, Widget? child) {
          if (value.isAuth == true) {
            return DefaultTabController(
              length: 2,
              child: FutureBuilder(
                future: userData(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    userInfo = snapshot.data;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10),
                          child: Row(
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child:
                                      // Container(
                                      //   width: 70,
                                      //   height: 70,
                                      //   color: Colors.pink,
                                      // )
                                      ImageView(
                                    imgPath: userInfo.avatarPath ?? "",
                                    width: 70,
                                    height: 70,
                                  )),
                              const SizedBox(width: 16),
                              Wrap(
                                direction: Axis.vertical,
                                spacing: 8,
                                children: [
                                  Text(
                                    userInfo.nickname ?? "",
                                    style: const TextStyle(
                                        fontSize: 20,
                                        color: MyColors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    userInfo.email ?? "",
                                    style:
                                        const TextStyle(color: MyColors.gray),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => EditProfile(
                                                userInfo: userInfo))).then(
                                        (value) {
                                      if (value != null) {
                                        setState(() {
                                          changedName = value['name'];
                                          avatarPath = value["avatar"];
                                        });
                                      }
                                    });
                                  },
                                  child: const Text(
                                    "Засах",
                                    style: TextStyle(
                                        color: MyColors.primaryColor,
                                        fontSize: 16),
                                  ))
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: MyColors.border1, width: 0.8))),
                          height: 50,
                          child: AppBar(
                            backgroundColor: Colors.white,
                            elevation: 0,
                            bottom: const TabBar(
                              isScrollable: true,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              tabs: [
                                SizedBox(width: 70, child: Tab(text: "Авсан")),
                                SizedBox(width: 70, child: Tab(text: "Татсан"))
                              ],
                              indicatorWeight: 3,
                              labelColor: MyColors.primaryColor,
                              unselectedLabelColor: MyColors.black,
                              indicatorColor: MyColors.primaryColor,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: TabBarView(
                            children: [MyCourses(), Downloaded()],
                          ),
                        )
                      ],
                    );
                  } else {
                    return const Center(
                        child: CircularProgressIndicator(
                            color: MyColors.primaryColor));
                  }
                },
              ),
            );
          } else {
            return Center(
              child: SizedBox(
                width: 200,
                child: CustomElevatedButton(
                  text: "Нэвтрэх",
                  onPress: () {
                    loginWithBio
                        ? value.authenticateWithBiometrics(context)
                        : showLoginModal();
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }

  showLoginModal() {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: true,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        builder: (BuildContext context) => const LoginBottomSheet());
  }

  showPincodeField() {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: true,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        builder: (BuildContext context) => const PincodeField());
  }
}
