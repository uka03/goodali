import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodali/Providers/auth_provider.dart';
import 'package:goodali/Providers/cart_provider.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/custom_elevated_button.dart';
import 'package:goodali/Widgets/top_snack_bar.dart';
import 'package:goodali/screens/payment/choose_payment.dart';
import 'package:goodali/screens/payment/payment_history.dart';
import 'package:goodali/screens/ListItems/cart_product_item.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<int> productIds = [];

  @override
  Widget build(BuildContext context) {
    bool isAuth = context.watch<Auth>().isAuth;
    return Scaffold(
      body: NestedScrollView(
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
                      child: const Text("Таны сагс",
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: MyColors.black)),
                    )),
                actions: [
                  Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: CircleAvatar(
                          radius: 22,
                          backgroundColor: MyColors.input,
                          child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const PaymentHistory()));
                              },
                              splashRadius: 10,
                              icon: const Icon(IconlyLight.time_circle,
                                  size: 28, color: MyColors.black))))
                ],
              ),
            ];
          },
          body: Consumer<CartProvider>(
            builder: (context, value, child) {
              if (value.cartItem.isEmpty) {
                return Column(
                  children: [
                    const SizedBox(height: 100),
                    SvgPicture.asset("assets/images/empty_cart.svg",
                        semanticsLabel: 'Acme Logo'),
                    const SizedBox(height: 20),
                    const Text(
                      "Таны сагс хоосон байна...",
                      style: TextStyle(fontSize: 14, color: MyColors.gray),
                    )
                  ],
                );
              } else {
                productIds = value.cartItemId;
                return ListView.builder(
                    itemCount: value.cartItem.length,
                    itemBuilder: (context, index) {
                      return CartProductItem(products: value.cartItem[index]);
                    });
              }
            },
          )),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Нийт төлөх дүн: ",
                  style: TextStyle(color: MyColors.gray)),
              Consumer<CartProvider>(
                builder: (context, value, child) => Text(
                    value.getTotalPrice().toInt().toString() + "₮",
                    style: const TextStyle(
                        color: MyColors.primaryColor,
                        fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomElevatedButton(
              onPress: () {
                if (isAuth == true) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ChoosePayment(productIDs: productIds)));
                } else {
                  showTopSnackBar(
                      context,
                      const CustomTopSnackBar(
                          type: 0, text: "Нэвтэрч орон үргэлжлүүлнэ үү..."));
                }
              },
              text: "Худалдаж авах",
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
