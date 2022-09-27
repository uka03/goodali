import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/custom_readmore_text.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/models/podcast_list_model.dart';
import 'package:iconly/iconly.dart';
import 'package:percent_indicator/percent_indicator.dart';

class PodcastAll extends StatefulWidget {
  const PodcastAll({Key? key}) : super(key: key);

  @override
  State<PodcastAll> createState() => _PodcastAllState();
}

class _PodcastAllState extends State<PodcastAll> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getPodcastList(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            List<PodcastListModel> podcastList = snapshot.data;
            return ListView.separated(
              padding: const EdgeInsets.only(top: 13, bottom: 15),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: ImageView(
                                height: 40,
                                width: 40,
                                imgPath: podcastList[index].banner ?? ""),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  podcastList[index].title ?? "",
                                  maxLines: 1,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: MyColors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                CustomReadMoreText(
                                  text: podcastList[index].body ?? "",
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: MyColors.input,
                            child: IconButton(
                              splashRadius: 20,
                              padding: EdgeInsets.zero,
                              onPressed: () {},
                              icon: const Icon(
                                Icons.play_arrow_rounded,
                                size: 30,
                                color: MyColors.black,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text('1 цаг 25 мин',
                              style: TextStyle(
                                  fontSize: 12, color: MyColors.black)),
                          Spacer(),
                          IconButton(
                              splashRadius: 20,
                              onPressed: () {},
                              icon: Icon(IconlyLight.arrow_down,
                                  color: MyColors.gray)),
                          IconButton(
                              splashRadius: 20,
                              onPressed: () {},
                              icon:
                                  Icon(Icons.more_horiz, color: MyColors.gray)),
                        ],
                      ),
                      const SizedBox(height: 12)
                    ],
                  ),
                );
              },
              itemCount: podcastList.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                endIndent: 18,
                indent: 18,
              ),
            );
          } else {
            return const Center(
                child: CircularProgressIndicator(color: MyColors.primaryColor));
          }
        });
  }

  Future<List<PodcastListModel>> getPodcastList() {
    return Connection.getPodcastList(context);
  }
}
