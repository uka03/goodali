import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/utils/colors.dart';

class AuthInput extends StatelessWidget {
  const AuthInput({
    super.key,
    required this.isTyping,
    required this.onClose,
    required this.controller,
    required this.onChanged,
    this.hintText,
    this.isEmail = true,
    this.dismiss = false,
    this.maxLength,
    this.isExpand = false,
    required this.keyboardType,
    this.textInputAction,
    this.onValidator,
    this.isNumber = false,
  });
  final bool isTyping;
  final bool isEmail;
  final String? hintText;
  final Function() onClose;
  final Function(String) onChanged;
  final String? Function(String value)? onValidator;
  final TextEditingController controller;
  final bool dismiss;
  final int? maxLength;
  final bool isExpand;
  final bool isNumber;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: dismiss,
      maxLength: maxLength,
      maxLines: isExpand ? null : 1,
      cursorColor: GoodaliColors.primaryColor,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      validator: (value) {
        if (value?.isEmpty == true) {
          return "Заавал бөглөх ёстой";
        }
        if (!value!.isValidEmail()) {
          return isEmail ? "И-мэйл буруу байна." : null;
        }
        if (onValidator != null) {
          print("as");
          final res = onValidator!(value);
          return res;
        }
        return null;
      },
      inputFormatters:
          isNumber ? [FilteringTextInputFormatter.digitsOnly] : null,
      decoration: InputDecoration(
        hintText: hintText ?? "И-мэйл",
        suffix: isTyping
            ? GestureDetector(
                onTap: onClose,
                child: Icon(
                  Icons.close,
                  color: GoodaliColors.blackColor,
                ),
              )
            : SizedBox(),
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: GoodaliColors.borderColor),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: GoodaliColors.errorColor),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: GoodaliColors.borderColor),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: GoodaliColors.errorColor),
        ),
        fillColor: GoodaliColors.primaryBGColor,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: dismiss
                  ? GoodaliColors.borderColor
                  : GoodaliColors.primaryColor),
        ),
      ),
    );
  }
}
