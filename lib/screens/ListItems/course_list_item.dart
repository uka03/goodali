import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:goodali/Providers/cart_provider.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Utils/utils.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/payment/cart_screen.dart';

import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class CourseListListItem extends StatefulWidget {
  final Products products;
  const CourseListListItem({Key? key, required this.products})
      : super(key: key);

  @override
  State<CourseListListItem> createState() => _CourseListListItemState();
}

class _CourseListListItemState extends State<CourseListListItem> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Stack(children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: MyColors.border1, width: 0.5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.products.name ?? "" "багц",
                      style: const TextStyle(
                          color: MyColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    widget.products.opennedDate == ""
                        ? "Нээлттэй"
                        : dateTimeFormatter(widget.products.opennedDate ?? ""),
                    style: const TextStyle(color: MyColors.gray, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              HtmlWidget(widget.products.body ?? "",
                  textStyle: const TextStyle(
                      fontSize: 14,
                      height: 1.8,
                      color: MyColors.black,
                      fontFamily: "Gilroy")),
              const SizedBox(height: 20),
              Row(
                children: [
                  if (widget.products.isBought == false)
                    GestureDetector(
                      onTap: () {
                        cart.addItemsIndex(widget.products.productId!);

                        if (!cart.sameItemCheck) {
                          cart.addProducts(widget.products);
                          cart.addTotalPrice(
                              widget.products.price?.toDouble() ?? 0.0);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const CartScreen()));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const CartScreen()));
                        }
                      },
                      child: Container(
                        height: 40,
                        width: 120,
                        decoration: BoxDecoration(
                            color: MyColors.primaryColor,
                            borderRadius: BorderRadius.circular(6)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const [
                            Text(
                              "Сонгох",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Icon(IconlyLight.arrow_right_2, color: Colors.white)
                          ],
                        ),
                      ),
                    ),
                  const Spacer(),
                  Wrap(children: [
                    const Text(
                      "Үнэ: ",
                      style: TextStyle(color: MyColors.gray, fontSize: 12),
                    ),
                    Text(
                      widget.products.price.toString() + "₮",
                      style:
                          const TextStyle(color: MyColors.black, fontSize: 12),
                    ),
                  ])
                ],
              )
            ],
          ),
        ),
      ]),
    );
  }
}
