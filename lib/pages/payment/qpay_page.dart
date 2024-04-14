import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:goodali/pages/cart/provider/cart_provider.dart';
import 'package:goodali/pages/home/provider/home_provider.dart';
import 'package:goodali/pages/payment/components/payment_item.dart';
import 'package:goodali/shared/components/appbar_with_back.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/constants.dart';
import 'package:goodali/utils/globals.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/toasts.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

class QpayPage extends StatefulWidget {
  const QpayPage({super.key});

  static String routeName = "/qpay_page";

  @override
  State<QpayPage> createState() => _QpayPageState();
}

class _QpayPageState extends State<QpayPage> {
  late CartProvider cartProvider;
  late HomeProvider homeProvider;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    cartProvider = Provider.of<CartProvider>(context, listen: false);
    homeProvider = Provider.of<HomeProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final response = await cartProvider.createOrder(invoiceType: 0);
      timer?.cancel();
      timer = Timer.periodic(Duration(seconds: 5), (timer) async {
        if (response.goodaliOrderId?.isNotEmpty == true) {
          final checkRes = await cartProvider.checkOrder(response.goodaliOrderId);
          if (checkRes && mounted) {
            timer.cancel();
            cartProvider.removeProductAll();
            Toast.success(context, description: "Худалдан авалт амжилттай.");
            homeProvider.getHomeData(isAuth: true);
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        }
      });
    });
  }

  openBankApp(String url) async {
    showLoader();
    final bool canLaunchApp = await launchUrlString(url);
    if (canLaunchApp) {
      await launchUrlString(url);
    } else {
      if (mounted) {
        Toast.error(context, description: "Тухайн банкны аппликейшн олдсонгүй.");
      }
    }
    dismissLoader();
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, provider, _) {
      final urls = provider.paymentDetail.urls;
      return Scaffold(
        backgroundColor: GoodaliColors.primaryBGColor,
        appBar: AppbarWithBackButton(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: kIsWeb ? EdgeInsets.symmetric(horizontal: 155) : null,
              child: Column(
                children: [
                  Text(
                    "Банк сонгох",
                    style: GoodaliTextStyles.titleText(
                      context,
                      fontSize: 24,
                    ),
                  ),
                  VSpacer(),
                  kIsWeb
                      ? QrImageView(
                          data: provider.paymentDetail.qrText ?? '',
                          size: 200,
                        )
                      : SizedBox(),
                  ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.all(16),
                    itemCount: urls?.length ?? 0,
                    separatorBuilder: (context, index) => VSpacer(),
                    itemBuilder: (context, index) {
                      final url = urls?[index];
                      return PaymentItem(
                        onPressed: () {
                          openBankApp(url?.link ?? "");
                        },
                        logoPath: url?.logo ?? placeholder,
                        logoOnline: true,
                        text: url?.name ?? "",
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
