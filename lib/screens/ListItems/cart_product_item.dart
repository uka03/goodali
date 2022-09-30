import 'package:flutter/material.dart';
import 'package:goodali/Providers/cart_provider.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Utils/utils.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/models/products_model.dart';
import 'package:provider/provider.dart';

class CartProductItem extends StatelessWidget {
  final Products products;
  const CartProductItem({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, value, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          height: 90,
          width: double.infinity,
          decoration: BoxDecoration(
              color: MyColors.input, borderRadius: BorderRadius.circular(12)),
          child: Stack(children: [
            Positioned(
              top: 14,
              left: 14,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child:
                      // Container(
                      //   width: 36,
                      //   height: 36,
                      //   color: Colors.pink,
                      // )
                      ImageView(
                          imgPath: products.banner == ""
                              ? products.trainingBanner ?? ""
                              : products.banner ?? "",
                          width: 36,
                          height: 36)),
            ),
            Positioned(
              top: 20,
              left: 70,
              child: SizedBox(
                width: 220,
                child: Text(
                  products.title == ""
                      ? products.traingName ?? ""
                      : products.title ?? "",
                  style: const TextStyle(color: MyColors.black),
                ),
              ),
            ),
            // Positioned(
            //   bottom: 20,
            //   left: 70,
            //   child: Text(
            //     "Lekts",
            //     style: TextStyle(fontSize: 12, color: MyColors.primaryColor),
            //   ),
            // ),
            Positioned(
              bottom: 20,
              right: 14,
              child: Text(
                products.price.toString() + "₮",
                style: const TextStyle(fontSize: 12, color: MyColors.gray),
              ),
            ),
            Positioned(
                top: 6,
                right: 6,
                child: IconButton(
                  icon: const Icon(Icons.close, color: MyColors.gray),
                  onPressed: () {
                    value.removeTotalPrice(products.price?.toDouble() ?? 0.0);
                    value.removeCartProduct(products);
                  },
                ))
          ]),
        );
      },
    );
  }
}
