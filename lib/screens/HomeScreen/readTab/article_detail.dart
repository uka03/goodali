import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/models/article_model.dart';
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

  @override
  void initState() {
    _scrollController.addListener(() {
      setState(() {
        scrollPercent = _scrollController.offset;
        maxScrollExtent = _scrollController.position.maxScrollExtent;
      });
    });
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
              Container(
                height: 200,
                color: Colors.yellowAccent,
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
                child: Text(widget.articleItem.body ?? "",
                    style: const TextStyle(
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
              // similarArticle()
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

  similarArticle() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: GestureDetector(
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Blank())),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                    color: MyColors.secondary,
                    borderRadius: BorderRadius.circular(12)),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Ineegerei, busgui min",
                          style: TextStyle(
                            fontSize: 16,
                            color: MyColors.black,
                          )),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("4 min unshih",
                              style: TextStyle(
                                fontSize: 12,
                                color: MyColors.primaryColor,
                              )),
                          SizedBox(width: 5),
                          Icon(Icons.circle,
                              color: MyColors.primaryColor, size: 4),
                          SizedBox(width: 5),
                          Text("2022.03.18",
                              style: TextStyle(
                                fontSize: 12,
                                color: MyColors.primaryColor,
                              ))
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Jaalkhuu bytshan ohind hairtai baijee. Jaalkhuu bytshan ohind hairtai baijee.  Ter ohinii tsangisan ineed huugiin buh",
                        style: TextStyle(
                            fontSize: 12, color: MyColors.gray, height: 1.5),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      separatorBuilder: (BuildContext context, int index) =>
          const Divider(color: MyColors.border1, endIndent: 20, indent: 20),
    );
  }
}
