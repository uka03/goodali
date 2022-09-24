import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/screens/HomeScreen/listenTab/video_detail.dart';
import 'package:iconly/iconly.dart';

class VideoList extends StatefulWidget {
  const VideoList({Key? key}) : super(key: key);

  @override
  State<VideoList> createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        physics: const NeverScrollableScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              floating: true,
              // snap: true,

              elevation: 0,
              iconTheme: const IconThemeData(color: MyColors.black),
              backgroundColor: Colors.white,
              bottom: PreferredSize(
                  preferredSize:
                      const Size(double.infinity, kToolbarHeight - 10),
                  child: Container(
                    padding: const EdgeInsets.only(left: 20),
                    alignment: Alignment.topLeft,
                    child: const Text("Видео",
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: MyColors.black)),
                  )),
            )
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            children: [
              videoListView(),
            ],
          ),
        ),
      ),
      floatingActionButton: floatActionButtons(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget videoListView() {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 8,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const VideoDetail())),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 188,
                  color: Colors.blueGrey,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Chi ymr tsaraitai we",
                        style: TextStyle(color: MyColors.black, fontSize: 16),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "2022.04.11",
                        style: TextStyle(fontSize: 12, color: MyColors.gray),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget floatActionButtons() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        radius: 26,
        backgroundColor: MyColors.primaryColor,
        child: IconButton(
          splashRadius: 10,
          onPressed: () {},
          icon: const Icon(IconlyLight.filter, color: Colors.white),
        ),
      ),
    );
  }
}
