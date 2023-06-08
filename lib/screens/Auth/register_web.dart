import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Utils/utils.dart';
import 'package:goodali/Widgets/custom_elevated_button.dart';
import 'package:goodali/Widgets/top_snack_bar.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/screens/Auth/pincode_changed_success.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WebRegisterScreen extends StatefulWidget {
  const WebRegisterScreen({Key? key}) : super(key: key);

  @override
  State<WebRegisterScreen> createState() => _WebRegisterScreenState();
}

class _WebRegisterScreenState extends State<WebRegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController nicknameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isTyping = false;
  bool isTyping1 = false;
  bool isTyping2 = false;
  bool toRemind = false;

  Color textFieldColor = MyColors.primaryColor;
  @override
  Widget build(BuildContext context) {
    final focus = FocusScope.of(context);
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width / 2,
                  child: Image.asset(
                    "assets/images/register_bg.png",
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 120, top: 30),
                  child: Image.asset("assets/images/logo_white.png", width: 126, height: 36),
                ),
              ],
            ),
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  InkWell(
                    child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: RichText(
                            text: const TextSpan(children: [
                          TextSpan(
                              text: "Хаяг байгаа?",
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                color: Color(0xff84807d),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                              )),
                          TextSpan(
                              text: " Нэвтрэх",
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                color: Color(0xfff96f5d),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                              )),
                        ]))),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: const Text("Бүртгүүлэх",
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: MyColors.black,
                                )),
                          ),
                          const SizedBox(height: 40),
                          TextFormField(
                            controller: emailController,
                            cursorColor: MyColors.primaryColor,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () {
                              setState(() {
                                textFieldColor = MyColors.black;
                              });
                              focus.nextFocus();
                            },
                            onChanged: (value) => setState(() => isTyping = true),
                            style: TextStyle(color: textFieldColor),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Цахим шуудан оруулна уу";
                              }
                              if (isEmailCorrect(value) == false) {
                                return "Цахим шуудан буруу байна";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "И-мэйл",
                              suffixIcon: isTyping
                                  ? GestureDetector(
                                      onTap: () {
                                        emailController.text = "";
                                        setState(() {
                                          isTyping = false;
                                        });
                                      },
                                      child: const Icon(Icons.close, color: MyColors.black))
                                  : const SizedBox(),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: MyColors.border1),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: MyColors.primaryColor, width: 1.5),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: nicknameController,
                            cursorColor: MyColors.primaryColor,
                            onEditingComplete: () {
                              setState(() {
                                textFieldColor = MyColors.black;
                              });
                              focus.nextFocus();
                            },
                            onChanged: (value) => setState(() => isTyping2 = true),
                            textInputAction: TextInputAction.next,
                            style: TextStyle(color: textFieldColor),
                            decoration: InputDecoration(
                              hintText: "Нууц нэр",
                              suffixIcon: isTyping2
                                  ? GestureDetector(
                                      onTap: () {
                                        nicknameController.text = "";
                                        setState(() {
                                          isTyping2 = false;
                                        });
                                      },
                                      child: const Icon(Icons.close, color: MyColors.black))
                                  : const SizedBox(),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: MyColors.border1),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: MyColors.primaryColor, width: 1.5),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Та өөртөө хүссэн нэрээ өгөөрэй",
                            style: TextStyle(fontSize: 12, color: MyColors.gray),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            obscureText: true,
                            controller: passwordController,
                            cursorColor: MyColors.primaryColor,
                            onChanged: (value) => setState(() => isTyping1 = true),
                            onEditingComplete: () {
                              setState(() {
                                FocusManager.instance.primaryFocus?.unfocus();
                                textFieldColor = MyColors.black;
                              });
                            },
                            validator: (value) {
                              if (value!.length < 4) {
                                return "4 оронтой байх";
                              }
                              if (value.isEmpty) {
                                return "Пин код оруулна уу.";
                              }
                              return null;
                            },
                            maxLength: 4,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            style: TextStyle(color: textFieldColor),
                            decoration: InputDecoration(
                              hintText: "Пин код",
                              suffixIcon: isTyping1
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isTyping1 = false;
                                        });
                                        passwordController.text = "";
                                      },
                                      child: const Icon(Icons.close, color: MyColors.black))
                                  : const SizedBox(),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: MyColors.border1),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: MyColors.primaryColor, width: 1.5),
                              ),
                            ),
                          ),
                          const SizedBox(height: 64),
                          SizedBox(
                            height: 48,
                            child: CustomElevatedButton(
                                text: "Бүртгүүлэх",
                                onPress: () {
                                  // if (_formKey.currentState!.validate()) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  Utils.showLoaderDialog(context);
                                  userRegister();
                                  // }
                                }),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> userRegister() async {
    var sendData = {"email": emailController.text, "nickname": nicknameController.text, "password": passwordController.text};
    var data = await Connection.userRegister(context, sendData);
    Navigator.pop(context);
    if (data['success'] == true) {
      final pref = await SharedPreferences.getInstance();
      pref.remove("toRemind");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => const PinCodeChangedSuccess(
                    successText: "Баяр хүргье",
                    descriptionText: "Бүртгэл амжилттай үүслээ.",
                    buttonText: "Эхлэх",
                  )));
      return true;
    } else {
      TopSnackBar.errorFactory(msg: data["message"]).show(context);
      return false;
    }
  }
}
