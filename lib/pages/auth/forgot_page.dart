import 'package:flutter/material.dart';
import 'package:goodali/pages/auth/components/auth_input.dart';
import 'package:goodali/shared/components/keyboard_hider.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/primary_button.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';

class ForgotPage extends StatefulWidget {
  const ForgotPage({super.key, required this.onContinue});
  final Function(String) onContinue;

  @override
  State<ForgotPage> createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isTyping = false;
  @override
  void initState() {
    super.initState();
    isTyping = emailController.text.isEmpty;
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
                      VSpacer(size: 100),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Пин код мартсан",
                            style: GoodaliTextStyles.titleText(
                              context,
                              fontSize: 32,
                            ),
                          ),
                        ],
                      ),
                      VSpacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                "Та өөрийн и-мэйл хаягаа оруулснаар бид таньруу шинэ пин код илгээх болно",
                                textAlign: TextAlign.center,
                                style: GoodaliTextStyles.bodyText(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                      VSpacer(size: 40),
                      AuthInput(
                        isTyping: isTyping,
                        onClose: () {
                          emailController.clear();
                          setState(() {
                            isTyping = false;
                          });
                        },
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        onChanged: (value) {
                          setState(() {
                            isTyping = true;
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
                        text: "Үргэлжлүүлэх",
                        onPressed: () {
                          if (_formKey.currentState?.validate() == true) {
                            widget.onContinue(emailController.text);
                          }
                        },
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
