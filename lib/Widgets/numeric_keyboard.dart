import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:iconly/iconly.dart';

typedef KeyboardTab = void Function(String value);

class NumericKeyboard extends StatelessWidget {
  final KeyboardTab onKeyboardTab;
  final VoidCallback deleteButton;
  const NumericKeyboard(
      {Key? key, required this.onKeyboardTab, required this.deleteButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ButtonBar(
            buttonPadding: const EdgeInsets.all(0),
            alignment: MainAxisAlignment.spaceEvenly,
            children: [
              _button('1'),
              _button('2'),
              _button('3'),
            ],
          ),
          ButtonBar(
            buttonPadding: const EdgeInsets.all(0),
            alignment: MainAxisAlignment.spaceEvenly,
            children: [
              _button('4'),
              _button('5'),
              _button('6'),
            ],
          ),
          ButtonBar(
            buttonPadding: const EdgeInsets.all(0),
            alignment: MainAxisAlignment.spaceEvenly,
            children: [
              _button('7'),
              _button('8'),
              _button('9'),
            ],
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(width: 50, height: 50),
              _button('0'),
              InkWell(
                  borderRadius: BorderRadius.circular(45),
                  onTap: deleteButton,
                  child: Container(
                    height: 50,
                    width: 50,
                    alignment: Alignment.center,
                    child: const Icon(IconlyLight.arrow_left),
                  ))
            ],
          ),
        ],
      ),
    );
  }

  Widget _button(String value) {
    return TextButton(
      onPressed: () {
        onKeyboardTab(value);
      },
      child: Container(
        alignment: Alignment.center,
        width: 50,
        height: 50,
        child: Text(
          value,
          style: const TextStyle(
              fontSize: 26, fontWeight: FontWeight.bold, color: MyColors.black),
        ),
      ),
    );
  }
}
