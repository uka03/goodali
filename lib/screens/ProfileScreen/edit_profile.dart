import 'dart:io';

import 'package:flutter/material.dart';
import 'package:goodali/Utils/utils.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/custom_elevated_button.dart';
import 'package:goodali/Widgets/custom_textfield.dart';

import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/Widgets/top_snack_bar.dart';
import 'package:goodali/models/user_info.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

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

  bool isChanged = false;
  bool isImageChanged = false;

  @override
  void initState() {
    emailController.text = widget.userInfo?.email ?? "";
    nicknameController.text = widget.userInfo?.nickname ?? "";
    print(widget.userInfo?.avatarPath);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(noCard: true),
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
                      borderSide:
                          BorderSide(color: MyColors.border1, width: 0.5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: MyColors.primaryColor),
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
                    });
                  },
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: MyColors.border1, width: 0.5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: MyColors.primaryColor),
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
                          editUserData();
                          if (fileImage != null) {
                            uploadImage(fileImage!);
                          }
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
                          camerPhoto = await _picker
                              .pickImage(source: ImageSource.camera)
                              .whenComplete(() => Navigator.pop(context));
                          if (camerPhoto != null) {
                            setState(() {
                              isChanged = true;
                              isImageChanged = true;
                              fileImage = File(camerPhoto!.path);
                            });
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
                          image = await _picker
                              .pickImage(source: ImageSource.gallery)
                              .whenComplete(() => Navigator.pop(context));
                          if (image != null) {
                            setState(() {
                              isChanged = true;
                              isImageChanged = true;
                              fileImage = File(image!.path);
                            });
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

  uploadImage(File imageFile) async {
    var stream = await Connection.uploadUserAvatar(context, imageFile);

    if (stream["success"]) {
      if (!mounted) return;
      showTopSnackBar(context,
          const CustomTopSnackBar(type: 1, text: "Амжилттай солигдлоо"));
    } else {
      if (!mounted) return;
      showTopSnackBar(
          context,
          const CustomTopSnackBar(
              type: 0, text: "Алдаа гарлаа дахин оролдоно уу"));
    }
  }

  editUserData() async {
    var data = await Connection.editUserData(context, nicknameController.text);
    Navigator.pop(context);
    if (data['succes'] == true) {
      showTopSnackBar(context,
          const CustomTopSnackBar(type: 1, text: "Амжилттай солигдлоо"));
      Map<String, dynamic> map = {
        "name": data["name"],
        "avatar": data['avatar']
      };
      Navigator.pop(context, map);
    } else {
      showTopSnackBar(
          context,
          const CustomTopSnackBar(
              type: 0, text: "Алдаа гарлаа дахин оролдоно уу"));
    }
  }
}
