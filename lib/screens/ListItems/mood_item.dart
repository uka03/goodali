import 'package:flutter/material.dart';
import 'package:goodali/Utils/utils.dart';
import 'package:goodali/models/get_mood_list.dart';
import 'package:goodali/screens/HomeScreen/feelTab/mood_detail.dart';

class MoodListItem extends StatelessWidget {
  final GetMoodList? getMoodList;
  const MoodListItem({Key? key, this.getMoodList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  MoodDetail(moodListId: getMoodList!.id.toString()))),
      child: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  getRandomColors(),
                  getRandomColors().withOpacity(0.5),
                ]),
            borderRadius: BorderRadius.circular(60)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(.0),
            child: Text(
              getMoodList?.title?.capitalize() ?? "",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
