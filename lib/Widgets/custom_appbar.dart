import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:goodali/Providers/cart_provider.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/screens/payment/cart_screen.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final Widget? actionButton1;
  final Widget? actionButton2;
  final bool isCartButton;
  final String? title;
  const CustomAppBar(
      {Key? key,
      this.actionButton1,
      this.title,
      this.actionButton2,
      this.isCartButton = true})
      : super(key: key);

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      title: Text(
        title ?? "Сэтгэл",
        style: const TextStyle(
            fontSize: 28, fontWeight: FontWeight.bold, color: MyColors.black),
      ),
      actions: [
        actionButton2 != null
            ? Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: CircleAvatar(
                    radius: 22,
                    backgroundColor: MyColors.input,
                    child: actionButton2),
              )
            : Container(),
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: CircleAvatar(
              radius: 22,
              backgroundColor: MyColors.input,
              child: isCartButton
                  ? Consumer<CartProvider>(
                      builder: (context, value, child) => Badge(
                            showBadge: value.getCounter() < 0 ||
                                    value.getCounter() == 0
                                ? false
                                : true,
                            badgeContent: Text(
                              value.getCounter() < 0
                                  ? "0"
                                  : value.getCounter().toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                            animationDuration:
                                const Duration(milliseconds: 600),
                            child: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => const CartScreen()));
                                },
                                splashRadius: 10,
                                icon: const Icon(IconlyLight.buy,
                                    size: 28, color: MyColors.black)),
                          ))
                  : actionButton1),
        )
      ],
    );
  }
}
