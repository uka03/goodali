import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ArticleDetail extends StatefulWidget {
  const ArticleDetail({Key? key}) : super(key: key);

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
              const Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 300,
                  child: const Text("Агуу анагаагчид болон асар зовогсод",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: MyColors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          height: 1.7)),
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                    "Чи хаашаа ч зорьсон бай, хамаагүй, яг одоо байгаа цэгээсээ л эхэлнэ. Алив зүйлийг эхлэхдээ будилах, ялимгүй аргалчих гэсэн эрмэлзлээсээ болоод төлөх гэсэн биш даялаад явчихвал хүссэн үр дүнгээ хүссэн хугацаандаа авахгүй байх, их үнээр авах болчихдог учраас би аль болох үнэн байхыг хичээдэг. “Харамч хүн хоёр төлдөг. Яаруу хүн хоцордог.” гэсэн үгийг санаж явдаг даа. Өмнөх сургалтуудын үеэр эхний удиртгал бүлгүүдийг алгасаад шууд үндсэн бүлэг рүүгээ орсон ээжүүд тэнд  ямар асуултууд гарч болох вэ? Таны бүртгэлтэй и-мэйл хаягааг хүргэгдсэн хөтөч дэвтэрийнхэ холбоос дээр дарж дэлгэрэнгүй танилцаарай.",
                    style: TextStyle(
                        fontSize: 14, height: 1.8, color: MyColors.black)),
              ),
              const SizedBox(height: 40),
              Align(
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 170,
                    width: 170,
                    color: Colors.pink[200],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                    "Алив зүйлийг эхлэхдээ будилах, ялимгүй аргалчих гэсэн эрмэлзлээсээ болоод төлөх гэсэн биш даялаад явчихвал хүссэн үр дүнгээ хүссэн хугацаандаа авахгүй байх, их үнээр авах болчихдог учраас би аль болох үнэн байхыг хичээдэг. “Харамч хүн хоёр төлдөг. Яаруу хүн хоцордог.” гэсэн үгийг санаж явдаг даа. Өмнөх сургалтуудын үеэр эхний удиртгал бүлгүүдийг алгасаад шууд үндсэн бүлэг рүүгээ орсон ээжүүд тэнд  ямар асуултууд гарч болох вэ?.",
                    style: TextStyle(
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
              similarArticle()
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
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ArticleDetail())),
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
