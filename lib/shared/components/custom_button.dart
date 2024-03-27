import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key, required this.child, this.onPressed, this.borderRadius});

  final Widget child;
  final VoidCallback? onPressed;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: borderRadius,
      onTap: onPressed,
      child: child,
    );
  }
}
