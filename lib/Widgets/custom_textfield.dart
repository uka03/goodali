import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final int? maxLength;
  final int? maxLines;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;

  const CustomTextField(
      {Key? key,
      this.controller,
      this.hintText,
      this.maxLength,
      this.maxLines,
      this.textInputAction,
      this.textInputType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: MyColors.primaryColor,
      textInputAction: textInputAction,
      keyboardType: textInputType,
      decoration: InputDecoration(
        hintText: hintText ?? "",
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: MyColors.border1, width: 0.5),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: MyColors.primaryColor),
        ),
      ),
      maxLength: maxLength,
      maxLines: maxLines,
    );
  }
}
