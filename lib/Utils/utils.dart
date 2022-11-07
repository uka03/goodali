import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';

Color getRandomColors() {
  final colors =
      List<int>.generate(15, (i) => generateRandomCode(0xdd98FFFD, 0xee32E7E4));
  Color generatedColor = const Color(0xFF32E7E4);

  for (var i = 0; i < 15; i++) {
    generatedColor = Color(colors[i]);
  }
  return generatedColor;
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

double valueFromPercentageInRange(
    {required final double min, max, percentage}) {
  return percentage * (max - min) + min;
}

double percentageFromValueInRange({required final double min, max, value}) {
  return (value - min) / (max - min);
}

String dateTimeFormatter(String date) {
  final f = DateFormat('yyyy.MM.dd');
  DateTime parsedDate = HttpDate.parse(date);
  return f.format(parsedDate);
}

int generateRandomCode(int minValue, int maxValue) {
  return Random().nextInt((maxValue - minValue).abs() + 1) +
      min(minValue, maxValue);
}

bool isEmailCorrect(String value) {
  String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = RegExp(p);
  return regExp.hasMatch(value);
}

String parseHtmlString(String htmlString) {
  final document = parse(htmlString);
  final String parsedString = parse(document.body?.text).documentElement!.text;

  return parsedString;
}

String formatTime(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final hours = twoDigits(duration.inHours);
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));
  return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
}

class Utils {
  static showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(
            color: MyColors.primaryColor,
          )
        ],
      ),
    );
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => alert);
  }
}
