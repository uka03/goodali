import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:goodali/Utils/circle_tab_indicator.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/my_delegate.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/Widgets/top_snack_bar.dart';
import 'package:goodali/controller/download_controller.dart';
import 'package:goodali/controller/download_state.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/HomeScreen/listenTab/podcast_tabs/downloaded_podcast.dart';
import 'package:goodali/screens/HomeScreen/listenTab/podcast_tabs/listened_podcast.dart';
import 'package:goodali/screens/HomeScreen/listenTab/podcast_tabs/unlistened_podcast.dart';
import 'package:goodali/screens/HomeScreen/listenTab/podcast_tabs/podcast_all_tab.dart';
import 'package:hive_flutter/adapters.dart';

import '../../../Providers/local_database.dart';

class Podcast extends StatefulWidget {
  final int? id;
  final HiveDataStore dataStore;
  const Podcast({Key? key, this.id, required this.dataStore}) : super(key: key);

  @override
  State<Podcast> createState() => _PodcastState();
}

class _PodcastState extends State<Podcast> {
  final HiveDataStore dataStore = HiveDataStore();
  final ReceivePort _port = ReceivePort();
  DownloadTaskStatus? downloadTaskStatus;
  int downloadProgress = 0;

  @override
  void initState() {
    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback, step: 1);
    super.initState();
  }

  void _bindBackgroundIsolate() {
    final isSuccess = IsolateNameServer.registerPortWithName(
      _port.sendPort,
      'downloader_send_port',
    );
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) async {
      var status = data[1] as DownloadTaskStatus;
      var progress = data[2] as int;
      setState(() {
        downloadProgress = progress;
        downloadTaskStatus = status;
      });
      downloadTaskIDNotifier.value = (data as List<dynamic>)[0] as String;

      if (status == DownloadTaskStatus.undefined) {
        downloadStatusNotifier.value = DownloadState.undefined;
      } else if (status == DownloadTaskStatus.complete) {
        downloadStatusNotifier.value = DownloadState.undefined;
      } else if (status == DownloadTaskStatus.enqueued) {
        downloadStatusNotifier.value = DownloadState.enqueued;
      } else if (status == DownloadTaskStatus.running) {
        downloadStatusNotifier.value = DownloadState.running;
      } else if (status == DownloadTaskStatus.failed) {
        TopSnackBar.errorFactory(
                title: "Алдаа гарлаа", msg: "Дахин оролдоно уу")
            .show(context);
      }
      downloadProgressNotifier.value = downloadProgress;
      print("downloadProgressNotifier.value${downloadProgressNotifier.value}");
    });
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
    String id,
    DownloadTaskStatus status,
    int progress,
  ) {
    print(
      'Callback on background isolate: '
      'task ($id) is in status ($status) and process ($progress)',
    );

    IsolateNameServer.lookupPortByName('downloader_send_port')
        ?.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(noCard: true),
      body: DefaultTabController(
          length: 4,
          child: NestedScrollView(
              physics: const NeverScrollableScrollPhysics(),
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child: SizedBox(
                        height: 56,
                        child: Container(
                          padding: const EdgeInsets.only(left: 20),
                          alignment: Alignment.topLeft,
                          child: const Text("Подкаст",
                              style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: MyColors.black)),
                        )),
                  ),
                  SliverPersistentHeader(
                      floating: false,
                      pinned: true,
                      delegate: MyDelegate(const TabBar(
                        isScrollable: true,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        tabs: [
                          SizedBox(width: 78, child: Tab(text: "Бүгд")),
                          SizedBox(width: 78, child: Tab(text: "Сонсоогүй")),
                          SizedBox(width: 78, child: Tab(text: "Татсан")),
                          SizedBox(width: 78, child: Tab(text: "Сонссон"))
                        ],
                        indicatorWeight: 4,
                        indicator:
                            CustomTabIndicator(color: MyColors.primaryColor),
                        labelColor: MyColors.primaryColor,
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold, fontFamily: 'Gilroy'),
                        unselectedLabelStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Gilroy'),
                        unselectedLabelColor: MyColors.gray,
                        indicatorColor: MyColors.primaryColor,
                      )))
                ];
              },
              body: ValueListenableBuilder(
                valueListenable: HiveDataStore.box.listenable(),
                builder: (context, Box box, widget) {
                  if (box.length > 0) {
                    List<Products> data = [];
                    for (int a = 0; a < box.length; a++) {
                      data.add(box.getAt(a));
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: TabBarView(children: [
                        PodcastAll(
                          podcastList: data,
                        ),
                        NotListenedPodcast(
                          dataStore: dataStore,
                        ),
                        const DownloadedPodcast(),
                        ListenedPodcast(
                          dataStore: dataStore,
                        )
                      ]),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(
                          color: MyColors.primaryColor),
                    );
                  }
                },
              ))),
    );
  }
}
