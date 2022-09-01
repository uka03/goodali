import 'package:flutter/material.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/custom_elevated_button.dart';
import 'package:goodali/Widgets/custom_textfield.dart';

import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/Widgets/top_snack_bar.dart';
import 'package:goodali/models/user_info.dart';
import 'package:iconly/iconly.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class EditProfile extends StatefulWidget {
  final UserInfo? userInfo;
  const EditProfile({Key? key, this.userInfo}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nicknameController = TextEditingController();

  bool isChanged = false;

  @override
  void initState() {
    emailController.text = widget.userInfo?.email ?? "";
    nicknameController.text = widget.userInfo?.nickname ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 100,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: MyColors.secondary,
                ),
              ),
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
              const Text("Утасны дугаар",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: MyColors.gray)),
              const SizedBox(height: 20),
              TextField(
                  controller: phoneController,
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
                  text: "Хадгалах", onPress: isChanged ? editUserData : null),
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
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {},
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
                        onTap: () {},
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

  editUserData() async {
    var data = await Connection.editUserData(context, nicknameController.text);
    if (data['succes'] == true) {
      showTopSnackBar(context,
          const CustomTopSnackBar(type: 1, text: "Амжилттай солигдлоо"));
      Navigator.pop(context, data["name"]);
    } else {
      showTopSnackBar(
          context,
          const CustomTopSnackBar(
              type: 0, text: "Алдаа гарлаа дахин оролдоно уу"));
    }
  }
}
