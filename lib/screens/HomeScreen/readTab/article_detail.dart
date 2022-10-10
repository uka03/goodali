import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/models/article_model.dart';
import 'package:goodali/screens/ListItems/article_item.dart';
import 'package:goodali/screens/blank.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ArticleDetail extends StatefulWidget {
  final ArticleModel articleItem;
  const ArticleDetail({Key? key, required this.articleItem}) : super(key: key);

  @override
  State<ArticleDetail> createState() => _ArticleDetailState();
}

class _ArticleDetailState extends State<ArticleDetail> {
  final ScrollController _scrollController = ScrollController();
  double scrollPercent = 0;
  double maxScrollExtent = 1;
  List<ArticleModel> similarArticle = [];

  @override
  void initState() {
    _scrollController.addListener(() {
      setState(() {
        scrollPercent = _scrollController.offset;
        maxScrollExtent = _scrollController.position.maxScrollExtent;
      });
    });
    getSimilarPost();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(title: ""),
      body: Stack(children: [
        SingleChildScrollView(
          controller: _scrollController,
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageView(
                imgPath: widget.articleItem.banner ?? "",
                height: 200,
                width: double.infinity,
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 300,
                  child: Text(widget.articleItem.title ?? "",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: MyColors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          height: 1.7)),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: HtmlWidget(widget.articleItem.body ?? "",
                    textStyle: const TextStyle(
                        fontSize: 14, height: 1.8, color: MyColors.black)),
              ),
              const SizedBox(height: 40),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text("Төстэй бичвэрүүд",
                    style: TextStyle(
                        color: MyColors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        height: 1.7)),
              ),
              const SizedBox(height: 30),
              _similarArticle()
            ],
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          left: 0,
          child: SfLinearGauge(
            maximum: maxScrollExtent,
            axisTrackStyle: const LinearAxisTrackStyle(thickness: 2.5),
            showLabels: false,
            showTicks: false,
            barPointers: [
              LinearBarPointer(
                  thickness: 2.5,
                  color: MyColors.primaryColor,
                  value: scrollPercent)
            ],
          ),
        ),
      ]),
    );
  }

  Widget _similarArticle() {
    return FutureBuilder(
      future: getSimilarPost(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          similarArticle = snapshot.data;
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: similarArticle.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(20.0),
              child: ArtcileItem(
                articleModel: similarArticle[index],
              ),
            ),
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(
                    color: MyColors.border1, endIndent: 20, indent: 20),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: MyColors.secondary,
            ),
          );
        }
      },
    );
  }

  Future<List<ArticleModel>> getSimilarPost() {
    Map sendData = {"post_id": widget.articleItem.id};
    return Connection.getSimilarPost(context, sendData);
  }
}
