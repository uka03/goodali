import 'package:flutter/material.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/spacer.dart';

typedef KeyboardTab = void Function(String value);

class NumericKeyboard extends StatelessWidget {
  final KeyboardTab onKeyboardTab;
  final VoidCallback deleteButton;
  const NumericKeyboard({
    super.key,
    required this.onKeyboardTab,
    required this.deleteButton,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ButtonBar(
            buttonPadding: const EdgeInsets.all(0),
            alignment: MainAxisAlignment.spaceAround,
            children: [
              _button('1'),
              _button('2'),
              _button('3'),
            ],
          ),
          VSpacer(),
          ButtonBar(
            buttonPadding: const EdgeInsets.all(0),
            alignment: MainAxisAlignment.spaceAround,
            children: [
              _button('4'),
              _button('5'),
              _button('6'),
            ],
          ),
          VSpacer(),
          ButtonBar(
            buttonPadding: const EdgeInsets.all(0),
            alignment: MainAxisAlignment.spaceAround,
            children: [
              _button('7'),
              _button('8'),
              _button('9'),
            ],
          ),
          VSpacer(),
          ButtonBar(
            alignment: MainAxisAlignment.spaceAround,
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
                    child: const Icon(
                      Icons.keyboard_arrow_left,
                    ),
                  ))
            ],
          ),
        ],
      ),
    );
  }

  Widget _button(String value) {
    return CustomButton(
      borderRadius: BorderRadius.circular(50),
      onPressed: () {
        onKeyboardTab(value);
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
        ),
        width: 64,
        height: 64,
        child: Text(
          value,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: GoodaliColors.blackColor,
          ),
        ),
      ),
    );
  }
}
