import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TOCScreen extends StatelessWidget {
  const TOCScreen({super.key});

  // late WebViewController _webViewController;
  // final String _url = "https://www.goodali.mn/privacy-policy/";
  final String _url = "https://visiontech.asia/goodali/goodali.html";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(
        noCard: true,
        title: 'Үилчилгээний нөхцөл',
      ),
      body: WebView(
        initialUrl: _url,
        javascriptMode: JavascriptMode.unrestricted,
        // onWebViewCreated: (WebViewController webViewController) {
        //   // _completer.complete(webViewControlle);
        //   _webViewController = webViewController;
        // },
        gestureNavigationEnabled: true,
        // onPageFinished: (String value) {
        //   _webViewController.runJavascript('document.getElementById("masthead").remove()');
        //   _webViewController.runJavascript('document.getElementById("colophon").remove()');
        //   _webViewController.runJavascript('document.getElementsByClassName("entry-header")[0].remove();');
        // },
        // onWebResourceError: (onWebResourceError) {
        //   //   TopSnackBar.errorFactory(title: "Алдаа гарлаа", msg: "Дахин оролдоно уу.").show(context);
        // },
        onProgress: (int progress) {
          print('Webview is loading $progress');
        },
      ),
    );
  }
}
