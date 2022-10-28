import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/custom_elevated_button.dart';
import 'package:goodali/Widgets/filter_button.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/models/tag_model.dart';
import 'package:goodali/models/video_model.dart';
import 'package:goodali/screens/HomeScreen/listenTab/video_detail.dart';
import 'package:goodali/screens/HomeScreen/readTab/article_screen.dart';
import 'package:iconly/iconly.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoList extends StatefulWidget {
  const VideoList({Key? key}) : super(key: key);

  @override
  State<VideoList> createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  late final tagFuture = getTagList();
  List<int> checkedTag = [];
  YoutubePlayerController? _ytbPlayerController;

  @override
  void initState() {
    _setOrientation([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

  _setOrientation(List<DeviceOrientation> orientations) {
    SystemChrome.setPreferredOrientations(orientations);
  }

  @override
  void dispose() {
    _ytbPlayerController?.close();
    super.dispose();
  }

  @override
  void deactivate() {
    _ytbPlayerController?.pause();
    super.deactivate();
  }

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
          child: FutureBuilder(
            future: getVideoList(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                List<VideoModel> videoList = snapshot.data;

                if (videoList.isNotEmpty) {
                  return Column(
                    children: [
                      videoListView(videoList),
                    ],
                  );
                } else {
                  return Container();
                }
              } else {
                return const Center(
                  child:
                      CircularProgressIndicator(color: MyColors.primaryColor),
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: FilterButton(onPress: () {
        showModalTag(context, tagFuture, checkedTag);
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  initiliazeVideo(videoUrl) {
    _ytbPlayerController = YoutubePlayerController(
      initialVideoId: videoUrl,
      params: const YoutubePlayerParams(
        showControls: true,
        origin: "https://www.youtube.com/embed/",
        startAt: Duration(seconds: 0),
        autoPlay: true,
      ),
    );
    // _controller?.addListener(listener);
  }

  Widget videoListView(List<VideoModel> videoList) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: videoList.length,
        itemBuilder: (context, index) {
          initiliazeVideo(videoList[index].videoUrl);
          return GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => VideoDetail(videoModel: videoList[index]))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ytbPlayerController?.value.isReady != null
                    ? YoutubePlayerControllerProvider(
                        controller: _ytbPlayerController ??
                            YoutubePlayerController(
                                initialVideoId:
                                    videoList[index].videoUrl ?? ""),
                        child: const YoutubePlayerIFrame(
                          aspectRatio: 16 / 9,
                        ),
                      )
                    : const CircularProgressIndicator(
                        color: MyColors.primaryColor),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        videoList[index].title ?? "",
                        style: const TextStyle(
                            color: MyColors.black, fontSize: 16),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<List<TagModel>> getTagList() async {
    return await Connection.getTagList(context);
  }

  Future<List<VideoModel>> getVideoList() {
    return Connection.getVideoList(context);
  }

  showModalTag(BuildContext context, Future tagFuture, List<int> checkedTag) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        builder: (_) => SizedBox(
              height: MediaQuery.of(context).size.height - 100,
              child: StatefulBuilder(
                builder: (BuildContext context,
                    void Function(void Function()) setState) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 38,
                          height: 6,
                          decoration: BoxDecoration(
                              color: MyColors.gray,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        const SizedBox(height: 20),
                        const Text("Шүүлтүүр",
                            style: TextStyle(
                                fontSize: 22,
                                color: MyColors.black,
                                fontWeight: FontWeight.bold)),
                        Expanded(
                          child: FutureBuilder(
                            future: tagFuture,
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData &&
                                  ConnectionState.done ==
                                      snapshot.connectionState) {
                                List<TagModel> tagList = snapshot.data;
                                return ListView.builder(
                                    itemCount: tagList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return CheckboxListTile(
                                          title:
                                              Text(tagList[index].name ?? ""),
                                          activeColor: MyColors.primaryColor,
                                          onChanged: (bool? value) {
                                            if (value == true) {
                                              setState(() {
                                                checkedTag.add(
                                                    tagList[index].id ?? 0);
                                              });
                                            } else {
                                              setState(() {
                                                checkedTag
                                                    .remove(tagList[index].id);
                                              });
                                            }
                                          },
                                          value: checkedTag
                                              .contains(tagList[index].id));
                                    });
                              } else {
                                return const Center(
                                    child: CircularProgressIndicator(
                                        color: MyColors.primaryColor,
                                        strokeWidth: 2));
                              }
                            },
                          ),
                        ),
                        CustomElevatedButton(
                            text: "Шүүх",
                            onPress: () {
                              Navigator.pop(context, checkedTag);
                            }),
                        const SizedBox(height: 20),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              ),
            ));
  }
}
