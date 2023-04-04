import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/models/get_mood_list.dart';
import 'package:goodali/screens/HomeScreen/feelTab/mood_detail.dart';

class MoodListItem extends StatelessWidget {
  final GetMoodList? getMoodList;
  final bool? isHomeScreen;

  const MoodListItem({Key? key, this.getMoodList, this.isHomeScreen = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MoodDetail(moodListId: getMoodList!.id.toString()))),
      child: Column(
        children: [
          kIsWeb && isHomeScreen == true
              ? CircleAvatar(
                  radius: 75,
                  child: ClipOval(
                    child: ImageView(
                      imgPath: getMoodList!.banner!,
                      width: 150,
                      height: 150,
                    ),
                  ))
              : ClipRRect(
                  borderRadius: BorderRadius.circular(80),
                  child: ImageView(
                    imgPath: getMoodList!.banner!,
                    width: MediaQuery.of(context).size.width / 3 - 30,
                    height: MediaQuery.of(context).size.width / 3 - 30,
                  )),
          const SizedBox(height: 10),
          Text(
            getMoodList?.title ?? "",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: MyColors.black,
            ),
          ),
        ],
      ),
    );
  }
}
