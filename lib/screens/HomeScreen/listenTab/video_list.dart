import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/custom_elevated_button.dart';
import 'package:goodali/Widgets/filter_button.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/models/tag_model.dart';
import 'package:goodali/models/video_model.dart';
import 'package:goodali/screens/HomeScreen/header_widget.dart';
import 'package:goodali/screens/ListItems/video_item.dart';
import 'package:iconly/iconly.dart';

class VideoList extends StatefulWidget {
  final bool isHomeScreen;

  const VideoList({Key? key, this.isHomeScreen = false}) : super(key: key);

  @override
  State<VideoList> createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  bool isLoading = true;
  List<TagModel> tagList = [];
  List<int> checkedTag = [];
  List<VideoModel> videoList = [];
  List<VideoModel> filteredList = [];

  @override
  void initState() {
    getTagList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Visibility(
            visible: kIsWeb,
            child: HeaderWidget(
              title: 'Видео',
            ),
          ),
          Expanded(
            child: NestedScrollView(
              physics: const NeverScrollableScrollPhysics(),
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    pinned: true,
                    floating: true,
                    automaticallyImplyLeading: kIsWeb ? false : true,
                    elevation: 0,
                    iconTheme: const IconThemeData(color: MyColors.black),
                    backgroundColor: Colors.white,
                    bottom: PreferredSize(
                        preferredSize: const Size(double.infinity, kToolbarHeight - 10),
                        child: Container(
                          padding: const EdgeInsets.only(left: kIsWeb ? 255 : 20),
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: [
                              const Text("Видео",
                                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: MyColors.black)),
                              const Spacer(),
                              kIsWeb
                                  ? Container(
                                      margin: const EdgeInsets.only(right: 255),
                                      child: TextButton.icon(
                                        onPressed: () {
                                          showWebModalTag(context, checkedTag);
                                        },
                                        icon: const Icon(
                                          IconlyLight.filter,
                                          size: 24.0,
                                          color: Color(0xff393837),
                                        ),
                                        label: const Text(
                                          'Шүүлтүүр',
                                          style: TextStyle(color: Color(0xff393837)),
                                        ),
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                        )),
                  )
                ];
              },
              body: SingleChildScrollView(
                child: FutureBuilder(
                  future: getVideoList(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                      videoList = snapshot.data;

                      if (videoList.isNotEmpty) {
                        return Column(
                          children: [
                            const SizedBox(
                              height: kIsWeb ? 60 : 0,
                            ),
                            videoListView(filteredList.isNotEmpty ? filteredList : videoList),
                          ],
                        );
                      } else {
                        return Container();
                      }
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(color: MyColors.primaryColor),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: kIsWeb
          ? null
          : FilterButton(onPress: () {
              showModalTag(context, checkedTag);
            }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget videoListView(List<VideoModel> videoList) {
    if (kIsWeb) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 255),
        child: GridView.builder(
            // padding: const EdgeInsets.symmetric(horizontal: 20),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: (widget.isHomeScreen && videoList.length > 3) ? 3 : videoList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 15,
              childAspectRatio: 1,
              crossAxisCount: 3,
            ),
            itemBuilder: (BuildContext context, int index) => VideoItem(
                  videoModel: videoList[index],
                )),
      );
    } else {
      return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: videoList.length,
          itemBuilder: (context, index) {
            return VideoItem(
              videoModel: videoList[index],
              isHomeScreen: false,
            );
          });
    }
  }

  Future<void> getTagList() async {
    tagList = await Connection.getTagList(context);
    setState(() {
      isLoading = false;
    });
  }

  Future<List<VideoModel>> getVideoList() {
    return Connection.getVideoList(context);
  }

  showWebModalTag(BuildContext context, List<int> checkedTag) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent, // Change this to transparent
        isScrollControlled: true,
        isDismissible: true,
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
        builder: (_) => StatefulBuilder(
              builder: (BuildContext context, void Function(void Function()) setState) {
                return Column(
                  children: [
                    const Spacer(),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 4,
                        color: Colors.white,
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                            ),
                            const SizedBox(height: 20),
                            const Text("Шүүлтүүр",
                                style: TextStyle(fontSize: 22, color: MyColors.black, fontWeight: FontWeight.bold)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Wrap(
                                  children: tagList
                                      .map(
                                        (e) => InkWell(
                                          onTap: () {
                                            setState(() {
                                              if (!checkedTag.contains(e.id)) {
                                                checkedTag.add(e.id!);
                                              } else {
                                                checkedTag.remove(e.id);
                                              }
                                            });
                                          },
                                          child: SizedBox(
                                            height: 45,
                                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                              Text(e.name ?? "", style: const TextStyle(color: MyColors.black)),
                                              const SizedBox(width: 15),
                                              SizedBox(
                                                height: 24,
                                                width: 24,
                                                child: IgnorePointer(
                                                  child: Checkbox(
                                                      fillColor:
                                                          MaterialStateProperty.all<Color>(MyColors.primaryColor),
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(4)),
                                                      side: const BorderSide(color: MyColors.border1),
                                                      splashRadius: 5,
                                                      onChanged: (_) {},
                                                      value: checkedTag.contains(e.id)),
                                                ),
                                              ),
                                            ]),
                                          ),
                                        ),
                                      )
                                      .toList()),
                            ),
                            const SizedBox(height: 10),
                            CustomElevatedButton(
                                text: "Шүүх",
                                onPress: () {
                                  filterPost();
                                  Navigator.pop(context, checkedTag);
                                }),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                );
              },
            ));
  }

  showModalTag(BuildContext context, List<int> checkedTag) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        builder: (_) => StatefulBuilder(
              builder: (BuildContext context, void Function(void Function()) setState) {
                return Container(
                  width: kIsWeb ? MediaQuery.of(context).size.width / 2 : MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 38,
                        height: 6,
                        decoration: BoxDecoration(color: MyColors.gray, borderRadius: BorderRadius.circular(10)),
                      ),
                      const SizedBox(height: 20),
                      const Text("Шүүлтүүр",
                          style: TextStyle(fontSize: 22, color: MyColors.black, fontWeight: FontWeight.bold)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Wrap(
                            children: tagList
                                .map(
                                  (e) => InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (!checkedTag.contains(e.id)) {
                                          checkedTag.add(e.id!);
                                        } else {
                                          checkedTag.remove(e.id);
                                        }
                                      });
                                    },
                                    child: SizedBox(
                                      height: 45,
                                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                        Text(e.name ?? "", style: const TextStyle(color: MyColors.black)),
                                        const SizedBox(width: 15),
                                        SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: IgnorePointer(
                                            child: Checkbox(
                                                fillColor: MaterialStateProperty.all<Color>(MyColors.primaryColor),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                                side: const BorderSide(color: MyColors.border1),
                                                splashRadius: 5,
                                                onChanged: (_) {},
                                                value: checkedTag.contains(e.id)),
                                          ),
                                        ),
                                      ]),
                                    ),
                                  ),
                                )
                                .toList()),
                      ),
                      const SizedBox(height: 10),
                      CustomElevatedButton(
                          text: "Шүүх",
                          onPress: () {
                            filterPost();
                            Navigator.pop(context, checkedTag);
                          }),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ));
  }

  filterPost() {
    setState(() {
      for (var item in videoList) {
        for (var id in checkedTag) {
          if (item.tags!.isNotEmpty) {
            if (item.tags?.first.id == id && !filteredList.any((element) => element.id == item.id)) {
              filteredList.add(item);
            }
          }
        }
      }
      // print(filteredList.length);
      if (checkedTag.isEmpty) {
        filteredList.clear();
      }
    });
  }
}
