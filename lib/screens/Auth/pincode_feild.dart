import 'package:flutter/material.dart';
import 'package:goodali/Widgets/numeric_keyboard.dart';

class PincodeField extends StatefulWidget {
  const PincodeField({Key? key}) : super(key: key);

  @override
  State<PincodeField> createState() => _PincodeFieldState();
}

class _PincodeFieldState extends State<PincodeField> {
  String? pincode;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
      height: MediaQuery.of(context).size.height - 80,
      child: Column(
        children: [
          NumericKeyboard(
            onKeyboardTab: onKeyboardTap,
            deleteButton: () {
              setState(() {
                String newValue = pincode!.substring(0, pincode!.length - 1);
              });
            },
          )
        ],
      ),
    );
  }

  onKeyboardTap(String value) {
    setState(() {
      pincode = value;
    });
  }
}
