import 'dart:io';

import 'package:flutter/material.dart';
import 'package:goodali/Utils/utils.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/custom_elevated_button.dart';

import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/Widgets/top_snack_bar.dart';
import 'package:goodali/models/user_info.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  final UserInfo? userInfo;
  const EditProfile({Key? key, this.userInfo}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nicknameController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? image;
  XFile? camerPhoto;
  File? fileImage;
  Map<String, dynamic> map = {};

  bool isChanged = false;
  bool isImageChanged = false;
  bool isTyping = false;

  @override
  void initState() {
    emailController.text = widget.userInfo?.email ?? "";
    nicknameController.text = widget.userInfo?.nickname ?? "";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(noCard: true, data: map),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 100,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                  alignment: Alignment.center,
                  child: widget.userInfo?.avatarPath != null && !isImageChanged
                      ? CircleAvatar(
                          radius: 70,
                          child: ClipOval(
                            child: ImageView(
                              imgPath: widget.userInfo?.avatarPath ?? "",
                              height: 160,
                              width: 160,
                            ),
                          ))
                      : fileImage != null && isImageChanged
                          ? CircleAvatar(
                              radius: 70,
                              child: ClipOval(
                                child: Image.file(
                                  fileImage!,
                                  height: 160,
                                  width: 160,
                                  fit: BoxFit.cover,
                                ),
                              ))
                          : const CircleAvatar(
                              radius: 70,
                              backgroundColor: MyColors.border1,
                            )),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: changeProfilePicture,
                  child: const Text(
                    "Зураг солих",
                    style: TextStyle(color: MyColors.primaryColor),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text("И-мэйл хаяг",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: MyColors.gray)),
              const SizedBox(height: 20),
              TextField(
                  controller: emailController,
                  cursorColor: MyColors.primaryColor,
                  readOnly: true,
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: MyColors.border1),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: MyColors.primaryColor, width: 1.5),
                    ),
                  )),
              const SizedBox(height: 24),
              const Text("Нууц нэр",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: MyColors.gray)),
              const SizedBox(height: 20),
              TextField(
                  controller: nicknameController,
                  cursorColor: MyColors.primaryColor,
                  onChanged: (value) {
                    setState(() {
                      isChanged = true;
                      isTyping = true;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Нууц нэр",
                    suffixIcon: isTyping
                        ? GestureDetector(
                            onTap: () => setState(() {
                              nicknameController.text = "";
                              isTyping = false;
                            }),
                            child:
                                const Icon(Icons.close, color: MyColors.black),
                          )
                        : const SizedBox(),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: MyColors.border1),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: MyColors.primaryColor, width: 1.5),
                    ),
                  )),
              const SizedBox(height: 10),
              const Text(
                "Та өөртөө хүссэн нэрээ өгөөрэй",
                style: TextStyle(fontSize: 12, color: MyColors.gray),
              ),
              const Spacer(),
              CustomElevatedButton(
                  text: "Хадгалах",
                  onPress: isChanged
                      ? () {
                          Utils.showLoaderDialog(context);
                          editUserData(fileImage);
                        }
                      : null),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  changeProfilePicture() {
    showModalBottomSheet(
        context: context,
        enableDrag: true,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        builder: (context) {
          return SizedBox(
            height: 300,
            child: Column(
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
                const Text("Зураг солих",
                    style: TextStyle(
                        color: MyColors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 24)),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          try {
                            camerPhoto = await _picker.pickImage(
                                source: ImageSource.camera);
                            Navigator.pop(context);
                            if (camerPhoto != null) {
                              setState(() {
                                isChanged = true;
                                isImageChanged = true;
                                fileImage = File(camerPhoto!.path);
                              });
                            }
                          } catch (e) {
                            print(e);
                            TopSnackBar.errorFactory(msg: "Need permission")
                                .show(context);
                          }
                        },
                        child: Container(
                          height: 125,
                          width: 150,
                          decoration: BoxDecoration(
                              color: MyColors.border1,
                              borderRadius: BorderRadius.circular(18)),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(IconlyLight.camera),
                                SizedBox(height: 20),
                                Text("Камер",
                                    style: TextStyle(color: MyColors.black))
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          try {
                            image = await _picker.pickImage(
                                source: ImageSource.gallery);
                            Navigator.pop(context);

                            if (image != null) {
                              setState(() {
                                isChanged = true;
                                isImageChanged = true;
                                fileImage = File(image!.path);
                              });
                            }
                          } catch (e) {
                            print(e);
                            TopSnackBar.errorFactory(msg: "Need permission")
                                .show(context);
                          }
                        },
                        child: Container(
                          height: 125,
                          width: 150,
                          decoration: BoxDecoration(
                              color: MyColors.border1,
                              borderRadius: BorderRadius.circular(18)),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(IconlyLight.image),
                                SizedBox(height: 20),
                                Text("Галлерей",
                                    style: TextStyle(color: MyColors.black))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<String> uploadImage(File imageFile) async {
    var stream = await Connection.uploadUserAvatar(context, imageFile);

    if (stream["success"]) {
      TopSnackBar.successFactory(title: "Амжилттай солигдлоо").show(context);
    } else {
      TopSnackBar.errorFactory(msg: "Дахин оролдоно уу").show(context);
    }

    return stream["avatar"];
  }

  editUserData(File? imageFile) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    String avatar = "";
    if (fileImage != null) {
      avatar = await uploadImage(fileImage!);
      preferences.setString('user_profile', avatar);
    }
    var data = await Connection.editUserData(context, nicknameController.text);
    Navigator.pop(context);
    if (data['success'] == true) {
      setState(() {
        map = {"name": data["name"], "avatar": avatar};
      });
      print(map["avatar"]);
      Navigator.pop(context, map);
      TopSnackBar.successFactory(title: "Амжилттай солигдлоо").show(context);
    } else {
      TopSnackBar.errorFactory(msg: "Дахин оролдоно уу").show(context);
    }
  }
}
