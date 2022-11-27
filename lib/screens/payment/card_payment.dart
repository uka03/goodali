import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:goodali/Providers/cart_provider.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/Widgets/top_snack_bar.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CardPayment extends StatefulWidget {
  final String url;
  const CardPayment({Key? key, required this.url}) : super(key: key);

  @override
  State<CardPayment> createState() => _CardPaymentState();
}

class _CardPaymentState extends State<CardPayment> {
  final Completer<WebViewController> _completer =
      Completer<WebViewController>();
  WebViewController? _webViewController;

  final _key = UniqueKey();
  String _url = "";

  @override
  void initState() {
    _url = widget.url;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final card = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: const SimpleAppBar(noCard: true),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: WebView(
          key: _key,
          initialUrl: _url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewControlle) {
            _completer.complete(webViewControlle);
            _webViewController = webViewControlle;
          },
          gestureNavigationEnabled: true,
          onPageFinished: (String value) {
            card.removeAllProducts();

            if (value.contains("status_code=000")) {
              TopSnackBar.successFactory().show(context).then((value) {
                Navigator.pop(context);
                Navigator.pop(context);
              });
            }
          },
          onWebResourceError: (onWebResourceError) {
            TopSnackBar.errorFactory(
                    title: "Алдаа гарлаа", msg: "Дахин оролдоно уу.")
                .show(context);
          },
          onProgress: (int progress) {
            print('Webview is loading $progress');
          },
        ),
      ),
    );
  }

  void readResponse(context) async {
    final response = await _webViewController
        ?.runJavascriptReturningResult("document.documentElement.innerText");

    Map<String, dynamic> data =
        Map<String, dynamic>.from(json.decode(response ?? ""));

    String message = data["message"];

    if (message.contains("ok")) {
      Navigator.pop(context);
    } else {}
  }
}
