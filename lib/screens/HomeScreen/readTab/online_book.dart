import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/custom_appbar.dart';
import 'package:goodali/Widgets/info.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:iconly/iconly.dart';

class OnlineBook extends StatefulWidget {
  const OnlineBook({Key? key}) : super(key: key);

  @override
  State<OnlineBook> createState() => _OnlineBookState();
}

class _OnlineBookState extends State<OnlineBook> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(),
      body: Column(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(height: 220, color: MyColors.primaryColor),
              const SizedBox(height: 25),
              const Text(
                "Үхэл үгүй",
                style: TextStyle(
                    color: MyColors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              const Text("Online book",
                  style: TextStyle(fontSize: 12, color: MyColors.primaryColor)),
              const SizedBox(height: 30),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                      "Hun doroi bojee. Bolj l ugwul uuriinhoo umnuus uruuliig zarj, bugdiig amarchilj, orligch, tuslagch, asragch, zusen zuilin megrhiehr ksfn kfjdkfj dkjfhkdf kdfhkdfh kdfhkdhf kdbfkhbdf kdjhbf.",
                      style: TextStyle(
                        fontSize: 14,
                        color: MyColors.gray,
                        height: 1.75,
                      )),
                  Spacer(),
                  Info(title: "Хуудасны тоо", information: "54"),
                  Info(title: "Үнэ", information: "25,000 MNT"),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 280,
                  child: ElevatedButton(
                      child: const Text(
                        "Худалдаж авах",
                        style: TextStyle(fontSize: 16),
                      ),
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                          primary: MyColors.primaryColor)),
                ),
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: MyColors.input),
                  child: IconButton(
                      onPressed: () {},
                      splashRadius: 10,
                      icon: const Icon(
                        IconlyLight.buy,
                        size: 28,
                        color: MyColors.primaryColor,
                      )),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
