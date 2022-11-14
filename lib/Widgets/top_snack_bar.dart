import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:iconly/iconly.dart';

class TopSnackBar {
  static Flushbar successFactory(
      {String title = "Амжилттай", String msg = ""}) {
    return Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        titleText: Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: MyColors.black)),
        boxShadows: const [BoxShadow(color: Colors.black12, blurRadius: 20)],
        margin: const EdgeInsets.symmetric(horizontal: 20),
        borderRadius: BorderRadius.circular(10),
        messageText: Text(msg,
            style: const TextStyle(fontSize: 12, color: MyColors.gray)),
        backgroundColor: Colors.white,
        duration: const Duration(seconds: 2),
        icon: const Icon(Icons.done, color: MyColors.success));
  }

  static Flushbar errorFactory({String title = "Уучлаарай", String msg = ""}) {
    return Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        titleText: Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: MyColors.black)),
        boxShadows: const [BoxShadow(color: Colors.black12, blurRadius: 20)],
        margin: const EdgeInsets.symmetric(horizontal: 20),
        messageText: Text(msg,
            style: const TextStyle(fontSize: 12, color: MyColors.gray)),
        borderRadius: BorderRadius.circular(10),
        backgroundColor: Colors.white,
        duration: const Duration(seconds: 2),
        icon: const Icon(IconlyLight.close_square, color: MyColors.error));
  }
}
