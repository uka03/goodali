import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:goodali/pages/auth/components/auth_input.dart';
import 'package:goodali/shared/components/keyboard_hider.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/primary_button.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/toasts.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage(
      {super.key, required this.onLogin, required this.onRegister});
  final Function() onLogin;
  final Function(String name, String email, String pincode) onRegister;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isTyping = false;
  bool isNameTyping = false;
  bool passwordTyping = false;
  bool confirmTyping = false;

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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VSpacer(size: 50),
                      Row(
                        children: [
                          Text(
                            "Бүртгүүлэх",
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
                      AuthInput(
                        keyboardType: TextInputType.name,
                        isEmail: false,
                        isTyping: isNameTyping,
                        hintText: "Нэр",
                        onClose: () {
                          nameController.clear();
                          setState(() {
                            isNameTyping = false;
                          });
                        },
                        controller: nameController,
                        onChanged: (value) {
                          setState(() {
                            isNameTyping = true;
                          });
                        },
                      ),
                      VSpacer.sm(),
                      Text(
                        "Та өөртөө хүссэн нэрээ өгөөрэй",
                        style: GoodaliTextStyles.bodyText(context),
                      ),
                      AuthInput(
                        keyboardType: TextInputType.number,
                        isEmail: false,
                        isTyping: passwordTyping,
                        hintText: "Пинкод",
                        onClose: () {
                          passwordController.clear();
                          setState(() {
                            passwordTyping = false;
                          });
                        },
                        maxLength: 4,
                        controller: passwordController,
                        onChanged: (value) {
                          setState(() {
                            passwordTyping = true;
                          });
                        },
                      ),
                      AuthInput(
                        keyboardType: TextInputType.number,
                        isEmail: false,
                        isTyping: confirmTyping,
                        hintText: "Пинкод давтах",
                        maxLength: 4,
                        onClose: () {
                          confirmController.clear();
                          setState(() {
                            confirmTyping = false;
                          });
                        },
                        controller: confirmController,
                        onChanged: (value) {
                          setState(() {
                            confirmTyping = true;
                          });
                        },
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      PrimaryButton(
                        height: 50,
                        borderRadius: 20,
                        text: "Бүртгүүлэх",
                        onPressed: () {
                          if (_formKey.currentState?.validate() == true) {
                            if (confirmController.text.length < 4 ||
                                passwordController.text.length < 4) {
                              Toast.error(context,
                                  description:
                                      "Пин код 4 оронтой байх хэрэгтэй.");
                            }
                            if (confirmController.text ==
                                passwordController.text) {
                              widget.onRegister(nameController.text,
                                  emailController.text, confirmController.text);
                            } else {
                              Toast.error(context,
                                  description: "Пин код тохирохгүй байна.");
                            }
                          }
                        },
                      ),
                      VSpacer(),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: 'Хаяг байгаа? ',
                            style:
                                const TextStyle(color: GoodaliColors.grayColor),
                            children: <TextSpan>[
                              TextSpan(
                                text: ' Нэвтрэх',
                                style: const TextStyle(
                                    color: GoodaliColors.primaryColor,
                                    fontWeight: FontWeight.bold),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    setState(() {
                                      isTyping = false;
                                    });
                                    widget.onLogin();
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
