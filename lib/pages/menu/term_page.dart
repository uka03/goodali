import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:goodali/shared/components/appbar_with_back.dart';
import 'package:goodali/shared/components/general_scaffold.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermPage extends StatefulWidget {
  const TermPage({super.key});

  static String routeName = "/term_page";

  @override
  State<TermPage> createState() => _TermPageState();
}

class _TermPageState extends State<TermPage> {
  late final WebViewController _controller;
  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Color.fromRGBO(0, 0, 0, 0));
    final uri = Uri.parse("https://visiontech.asia/goodali/goodali.html");

    _controller.loadRequest(uri);
  }

  @override
  Widget build(BuildContext context) {
    return GeneralScaffold(
      appBar: AppbarWithBackButton(
        title: "Үйлчилгээний нөхцөл",
      ),
      child: Container(
        margin: kIsWeb ? EdgeInsets.symmetric(horizontal: 155) : null,
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}
