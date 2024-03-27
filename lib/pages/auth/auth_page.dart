import 'package:flutter/material.dart';
import 'package:goodali/pages/auth/forgot_page.dart';
import 'package:goodali/pages/auth/login_page.dart';
import 'package:goodali/pages/auth/login_pincode.dart';
import 'package:goodali/pages/auth/provider/auth_provider.dart';
import 'package:goodali/pages/auth/recovery_confirm.dart';
import 'package:goodali/pages/auth/register_page.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/globals.dart';
import 'package:goodali/utils/primary_button.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/toasts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPage extends StatefulWidget {
  //login register forgot
  const AuthPage({
    super.key,
    this.page = "login",
  });

  final String page;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late PageController _controller;
  String page = "login";
  String email = "";
  String name = "";
  String firstPincode = "";
  String oldPincode = "";
  late AuthProvider authProvider;
  @override
  void initState() {
    super.initState();
    page = widget.page;
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    _controller = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    switch (page) {
      case "login":
        children = [
          LoginPage(
            onLogin: (emailValue, toRemind) async {
              email = emailValue;
              SharedPreferences prefs = await SharedPreferences.getInstance();
              if (toRemind) {
                prefs.setString("email", emailValue);
                prefs.setBool("saved", toRemind);
              } else {
                prefs.remove("email");
                prefs.remove("saved");
              }
              _controller.jumpToPage(1);
            },
            onRegister: () {
              setState(() {
                page = "register";
              });
              _controller.jumpToPage(0);
            },
          ),
          Pincode(
            bottomAction: CustomButton(
              onPressed: () {
                setState(() {
                  page = "forgot";
                });
                _controller.jumpToPage(0);
              },
              child: Text(
                "Пин код мартсан?",
                style: GoodaliTextStyles.bodyText(
                  context,
                  fontSize: 14,
                  textColor: GoodaliColors.primaryColor,
                ),
              ),
            ),
            onleading: () {
              _controller.jumpToPage(0);
            },
            onCompleted: (pincode) async {
              showLoader();
              final response =
                  await authProvider.login(email: email, password: pincode);
              dismissLoader();
              if (response.token?.isNotEmpty == true && context.mounted) {
                Toast.success(context, description: "Амжилттай нэвтэрлээ.");
                Navigator.pop(context);
              } else {
                if (context.mounted) {
                  Toast.error(context, description: response.message);
                }
              }
            },
            title: 'Пин код оруулна уу',
            withLeading: true,
          ),
        ];
        break;
      case "register":
        children = [
          RegisterPage(
            onLogin: () {
              setState(() {
                page = "login";
              });
              _controller.jumpToPage(0);
            },
            onRegister: (nameValue, emailValue) {
              FocusScope.of(context).unfocus();
              setState(() {
                email = emailValue;
                name = nameValue;
              });
              _controller.nextPage(
                  duration: Duration(microseconds: 1), curve: Curves.linear);
            },
          ),
          Pincode(
            onleading: () {
              _controller.previousPage(
                  duration: Duration(microseconds: 1), curve: Curves.linear);
            },
            onCompleted: (pincode) {
              setState(() {
                firstPincode = pincode;
              });
              _controller.nextPage(
                  duration: Duration(microseconds: 1), curve: Curves.linear);
            },
            title: 'Шинэ пин код оруулна уу',
            withLeading: false,
          ),
          Pincode(
            onleading: () {
              _controller.previousPage(
                  duration: Duration(microseconds: 1), curve: Curves.linear);
            },
            onCompleted: (pincode) async {
              if (firstPincode == pincode) {
                showLoader();
                final response = await authProvider.logup(
                    email: email, password: pincode, name: name);
                if (response.status == 1) {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  if (context.mounted) {
                    prefs.setString("email", email);
                    prefs.remove("saved");
                    email = "";
                    name = "";
                    firstPincode = "";
                    Toast.success(context, description: response.msg);
                    setState(() {
                      page = "login";
                    });
                    _controller.jumpToPage(0);
                  }
                } else {
                  if (context.mounted) {
                    Toast.error(context, description: response.msg);
                  }
                }
                dismissLoader();
              } else {
                Toast.error(context, description: "Пин код тохирохгүй байна.");
              }
            },
            title: 'Пин код давтан оруулна уу',
            withLeading: true,
          ),
        ];
        break;
      case "forgot":
        children = [
          ForgotPage(
            onContinue: (emailValue) async {
              FocusScope.of(context).unfocus();
              showLoader();
              final respone = await authProvider.recovery(email: email);
              if (respone.status == 1) {
                setState(() {
                  email = emailValue;
                });
              }
              dismissLoader();
              _controller.nextPage(
                  duration: Duration(milliseconds: 1), curve: Curves.linear);
            },
          ),
          RecoveryConfirm(
            onleading: () {
              _controller.previousPage(
                  duration: Duration(milliseconds: 1), curve: Curves.linear);
            },
            description:
                "Таны ${email.toUpperCase()} хаягт илгээсэн 4 оронтой кодыг оруулна уу.",
            onCompleted: (value) async {
              showLoader();
              final response = await authProvider.recoveryConfirm(
                  email: email, password: value);
              if (response.token?.isNotEmpty == true) {
                setState(() {
                  oldPincode = value;
                });

                _controller.nextPage(
                    duration: Duration(milliseconds: 1), curve: Curves.linear);
              } else {
                if (context.mounted) {
                  Toast.error(context,
                      description: "Баталгаажуулах код буруу байна.");
                }
              }
              dismissLoader();
            },
            title: "Баталгаажуулах",
          ),
          Pincode(
            onleading: () {
              _controller.previousPage(
                  duration: Duration(microseconds: 1), curve: Curves.linear);
            },
            onCompleted: (pincode) {
              setState(() {
                firstPincode = pincode;
              });
              _controller.nextPage(
                  duration: Duration(microseconds: 1), curve: Curves.linear);
            },
            title: 'Шинэ пин код оруулна уу',
            withLeading: false,
          ),
          Pincode(
            onleading: () {
              _controller.previousPage(
                  duration: Duration(microseconds: 1), curve: Curves.linear);
            },
            onCompleted: (pincode) async {
              if (firstPincode == pincode) {
                showLoader();
                final response = await authProvider.changePassword(
                    oldPassword: oldPincode, newPassword: pincode);
                if (response.status == 1) {
                  if (context.mounted) {
                    email = "";
                    firstPincode = "";
                    oldPincode = "";
                    Toast.success(context, description: response.msg);
                    setState(() {
                      page = "login";
                    });
                    _controller.jumpToPage(0);
                  }
                } else {
                  if (context.mounted) {
                    Toast.error(context, description: response.message);
                  }
                }
                dismissLoader();
              } else {
                Toast.error(context, description: "Пин код тохирохгүй байна.");
              }
            },
            title: 'Пин код давтан оруулна уу',
            withLeading: true,
          ),
        ];
        break;
      default:
        children = [
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  VSpacer(size: 150),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: GoodaliColors.inputColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      padding: EdgeInsets.all(40),
                      child: Image.asset(
                        "assets/icons/ic_error.png",
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  VSpacer(size: 30),
                  Text(
                    "Алдаа гарлаа.",
                    style: GoodaliTextStyles.titleText(
                      context,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
              PrimaryButton(
                height: 50,
                borderRadius: 20,
                text: "Буцах",
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          )
        ];
    }
    return PageView(
      controller: _controller,
      physics: NeverScrollableScrollPhysics(),
      children: children,
    );
  }
}
