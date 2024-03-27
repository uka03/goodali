import 'package:flutter/material.dart';
import 'package:goodali/pages/cart/provider/cart_provider.dart';
import 'package:goodali/shared/components/appbar_with_back.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CardPage extends StatefulWidget {
  const CardPage({super.key});

  static String routeName = "/card_page";

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  late final WebViewController _controller;

  late CartProvider cartProvider;

  @override
  void initState() {
    super.initState();

    cartProvider = Provider.of<CartProvider>(context, listen: false);

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final response = await cartProvider.createOrder(invoiceType: 1);
      final uriUrl = Uri.parse(response.url ?? "");
      _controller.loadRequest(uriUrl);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWithBackButton(),
      body: WebViewWidget(
        controller: _controller,
      ),
    );
  }
}
