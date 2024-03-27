import 'package:flutter/material.dart';
import 'package:goodali/pages/payment/card_page.dart';
import 'package:goodali/pages/payment/components/payment_item.dart';
import 'package:goodali/pages/payment/qpay_page.dart';
import 'package:goodali/shared/components/appbar_with_back.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  static String routeName = "/payment_page";

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWithBackButton(),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Төлөх хэлбэр сонгох",
              style: GoodaliTextStyles.titleText(
                context,
                fontSize: 24,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  PaymentItem(
                    onPressed: () {
                      Navigator.pushNamed(context, QpayPage.routeName);
                    },
                    logoPath: "assets/icons/ic_scan.png",
                    text: 'Qpay',
                  ),
                  VSpacer(),
                  PaymentItem(
                    onPressed: () {
                      Navigator.pushNamed(context, CardPage.routeName);
                    },
                    logoPath: "assets/icons/ic_visa.png",
                    text: 'Карт',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
