import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:goodali/pages/auth/components/auth_input.dart';
import 'package:goodali/pages/auth/provider/auth_provider.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/shared/components/general_scaffold.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/globals.dart';
import 'package:goodali/utils/primary_button.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/toasts.dart';
import 'package:provider/provider.dart';

class AuthWebPage extends StatefulWidget {
  static String routeName = "/login";
  const AuthWebPage({super.key});

  @override
  State<AuthWebPage> createState() => _AuthWebPageState();
}

class _AuthWebPageState extends State<AuthWebPage> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  bool isTypingEmail = false;
  bool isTypingPassword = false;
  final _form = GlobalKey<FormState>();

  late final AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return GeneralScaffold(
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    color: GoodaliColors.errorColor,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(30),
                    child: Center(
                      child: Form(
                        key: _form,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "Хаяг байхгүй? ",
                                  style: GoodaliTextStyles.titleText(context,
                                      fontSize: 14),
                                ),
                                CustomButton(
                                  onPressed: () {},
                                  child: Text(
                                    "Бүртгүүлэх",
                                    style: GoodaliTextStyles.titleText(context,
                                        fontSize: 14,
                                        textColor: GoodaliColors.primaryColor),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 340,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Нэвтрэх",
                                    style: GoodaliTextStyles.titleText(context,
                                        fontSize: 32),
                                  ),
                                  VSpacer(),
                                  AuthInput(
                                    isTyping: isTypingEmail,
                                    onClose: () {
                                      _controllerEmail.clear();
                                      setState(() {
                                        isTypingEmail = false;
                                      });
                                    },
                                    controller: _controllerEmail,
                                    onChanged: (value) {
                                      if (!isTypingEmail) {
                                        setState(() {
                                          isTypingEmail = true;
                                        });
                                      }
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  VSpacer(),
                                  AuthInput(
                                    isEmail: false,
                                    hintText: "Пин код",
                                    isNumber: true,
                                    maxLength: 4,
                                    isTyping: isTypingPassword,
                                    onClose: () {
                                      _controllerPassword.clear();
                                      setState(() {
                                        isTypingPassword = false;
                                      });
                                    },
                                    controller: _controllerPassword,
                                    onChanged: (value) {
                                      if (!isTypingPassword) {
                                        setState(() {
                                          isTypingPassword = true;
                                        });
                                      }
                                    },
                                    keyboardType: TextInputType.number,
                                  ),
                                  VSpacer(),
                                  Text(
                                    "Пин код мартсан?",
                                    style: GoodaliTextStyles.titleText(context,
                                        fontSize: 14,
                                        textColor: GoodaliColors.primaryColor),
                                  ),
                                  VSpacer.lg(),
                                  PrimaryButton(
                                    text: "Нэвтрэх",
                                    height: 50,
                                    textFontSize: 16,
                                    onPressed: () async {
                                      if (_form.currentState?.validate() ==
                                          true) {
                                        showLoader();
                                        final response =
                                            await authProvider.login(
                                                email: _controllerEmail.text,
                                                password:
                                                    _controllerPassword.text);
                                        dismissLoader();
                                        if (response.token?.isNotEmpty ==
                                                true &&
                                            context.mounted) {
                                          Toast.success(context,
                                              description:
                                                  "Амжилттай нэвтэрлээ.");
                                          Navigator.pop(context);
                                        } else {
                                          if (context.mounted) {
                                            Toast.error(context,
                                                description: response.message);
                                          }
                                        }
                                      }
                                    },
                                  )
                                ],
                              ),
                            ),
                            SizedBox(),
                          ],
                        ),
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
  }
}
