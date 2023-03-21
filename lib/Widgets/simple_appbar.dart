import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:goodali/Providers/cart_provider.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/screens/payment/cart_screen.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SimpleAppBar extends StatefulWidget with PreferredSizeWidget {
  final String? title;
  final bool noCard;
  final dynamic data;
  const SimpleAppBar({Key? key, this.title, this.noCard = false, this.data}) : super(key: key);

  @override
  State<SimpleAppBar> createState() => _SimpleAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SimpleAppBarState extends State<SimpleAppBar> {
  String username = "";
  @override
  void initState() {
    getUserName();
    super.initState();
  }

  getUserName() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      username = pref.getString("email") ?? "";
    });
    // print('appbar $username');
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      leading: IconButton(splashRadius: 20, icon: const Icon(IconlyLight.arrow_left), onPressed: () => Navigator.pop(context, widget.data)),
      actions: [
        widget.noCard || username == "surgalt9@gmail.com"
            ? Container()
            : Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: MyColors.input,
                  child: Consumer<CartProvider>(
                    builder: (context, value, child) => badges.Badge(
                      showBadge: value.getCounter() < 0 || value.getCounter() == 0 ? false : true,
                      badgeContent: Text(
                        value.getCounter() < 0 ? "0" : value.getCounter().toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                      animationDuration: const Duration(milliseconds: 600),
                      child: IconButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
                          },
                          splashRadius: 10,
                          icon: const Icon(IconlyLight.buy, size: 28, color: MyColors.black)),
                    ),
                  ),
                ))
      ],
      iconTheme: const IconThemeData(color: MyColors.black),
      title: Text(
        widget.title ?? "",
        style: const TextStyle(fontSize: 18, color: MyColors.black),
      ),
    );
  }
}
