import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:goodali/Providers/auth_provider.dart';
import 'package:goodali/Utils/circle_tab_indicator.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/custom_appbar.dart';
import 'package:goodali/Widgets/custom_elevated_button.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/controller/audioplayer_controller.dart';
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
    checkLoginWithBio();
    super.initState();
  }

  checkLoginWithBio() async {
    final prefs = await SharedPreferences.getInstance();
    loginWithBio = prefs.getBool("login_biometric") ?? false;
  }

  Future<UserInfo?> userData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var data = pref.getString('userData');
    if (data != null) {
      var json = jsonDecode(data);
      userInfo = UserInfo.fromJson(json);

      return userInfo;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Би',
        actionButton1: Consumer<Auth>(
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
        actionButton2: null,
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
                                  child: ImageView(
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
                                    changedName != null
                                        ? changedName!
                                        : userInfo.nickname ?? "",
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
                                        log(changedName ?? "dd",
                                            name: "changedName");
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
                          height: 51,
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
                              indicatorWeight: 4,
                              indicator: CustomTabIndicator(
                                  color: MyColors.primaryColor),
                              labelColor: MyColors.primaryColor,
                              labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Gilroy'),
                              unselectedLabelStyle: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'Gilroy'),
                              unselectedLabelColor: MyColors.gray,
                              indicatorColor: MyColors.primaryColor,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              MyCourses(
                                onTap: (audioObject) {
                                  currentlyPlaying.value = audioObject;
                                },
                              ),
                              Downloaded(
                                onTap: (audioObject) {
                                  currentlyPlaying.value = audioObject;
                                },
                              )
                            ],
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
            return Column(
              children: [
                const SizedBox(height: 100),
                Image.asset("assets/images/splash_screen.png",
                    height: 48, width: 169),
                const SizedBox(height: 30),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 56),
                  child: Text(
                    "Сайн байна уу? Та дээрх үйлдлийг хийхийн тулд нэвтрэх хэрэгтэй.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: MyColors.gray),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: CustomElevatedButton(
                    text: "Нэвтрэх",
                    onPress: () {
                      loginWithBio
                          ? value.authenticateWithBiometrics(context)
                          : showLoginModal(true);
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          child: const Text(
                            "Бүртгүүлэх",
                            style:
                                TextStyle(fontSize: 16, color: MyColors.black),
                          ),
                          onPressed: () {
                            showLoginModal(false);
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 0,
                              backgroundColor: MyColors.input)),
                    )),
                const SizedBox(height: 10),
              ],
            );
          }
        },
      ),
    );
  }

  showLoginModal(bool isRegistered) {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: true,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        builder: (BuildContext context) =>
            LoginBottomSheet(isRegistered: isRegistered));
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
