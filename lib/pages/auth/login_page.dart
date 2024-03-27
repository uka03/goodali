import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:goodali/pages/auth/components/auth_input.dart';
import 'package:goodali/shared/components/keyboard_hider.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/primary_button.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.onLogin, required this.onRegister});
  final Function(String, bool) onLogin;
  final Function() onRegister;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isTyping = false;
  bool toRemind = false;
  @override
  void initState() {
    super.initState();
    getEmail();
    isTyping = emailController.text.isEmpty;
  }

  getEmail() async {
    print("object");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString("email");
    final save = prefs.getBool("saved");
    if (savedEmail?.isNotEmpty == true) {
      setState(() {
        emailController.text = savedEmail ?? "";
        toRemind = save ?? false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardHider(
      child: Scaffold(
        backgroundColor: GoodaliColors.primaryBGColor,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      VSpacer(size: 50),
                      Row(
                        children: [
                          Text(
                            "Нэвтрэх",
                            style: GoodaliTextStyles.titleText(
                              context,
                              fontSize: 32,
                            ),
                          ),
                        ],
                      ),
                      VSpacer(size: 40),
                      AuthInput(
                        keyboardType: TextInputType.emailAddress,
                        isTyping: isTyping,
                        onClose: () {
                          emailController.clear();
                          setState(() {
                            isTyping = false;
                          });
                        },
                        controller: emailController,
                        onChanged: (value) {
                          setState(() {
                            isTyping = true;
                          });
                        },
                      ),
                      VSpacer(),
                      Row(
                        children: [
                          SizedBox(
                            height: 24,
                            width: 24,
                            child: Checkbox(
                              value: toRemind,
                              fillColor: MaterialStateProperty.all<Color>(
                                toRemind
                                    ? GoodaliColors.primaryColor
                                    : GoodaliColors.primaryBGColor,
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                              side:
                                  BorderSide(color: GoodaliColors.borderColor),
                              splashRadius: 5,
                              onChanged: (bool? value) {
                                setState(() {
                                  toRemind = value!;
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 15),
                          Text("Сануулах",
                              style: TextStyle(color: GoodaliColors.blackColor))
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      PrimaryButton(
                        height: 50,
                        borderRadius: 20,
                        text: "Нэвтрэх",
                        onPressed: () {
                          if (_formKey.currentState?.validate() == true) {
                            widget.onLogin(emailController.text, toRemind);
                          }
                        },
                      ),
                      VSpacer(),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: 'Хаяг байхгүй?',
                            style:
                                const TextStyle(color: GoodaliColors.grayColor),
                            children: <TextSpan>[
                              TextSpan(
                                text: '  Бүртгүүлэх',
                                style: const TextStyle(
                                    color: GoodaliColors.primaryColor,
                                    fontWeight: FontWeight.bold),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    setState(() {
                                      isTyping = false;
                                    });
                                    widget.onRegister();
                                  },
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
