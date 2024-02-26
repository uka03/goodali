import 'package:flutter/material.dart';
import 'package:goodali/Providers/auth_provider.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Utils/utils.dart';
import 'package:goodali/Widgets/custom_elevated_button.dart';
import 'package:goodali/Widgets/top_snack_bar.dart';
import 'package:goodali/screens/Auth/forgot_password.dart';
import 'package:goodali/screens/Auth/register_web.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WebLoginScreen extends StatefulWidget {
  const WebLoginScreen({Key? key}) : super(key: key);

  @override
  State<WebLoginScreen> createState() => _WebLoginScreennState();
}

class _WebLoginScreennState extends State<WebLoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nicknameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isTyping = false;
  bool isTyping1 = false;
  bool isTyping2 = false;
  bool toRemind = false;

  Color textFieldColor = MyColors.primaryColor;
  bool isRegistered = true;
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
                    "assets/images/login_bg.png",
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
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  InkWell(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                          text: const TextSpan(children: [
                        TextSpan(
                            text: "Хаяг байхгүй?",
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              color: Color(0xff84807d),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                            )),
                        TextSpan(
                            text: " Бүртгүүлэх",
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              color: Color(0xfff96f5d),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                            )),
                      ])),
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const WebRegisterScreen()));
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
                            child: const Text("Нэвтрэх",
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
                            onEditingComplete: () {
                              setState(() {
                                textFieldColor = MyColors.black;
                              });
                              focus.nextFocus();
                            },
                            onChanged: (value) => setState(() => isTyping = true),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            style: TextStyle(color: textFieldColor),
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
                            controller: passwordController,
                            cursorColor: MyColors.primaryColor,
                            onEditingComplete: () {
                              setState(() {
                                FocusManager.instance.primaryFocus?.unfocus();
                                textFieldColor = MyColors.black;
                              });
                            },
                            onChanged: (value) => setState(() => isTyping1 = true),
                            obscureText: true,
                            maxLength: 4,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: textFieldColor),
                            decoration: InputDecoration(
                              hintText: "Пин код",
                              suffixIcon: isTyping1
                                  ? GestureDetector(
                                      onTap: () {
                                        passwordController.text = "";
                                        setState(() {
                                          isTyping1 = false;
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
                          Container(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPassword()));
                                },
                                child: const Text("Пин код мартсан?",
                                    style: TextStyle(
                                      fontFamily: 'Gilroy',
                                      color: Color(0xfff96f5d),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                    ))),
                          ),
                          const SizedBox(height: 100),
                          SizedBox(
                            height: 48,
                            child: CustomElevatedButton(
                                text: "Нэвтрэх",
                                onPress: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  Utils.showLoaderDialog(context);
                                  userSignin();
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

  userSignin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var sendData = {"email": emailController.text, "password": passwordController.text};
    var data = await Provider.of<Auth>(context, listen: false).login(context, sendData, toRemind: toRemind);
    Navigator.pop(context);

    if (data['success'] == true) {
      if (!preferences.containsKey("first_biometric")) {
        Provider.of<Auth>(context, listen: false).canBiometrics();
      }
      Navigator.pop(context, data['userInfo']);
    } else {
      TopSnackBar.errorFactory(msg: data["message"]).show(context);
    }
  }
}
