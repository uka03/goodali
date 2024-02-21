import 'dart:io';
import 'dart:math';
import 'dart:developer' as dev;

import 'package:ffmpeg_kit_flutter/ffprobe_kit.dart';
import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/models/products_model.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';

Color getRandomColors() {
  final colors = List<int>.generate(15, (i) => generateRandomCode(0xdd98FFFD, 0xee32E7E4));
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

double valueFromPercentageInRange({required final double min, max, percentage}) {
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
  return Random().nextInt((maxValue - minValue).abs() + 1) + min(minValue, maxValue);
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

List<Products> removeDuplicates(List<Products> items) {
  List<Products> uniqueItems = []; // uniqueList
  var uniqueIDs = items.map((e) => e.title).toSet(); //list if UniqueID to remove duplicates
  for (var e in uniqueIDs) {
    uniqueItems.add(items.firstWhere((i) => i.title == e));
  } // populate uniqueItems with equivalent original Batch items
  return uniqueItems; //send back the unique items list
}

class Utils {
  static showLoaderDialog(BuildContext context) {
    AlertDialog alert = const AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: MyColors.primaryColor,
          )
        ],
      ),
    );
    showDialog(barrierDismissible: false, context: context, builder: (BuildContext context) => alert);
  }
}

Future<Duration> getTotalDuration(Products product, String url) async {
  Duration totalDuration;
  try {
    if (product.duration == null || product.duration == 0) {
      totalDuration = await getFileDuration(url);
    } else {
      totalDuration = Duration(milliseconds: product.duration!);
    }
  } catch (e) {
    dev.log(e.toString(), name: "utils: getTotalDuration");
    totalDuration = Duration.zero;
  }

  return totalDuration;
}

Future<Duration> getFileDuration(String mediaPath) async {
  final mediaInfoSession = await FFprobeKit.getMediaInformation(mediaPath);
  final mediaInfo = mediaInfoSession.getMediaInformation()!;
  final double duration = double.parse(mediaInfo.getDuration()!);

  return Duration(milliseconds: (duration * 1000).toInt());
}
