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
import 'package:shared_preferences/shared_preferences.dart';

class AuthWebPage extends StatefulWidget {
  static String routeName = "/login";
  const AuthWebPage({super.key});

  @override
  State<AuthWebPage> createState() => _AuthWebPageState();
}

class _AuthWebPageState extends State<AuthWebPage> {
  bool isLogin = true;
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
                  child: Image.asset(
                    isLogin ? "assets/images/login_bg.png" : "assets/images/register_bg.png",
                    fit: BoxFit.cover,
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
                                  isLogin ? "Хаяг байхгүй?   " : "Хаяг байхгаа юу?   ",
                                  style: GoodaliTextStyles.titleText(context, fontSize: 14),
                                ),
                                CustomButton(
                                  onPressed: () {
                                    setState(() {
                                      isLogin = !isLogin;
                                    });
                                  },
                                  child: Text(
                                    isLogin ? "Бүртгүүлэх" : "Нэвтрэх",
                                    style: GoodaliTextStyles.titleText(context, fontSize: 14, textColor: GoodaliColors.primaryColor),
                                  ),
                                ),
                              ],
                            ),
                            isLogin ? login(context) : register(context),
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

  SizedBox login(BuildContext context) {
    final TextEditingController controllerEmail = TextEditingController();
    final TextEditingController controllerPassword = TextEditingController();

    return SizedBox(
      width: 340,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Нэвтрэх",
            style: GoodaliTextStyles.titleText(context, fontSize: 32),
          ),
          VSpacer(),
          AuthInput(
            isTyping: false,
            onClose: () {},
            controller: controllerEmail,
            onChanged: (value) {},
            keyboardType: TextInputType.emailAddress,
          ),
          VSpacer(),
          AuthInput(
            isEmail: false,
            hintText: "Пин код",
            isNumber: true,
            maxLength: 4,
            isTyping: false,
            onClose: () {},
            controller: controllerPassword,
            onChanged: (value) {},
            keyboardType: TextInputType.number,
          ),
          VSpacer(),
          Text(
            "Пин код мартсан?",
            style: GoodaliTextStyles.titleText(context, fontSize: 14, textColor: GoodaliColors.primaryColor),
          ),
          VSpacer.lg(),
          PrimaryButton(
            text: "Нэвтрэх",
            height: 50,
            textFontSize: 16,
            onPressed: () async {
              if (_form.currentState?.validate() == true) {
                showLoader();
                final response = await authProvider.login(email: controllerEmail.text, password: controllerPassword.text);
                dismissLoader();
                if (response.token?.isNotEmpty == true && context.mounted) {
                  Toast.success(context, description: "Амжилттай нэвтэрлээ.");
                  Navigator.pop(context);
                } else {
                  if (context.mounted) {
                    Toast.error(context, description: response.message);
                  }
                }
              }
            },
          )
        ],
      ),
    );
  }

  register(BuildContext context) {
    final TextEditingController controllerEmail = TextEditingController();
    final TextEditingController controllerPassword = TextEditingController();
    final TextEditingController controllerPasswordConfirm = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    return SizedBox(
      width: 340,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Бүртгүүлэх",
            style: GoodaliTextStyles.titleText(context, fontSize: 32),
          ),
          VSpacer(),
          AuthInput(
            isTyping: false,
            onClose: () {},
            controller: controllerEmail,
            onChanged: (value) {},
            keyboardType: TextInputType.emailAddress,
          ),
          VSpacer(),
          AuthInput(
            keyboardType: TextInputType.name,
            isEmail: false,
            isTyping: false,
            hintText: "Нэр",
            onClose: () {},
            controller: nameController,
            onChanged: (value) {},
          ),
          VSpacer.sm(),
          Text(
            "Та өөртөө хүссэн нэрээ өгөөрэй",
            style: GoodaliTextStyles.bodyText(context),
          ),
          VSpacer(),
          AuthInput(
            isEmail: false,
            hintText: "Пин код",
            isNumber: true,
            maxLength: 4,
            isTyping: false,
            onClose: () {},
            controller: controllerPassword,
            onChanged: (value) {},
            keyboardType: TextInputType.number,
          ),
          VSpacer(),
          AuthInput(
            isEmail: false,
            hintText: "Пин код давтах",
            isNumber: true,
            maxLength: 4,
            isTyping: false,
            onClose: () {},
            controller: controllerPasswordConfirm,
            onChanged: (value) {},
            keyboardType: TextInputType.number,
          ),
          VSpacer(),
          PrimaryButton(
            text: "Бүртгүүлэх",
            height: 50,
            textFontSize: 16,
            onPressed: () async {
              if (_form.currentState?.validate() == true) {
                if (controllerPassword.text == controllerPasswordConfirm.text) {
                  showLoader();
                  final response = await authProvider.logup(email: controllerEmail.text, password: controllerPasswordConfirm.text, name: nameController.text);
                  if (response.status == 1) {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    if (context.mounted) {
                      prefs.setString("email", controllerEmail.text);
                      prefs.remove("saved");
                      controllerEmail.clear();
                      nameController.clear();
                      Toast.success(context, description: response.msg);

                      setState(() {
                        isLogin = true;
                      });
                    }
                  } else {
                    if (context.mounted) {
                      Toast.error(context, description: response.msg);
                    }
                  }
                  dismissLoader();
                } else {
                  if (context.mounted) {
                    Toast.error(context, description: "Пин код таарахгүй байна.");
                  }
                }
              }
            },
          )
        ],
      ),
    );
  }
}
