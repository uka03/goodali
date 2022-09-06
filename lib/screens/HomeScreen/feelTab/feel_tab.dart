import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/Utils/utils.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/custom_readmore_text.dart';
import 'package:goodali/models/get_mood_list.dart';
import 'package:goodali/models/mood_main.dart';
import 'package:goodali/screens/ListItems/mood_item.dart';

class FeelTabbar extends StatefulWidget {
  const FeelTabbar({Key? key}) : super(key: key);

  @override
  State<FeelTabbar> createState() => _FeelTabbarState();
}

class _FeelTabbarState extends State<FeelTabbar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder(
          future: Future.wait([getMoodList(), getMoodMain()]),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              List<GetMoodList> moodList = snapshot.data[0];
              List<MoodMain> moodMain = snapshot.data[1];
              if (moodList.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 30.0, bottom: 20),
                        child: Text("Мүүд",
                            style: TextStyle(
                                color: MyColors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold)),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                color: MyColors.gray,
                                borderRadius: BorderRadius.circular(4)),
                            // child: Image.network(
                            //   moodMain[0].banner ?? "",
                            //   errorBuilder: (context, error, stackTrace) =>
                            //       const Icon(
                            //     Icons.close,
                            //     color: Colors.white,
                            //   ),
                            // ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  moodMain[0].title?.capitalize() ?? "",
                                  style: const TextStyle(
                                      color: MyColors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                const SizedBox(height: 5),
                                CustomReadMoreText(text: moodMain[0].body ?? "")
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: moodList.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 15),
                        itemBuilder: (BuildContext context, int index) {
                          return MoodListItem(getMoodList: moodList[index]);
                        },
                      )
                    ],
                  ),
                );
              } else {
                return Container();
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(color: MyColors.primaryColor),
              );
            }
          }),
    );
  }

  Future<List<GetMoodList>> getMoodList() {
    return Connection.getMoodList(context, "1");
  }

  Future<List<MoodMain>> getMoodMain() {
    return Connection.getMoodMain(context);
  }
}
