import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:iconly/iconly.dart';

class PaymentHistory extends StatefulWidget {
  const PaymentHistory({Key? key}) : super(key: key);

  @override
  State<PaymentHistory> createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
          length: 4,
          child: NestedScrollView(
              physics: const NeverScrollableScrollPhysics(),
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    pinned: true,
                    floating: true,
                    // snap: true,
                    elevation: 0,
                    iconTheme: const IconThemeData(color: MyColors.black),
                    backgroundColor: Colors.white,
                    bottom: PreferredSize(
                        preferredSize:
                            const Size(double.infinity, kToolbarHeight - 10),
                        child: Container(
                          padding: const EdgeInsets.only(left: 20),
                          alignment: Alignment.topLeft,
                          child: const Text("Түүх",
                              style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: MyColors.black)),
                        )),
                  ),
                ];
              },
              body: Column(
                children: [
                  const SizedBox(height: 100),
                  SvgPicture.asset("assets/images/empty_cart.svg",
                      semanticsLabel: 'Acme Logo'),
                  const SizedBox(height: 20),
                  const Text(
                    "Худалдан авалтын түүх байхгүй байна...",
                    style: TextStyle(fontSize: 14, color: MyColors.gray),
                  ),
                ],
              ))),
    );
  }
}
