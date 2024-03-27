import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:goodali/pages/auth/components/auth_input.dart';
import 'package:goodali/shared/components/keyboard_hider.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/primary_button.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage(
      {super.key, required this.onLogin, required this.onRegister});
  final Function() onLogin;
  final Function(String name, String email) onRegister;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isTyping = false;

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
                        isTyping: isTyping,
                        hintText: "Нэр",
                        onClose: () {
                          emailController.clear();
                          setState(() {
                            isTyping = false;
                          });
                        },
                        controller: nameController,
                        onChanged: (value) {
                          setState(() {
                            isTyping = true;
                          });
                        },
                      ),
                      VSpacer.sm(),
                      Text(
                        "Та өөртөө хүссэн нэрээ өгөөрэй",
                        style: GoodaliTextStyles.bodyText(context),
                      )
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
                            widget.onRegister(
                                nameController.text, emailController.text);
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
