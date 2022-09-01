import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';

class Downloaded extends StatefulWidget {
  const Downloaded({Key? key}) : super(key: key);

  @override
  State<Downloaded> createState() => _DownloadedState();
}

class _DownloadedState extends State<Downloaded> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SizedBox(height: 10),
          Text("Онлайн сургалт",
              style: TextStyle(
                  color: MyColors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
