import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPress;
  const CustomElevatedButton({Key? key, this.text = "", this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
          onPressed: onPress,
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 0,
              backgroundColor: MyColors.primaryColor)),
    );
  }
}
