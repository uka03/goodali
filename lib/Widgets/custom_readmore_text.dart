import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Utils/utils.dart';
import 'package:readmore/readmore.dart';

class CustomReadMoreText extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  const CustomReadMoreText(
      {Key? key, required this.text, this.textAlign = TextAlign.start})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReadMoreText(
      parseHtmlString(text),
      trimLines: 3,
      trimMode: TrimMode.Line,
      trimCollapsedText: 'Цааш унших',
      trimExpandedText: 'Хураах',
      textAlign: textAlign,
      style: TextStyle(fontSize: 14, height: 1.6, color: MyColors.gray),
      moreStyle: TextStyle(
          fontSize: 14,
          decoration: TextDecoration.underline,
          color: MyColors.black),
      lessStyle: TextStyle(
          fontSize: 14,
          decoration: TextDecoration.underline,
          color: MyColors.black),
    );
  }
}
