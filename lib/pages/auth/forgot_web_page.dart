import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:goodali/Utils/colors.dart';
import 'package:goodali/Utils/globals.dart';
import 'package:goodali/Utils/primary_button.dart';
import 'package:goodali/Utils/spacer.dart';
import 'package:goodali/Utils/text_styles.dart';
import 'package:goodali/Utils/toasts.dart';
import 'package:goodali/pages/auth/components/auth_input.dart';
import 'package:goodali/pages/auth/provider/auth_provider.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/shared/components/general_scaffold.dart';
import 'package:provider/provider.dart';

class ForgotWebPage extends StatefulWidget {
  const ForgotWebPage({super.key});
  static String routeName = "/forgot-web";

  @override
  State<ForgotWebPage> createState() => _ForgotWebPageState();
}

class _ForgotWebPageState extends State<ForgotWebPage> {
  final _form = GlobalKey<FormState>();
  late final AuthProvider _authProvider;
  final TextEditingController _emailController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return GeneralScaffold(
      child: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                  child: Image.asset(
                    "assets/images/logo.png",
                    height: 32,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "Хаяг байхгаа юу?   ",
                      style: GoodaliTextStyles.titleText(context, fontSize: 14),
                    ),
                    CustomButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Нэвтрэх",
                        style: GoodaliTextStyles.titleText(context, fontSize: 14, textColor: GoodaliColors.primaryColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              width: kIsWeb ? 400 : null,
              child: Form(
                key: _form,
                child: Column(
                  children: [
                    Text(
                      "Пин код мартсан",
                      style: GoodaliTextStyles.titleText(context, fontSize: 32),
                    ),
                    VSpacer(),
                    Text(
                      "Та өөрийн и-мэйл хаягаа оруулснаар бид таньруу шинэ пин код илгээх болно.",
                      style: GoodaliTextStyles.bodyText(context, fontSize: 16),
                    ),
                    VSpacer(),
                    AuthInput(
                      isTyping: false,
                      onClose: () {},
                      controller: _emailController,
                      onChanged: (value) {},
                      keyboardType: TextInputType.emailAddress,
                    ),
                    VSpacer.lg(),
                    Row(
                      children: [
                        Expanded(
                          child: PrimaryButton(
                            text: "Үргэлжлүүлэх",
                            onPressed: () async {
                              if (_form.currentState!.validate()) {
                                showLoader();
                                final response = await _authProvider.recovery(email: _emailController.text);
                                dismissLoader();
                                if (response.status == 1 && context.mounted) {
                                  Toast.success(context, description: "Шинэ нэвтрэх пин кодыг и-мэйлээр илгээгдлээ.");
                                  Navigator.pop(context);
                                } else if (context.mounted) {
                                  Toast.error(context, description: "Алдаа гарлаа");
                                }
                              }
                            },
                          ),
                        ),
                        Expanded(child: SizedBox())
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(),
          ],
        ),
      ),
    );
  }
}
