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

class ChoosePayment extends StatefulWidget {
  final List<int> productIDs;
  const ChoosePayment({Key? key, required this.productIDs}) : super(key: key);

  @override
  State<ChoosePayment> createState() => _ChoosePaymentState();
}

class _ChoosePaymentState extends State<ChoosePayment> {
  List<QpayURLS> urls = [];
  @override
  Widget build(BuildContext context) {
    print(widget.productIDs);
    return Scaffold(
      appBar: const SimpleAppBar(noCard: true),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text("Төлөх хэлбэр сонгох",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: MyColors.black)),
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
                decoration: BoxDecoration(
                    color: MyColors.input,
                    borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: const [
                    SizedBox(width: 20),
                    Icon(
                      IconlyLight.scan,
                      color: MyColors.primaryColor,
                    ),
                    SizedBox(width: 20),
                    Text("QPay",
                        style: TextStyle(fontSize: 16, color: MyColors.black)),
                    Spacer(),
                    Icon(IconlyLight.arrow_right_2,
                        color: MyColors.gray, size: 20),
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
                decoration: BoxDecoration(
                    color: MyColors.input,
                    borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: const [
                    SizedBox(width: 20),
                    Icon(
                      IconlyLight.wallet,
                      color: MyColors.primaryColor,
                    ),
                    SizedBox(width: 20),
                    Text("Карт",
                        style: TextStyle(fontSize: 16, color: MyColors.black)),
                    Spacer(),
                    Icon(IconlyLight.arrow_right_2,
                        color: MyColors.gray, size: 20),
                    SizedBox(width: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  createOrderRequest(BuildContext context, int invoiceType) async {
    print(widget.productIDs);

    var data = await Connection.createOrderRequest(
        context, invoiceType, widget.productIDs);
    Navigator.pop(context);
    if (data['success'] == true) {
      if (invoiceType == 0) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => QpayPayment(qpayUrls: data['data'])));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CardPayment(url: data['data'])));
      }
    } else {
      TopSnackBar.errorFactory(msg: "Дахин оролдоно уу.").show(context);
    }
  }
}
