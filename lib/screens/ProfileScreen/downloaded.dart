import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/models/item_holder.dart';
import 'package:goodali/screens/audioScreens.dart/audio_progress_bar.dart';

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
