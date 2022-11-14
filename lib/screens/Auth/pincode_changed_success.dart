import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/custom_elevated_button.dart';

class PinCodeChangedSuccess extends StatelessWidget {
  final String? buttonText;
  final String? successText;
  final String? descriptionText;
  const PinCodeChangedSuccess(
      {Key? key, this.buttonText, this.successText, this.descriptionText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 156),
          Center(
            child: CircleAvatar(
              radius: 62,
              backgroundColor: MyColors.input,
              child: SvgPicture.asset(
                "assets/images/success.svg",
              ),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            successText ?? "Амжилттай",
            style: const TextStyle(
                color: MyColors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            descriptionText ?? "Шинэ пин код и-мэйлээр илгээгдлээ.",
            style: const TextStyle(
              color: MyColors.gray,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: CustomElevatedButton(
              onPress: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              text: buttonText ?? "Дуусгах",
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
