import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:goodali/Providers/cart_provider.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/screens/payment/cart_screen.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class SimpleAppBar extends StatelessWidget with PreferredSizeWidget {
  final String? title;
  final bool noCard;
  const SimpleAppBar({Key? key, this.title, this.noCard = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(IconlyLight.arrow_left),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        noCard
            ? Container()
            : Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: MyColors.input,
                  child: Consumer<CartProvider>(
                    builder: (context, value, child) => Badge(
                      showBadge:
                          value.getCounter() < 0 || value.getCounter() == 0
                              ? false
                              : true,
                      badgeContent: Text(
                        value.getCounter() < 0
                            ? "0"
                            : value.getCounter().toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                      animationDuration: const Duration(milliseconds: 600),
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
                    ),
                  ),
                ))
      ],
      iconTheme: const IconThemeData(color: MyColors.black),
      title: Text(
        title ?? "",
        style: const TextStyle(fontSize: 18, color: MyColors.black),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
