import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodali/Providers/auth_provider.dart';
import 'package:goodali/Providers/cart_provider.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/custom_elevated_button.dart';
import 'package:goodali/Widgets/simple_appbar.dart';

import 'package:goodali/screens/Auth/login.dart';
import 'package:goodali/screens/payment/choose_payment.dart';
import 'package:goodali/screens/ListItems/cart_product_item.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<int> productIds = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isAuth = context.watch<Auth>().isAuth;

    return Scaffold(
      appBar: const SimpleAppBar(noCard: true),
      body: Consumer<CartProvider>(
        builder: (context, value, child) {
          if (value.cartItem.isEmpty) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
              ),
            );
          } else {
            productIds = value.cartItemId;
            return Column(
              children: [
                Container(
                  height: 56,
                  padding: const EdgeInsets.only(left: 20),
                  alignment: Alignment.centerLeft,
                  child: const Text("Таны сагс",
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: MyColors.black)),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: value.cartItem.length,
                      itemBuilder: (context, index) {
                        return CartProductItem(products: value.cartItem[index]);
                      }),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
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
                onPress: context.watch<CartProvider>().cartItem.isEmpty
                    ? null
                    : () {
                        if (isAuth == true) {
                          print(productIds);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ChoosePayment(productIDs: productIds)));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  const Text("Та нэвтэрч орон үргэлжлүүлнэ үү"),
                              backgroundColor: MyColors.error,
                              behavior: SnackBarBehavior.floating,
                              action: SnackBarAction(
                                  onPressed: () => showLoginModal(),
                                  label: 'Нэвтрэх',
                                  textColor: Colors.white)));
                        }
                      },
                text: "Худалдаж авах",
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  showLoginModal() {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: true,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        builder: (BuildContext context) =>
            const LoginBottomSheet(isRegistered: true));
  }
}
