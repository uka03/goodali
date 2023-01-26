import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/simple_appbar.dart';

class AudioDescription extends StatelessWidget {
  final String description;
  const AudioDescription({Key? key, required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(noCard: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text("Тайлбар",
                  style: TextStyle(
                      fontSize: 24,
                      color: MyColors.black,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              HtmlWidget(description,
                  textStyle: const TextStyle(color: MyColors.gray)),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
