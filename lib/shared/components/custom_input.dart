import 'package:flutter/material.dart';
import 'package:goodali/utils/colors.dart';

class CustomInput extends StatelessWidget {
  const CustomInput({
    super.key,
    this.prefixIcon,
    this.hintText,
    required this.controller,
    this.textInputAction,
    this.onTap,
    this.readOnly = false,
    this.withIcon = true,
    this.iconColor,
    this.onChanged,
    this.suffixIcon,
  });
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? hintText;
  final TextEditingController controller;
  final TextInputAction? textInputAction;
  final Function()? onTap;
  final bool readOnly;
  final bool withIcon;
  final Color? iconColor;
  final Function(String value)? onChanged;
  @override
  Widget build(BuildContext context) {
    return TextField(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      onChanged: onChanged,
      readOnly: readOnly,
      controller: controller,
      textInputAction: textInputAction ?? TextInputAction.search,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        suffixIcon: suffixIcon,
        prefixIcon: withIcon
            ? prefixIcon ??
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: Image.asset(
                      "assets/icons/ic_search.png",
                      color: iconColor ?? GoodaliColors.grayColor,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
            : null,
        hintText: hintText ?? 'Хайх...',
        fillColor: GoodaliColors.inputColor,
        filled: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      ),
    );
  }
}
