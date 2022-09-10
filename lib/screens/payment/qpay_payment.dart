import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/Widgets/top_snack_bar.dart';
import 'package:goodali/models/qpay.dart';
import 'package:iconly/iconly.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:url_launcher/url_launcher_string.dart';

class QpayPayment extends StatefulWidget {
  final List<QpayURLS> qpayUrls;
  const QpayPayment({Key? key, required this.qpayUrls}) : super(key: key);

  @override
  State<QpayPayment> createState() => _QpayPaymentState();
}

class _QpayPaymentState extends State<QpayPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text("Банк сонгох",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: MyColors.black)),
            const SizedBox(height: 20),
            Expanded(
                child: ListView.builder(
              itemCount:
                  widget.qpayUrls.length < 9 ? widget.qpayUrls.length : 9,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    openBankApp(widget.qpayUrls[index].link ?? "");
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    height: 64,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: MyColors.input,
                        borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        const SizedBox(width: 20),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: ImageView(
                              imgPath: widget.qpayUrls[index].logo!,
                              width: 32,
                              height: 32,
                              isQpay: true),
                        ),
                        const SizedBox(width: 20),
                        Text(widget.qpayUrls[index].name ?? "",
                            style: const TextStyle(color: MyColors.black)),
                        const Spacer(),
                        const Icon(
                          IconlyLight.arrow_right_2,
                          color: MyColors.gray,
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                  ),
                );
              },
            ))
          ],
        ),
      ),
    );
  }

  openBankApp(String url) async {
    final bool canLaunchApp = await launchUrlString(url);
    if (canLaunchApp) {
      await launchUrlString(url);
    } else {
      showTopSnackBar(
          context,
          const CustomTopSnackBar(
              type: 0, text: "Тухайн банкны аппликейшн олдсонгүй"));
    }
  }
}
