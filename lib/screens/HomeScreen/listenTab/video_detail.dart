import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/models/video_model.dart';

class VideoDetail extends StatefulWidget {
  const VideoDetail({Key? key}) : super(key: key);

  @override
  State<VideoDetail> createState() => _VideoDetailState();
}

class _VideoDetailState extends State<VideoDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(),
      body: SingleChildScrollView(
          child: FutureBuilder(
        future: getVideoList(),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              ConnectionState.done == snapshot.connectionState) {
            List<VideoModel> videoList = [];
            if (videoList.isNotEmpty) {
              return Column(
                children: [
                  Container(
                    height: 190,
                    width: double.infinity,
                    color: Colors.blueGrey,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      "Chi ymar tsaraitai we",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: MyColors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "Алив зүйлийг эхлэхдээ будилах, ялимгүй аргалчих гэсэн эрмэлзлээсээ болоод төлөх гэсэн биш даялаад явчихвал хүссэн үр дүнгээ хүссэн хугацаандаа авахгүй байх, их үнээр авах болчихдог учраас би аль болох үнэн байхыг хичээдэг. ",
                      textAlign: TextAlign.center,
                      style: TextStyle(height: 1.7, color: MyColors.black),
                    ),
                  )
                ],
              );
            } else {
              return Container();
            }
          } else {
            return const Center(
                child: CircularProgressIndicator(
              color: MyColors.primaryColor,
            ));
          }
        },
      )),
    );
  }

  Future<List<VideoModel>> getVideoList() {
    return Connection.getVideoList(context);
  }
}
