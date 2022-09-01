import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
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
    return ListView.separated(
      padding: const EdgeInsets.only(top: 13, bottom: 15),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(6)),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "#25 Гоо Даль-ийн дэвэлтээрjnjnjnj",
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: MyColors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Энэ хэсэгт аудио подкастын тайлбар байна. Аудиог огт тоглуулаагүй, эхлүүлээгүй байвал ингэж харагдана, текст багтахгүй хэтэрсэн бол...",
                          style: TextStyle(
                            color: MyColors.gray,
                            fontSize: 12,
                          ),
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
                      style: TextStyle(fontSize: 12, color: MyColors.black)),
                  Spacer(),
                  IconButton(
                      splashRadius: 20,
                      onPressed: () {},
                      icon: Icon(IconlyLight.arrow_down, color: MyColors.gray)),
                  IconButton(
                      splashRadius: 20,
                      onPressed: () {},
                      icon: Icon(Icons.more_horiz, color: MyColors.gray)),
                ],
              )
            ],
          ),
        );
      },
      itemCount: 5,
      separatorBuilder: (BuildContext context, int index) => const Divider(
        endIndent: 18,
        indent: 18,
      ),
    );
  }
}
  // LinearPercentIndicator(
                  //   width: 80.0,
                  //   lineHeight: 4.0,
                  //   percent: 0.5,
                  //   backgroundColor: MyColors.input,
                  //   progressColor: MyColors.primaryColor,
                  // ),