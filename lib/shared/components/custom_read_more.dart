import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class CustomReadMore extends StatelessWidget {
  const CustomReadMore({
    super.key,
    required this.text,
    this.trimLines,
  });

  final String text;
  final int? trimLines;

  @override
  Widget build(BuildContext context) {
    return ReadMoreText(
      text,
      textAlign: TextAlign.center,
      trimLines: trimLines ?? 3,
      trimMode: TrimMode.Line,
      trimCollapsedText: 'Цааш унших',
      trimExpandedText: 'Хураах',
      lessStyle: TextStyle(
        decoration: TextDecoration.underline,
        fontWeight: FontWeight.w500,
      ),
      moreStyle: TextStyle(
        decoration: TextDecoration.underline,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
