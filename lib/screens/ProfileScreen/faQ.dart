import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/models/faq_model.dart';
import 'package:goodali/screens/HomeScreen/header_widget.dart';

class FrequentlyQuestions extends StatefulWidget {
  const FrequentlyQuestions({Key? key}) : super(key: key);

  @override
  State<FrequentlyQuestions> createState() => _FrequentlyQuestionsState();
}

class _FrequentlyQuestionsState extends State<FrequentlyQuestions> {
  late final Future faqFuture = getFaqList();
  List<FaqModel> list = [];

  Future<List<FaqModel>> getFaqList() {
    return Connection.faqList(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kIsWeb ? null : const SimpleAppBar(noCard: true, title: "Нийтлэг асуулт хариулт"),
      body: Column(
        children: [
          const Visibility(
            visible: kIsWeb,
            child: HeaderWidget(
              title: 'Нийтлэг асуулт хариулт',
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: faqFuture,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  list = snapshot.data;
                  return Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * (kIsWeb ? 0.4 : 1),
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Card(
                              elevation: 0,
                              child: Theme(
                                data: ThemeData().copyWith(dividerColor: Colors.transparent, unselectedWidgetColor: MyColors.primaryColor),
                                child: ExpansionTile(
                                  iconColor: MyColors.primaryColor,
                                  textColor: MyColors.black,
                                  expandedAlignment: Alignment.topLeft,
                                  collapsedTextColor: MyColors.black,
                                  tilePadding: const EdgeInsets.symmetric(horizontal: 10),
                                  childrenPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  title: HtmlWidget(list[index].question ?? "", textStyle: const TextStyle(fontSize: 16)),
                                  children: [HtmlWidget(list[index].answer ?? "")],
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: list.length,
                      ),
                    ),
                  );
                } else {
                  return const CircularProgressIndicator(color: MyColors.primaryColor);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
