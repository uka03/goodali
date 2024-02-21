import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Utils/utils.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/Widgets/top_snack_bar.dart';
import 'package:goodali/models/qpay.dart';
import 'package:goodali/screens/payment/card_payment.dart';
import 'package:goodali/screens/payment/qpay_payment.dart';
import 'package:iconly/iconly.dart';

import 'dart:js' as js;

class ChoosePayment extends StatefulWidget {
  final List<int> productIDs;
  const ChoosePayment({Key? key, required this.productIDs}) : super(key: key);

  @override
  State<ChoosePayment> createState() => _ChoosePaymentState();
}

class _ChoosePaymentState extends State<ChoosePayment> {
  List<QpayURLS> urls = [];

  late Timer myTimer;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(noCard: true),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: kIsWeb ? MediaQuery.of(context).size.width / 4 : 0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text("Төлөх хэлбэр сонгох",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: MyColors.black)),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Utils.showLoaderDialog(context);
                  createOrderRequest(context, 0);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 64,
                  width: double.infinity,
                  decoration: BoxDecoration(color: MyColors.input, borderRadius: BorderRadius.circular(12)),
                  child: const Row(
                    children: [
                      SizedBox(width: 20),
                      Icon(
                        IconlyLight.scan,
                        color: MyColors.primaryColor,
                      ),
                      SizedBox(width: 20),
                      Text("QPay", style: TextStyle(fontSize: 16, color: MyColors.black)),
                      Spacer(),
                      Icon(IconlyLight.arrow_right_2, color: MyColors.gray, size: 20),
                      SizedBox(width: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Utils.showLoaderDialog(context);
                  createOrderRequest(context, 1);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 64,
                  width: double.infinity,
                  decoration: BoxDecoration(color: MyColors.input, borderRadius: BorderRadius.circular(12)),
                  child: const Row(
                    children: [
                      SizedBox(width: 20),
                      Icon(
                        IconlyLight.wallet,
                        color: MyColors.primaryColor,
                      ),
                      SizedBox(width: 20),
                      Text("Карт", style: TextStyle(fontSize: 16, color: MyColors.black)),
                      Spacer(),
                      Icon(IconlyLight.arrow_right_2, color: MyColors.gray, size: 20),
                      SizedBox(width: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  void _invoiceChecker(String invoiceNumber) async {
    log("INVOICE CHECKING");
    print(DateTime.now().toIso8601String());

    bool result = await Connection.getInvoiceStatus(context, invoiceNumber);

    log(result.toString(), name: "INVOICE DETAIL");

    if (result == true) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      myTimer.cancel();

      TopSnackBar.successFactory(msg: "Худалдан авалт амжилттай хийгдлээ.").show(context);
    }
  }

  createOrderRequest(BuildContext context, int invoiceType) async {
    var data = await Connection.createOrderRequest(
      context,
      invoiceType,
      widget.productIDs,
    );

    log(data.toString());

    Navigator.pop(context);
    if (data['success'] == true) {
      log('SUCCESS');
      myTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
        _invoiceChecker(data['goodali_order_id']);
      });

      if (invoiceType == 0) {
        // log(data['qr_image'], name: 'QR');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QpayPayment(
              qpayUrls: data['data'],
              qpayImage: data['qr_image'],
            ),
          ),
        );
      } else {
        if (kIsWeb) {
          js.context.callMethod('open', [data['data']]);
          return;
        }
        Navigator.push(context, MaterialPageRoute(builder: (context) => CardPayment(url: data['data'])));
      }
    } else {
      TopSnackBar.errorFactory(msg: "Дахин оролдоно уу.").show(context);
    }
  }
}
