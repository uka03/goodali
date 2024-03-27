import 'package:flutter/material.dart';
import 'package:goodali/pages/auth/components/auth_input.dart';
import 'package:goodali/pages/auth/provider/auth_provider.dart';
import 'package:goodali/shared/components/appbar_with_back.dart';
import 'package:goodali/shared/components/general_scaffold.dart';
import 'package:goodali/shared/components/keyboard_hider.dart';
import 'package:goodali/utils/globals.dart';
import 'package:goodali/utils/primary_button.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/toasts.dart';
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  static String routeName = "/change_password";

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  late AuthProvider authProvider;
  final _formKey = GlobalKey<FormState>();

  final _oldPinCode = TextEditingController();
  final _newPinCode = TextEditingController();
  final _confirmPinCode = TextEditingController();

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardHider(
      child: GeneralScaffold(
        actionButton: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: PrimaryButton(
            text: "Үргэлжлүүлэх",
            height: 50,
            onPressed: () async {
              if (_formKey.currentState?.validate() == true) {
                if (_confirmPinCode.text == _newPinCode.text) {
                  if (_confirmPinCode.text.length < 4 ||
                      _newPinCode.text.length < 4 ||
                      _oldPinCode.text.length < 4) {
                    Toast.error(context, description: "Пин код дутуу байна.");
                  } else {
                    showLoader();
                    final response = await authProvider.changePassword(
                        oldPassword: _oldPinCode.text,
                        newPassword: _confirmPinCode.text);
                    if (response.status == 1) {
                      if (context.mounted) {
                        Toast.success(context,
                            description: "Пин код амжилттай солигдлоо.");
                        Navigator.pop(context);
                      }
                    } else {
                      if (context.mounted) {
                        Toast.error(context, description: response.message);
                      }
                    }
                    dismissLoader();
                  }
                } else {
                  Toast.error(context,
                      description: "Пин код тохирохгүй байна.");
                }
              }
            },
          ),
        ),
        appBar: AppbarWithBackButton(),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Пин код солих",
                  style: GoodaliTextStyles.titleText(
                    context,
                    fontSize: 32,
                  ),
                ),
                VSpacer(),
                AuthInput(
                  keyboardType: TextInputType.number,
                  isEmail: false,
                  hintText: "Одоогийн пин код",
                  isTyping: false,
                  maxLength: 4,
                  onClose: () {},
                  controller: _oldPinCode,
                  onChanged: (val) {},
                ),
                VSpacer(),
                AuthInput(
                  isEmail: false,
                  isTyping: false,
                  maxLength: 4,
                  keyboardType: TextInputType.number,
                  hintText: "Шинэ пин код",
                  onClose: () {},
                  controller: _newPinCode,
                  onChanged: (val) {},
                ),
                VSpacer(),
                AuthInput(
                  keyboardType: TextInputType.number,
                  isEmail: false,
                  isTyping: false,
                  maxLength: 4,
                  hintText: "Пин код давтах",
                  onClose: () {},
                  controller: _confirmPinCode,
                  onChanged: (val) {},
                ),
                Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
