import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/audio/provider/audio_provider.dart';
import 'package:goodali/pages/cart/provider/cart_provider.dart';
import 'package:goodali/pages/menu/term_page.dart';
import 'package:goodali/pages/payment/payment_page.dart';
import 'package:goodali/shared/components/appbar_with_back.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/shared/components/general_scaffold.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/constants.dart';
import 'package:goodali/utils/primary_button.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  static String routeName = "cart_page";

  @override
  State<CartPage> createState() => _CartPageState();
}

String formatNumber(int number) {
  final formattedNumber = NumberFormat('#,##0').format(number);
  return formattedNumber;
}

class _CartPageState extends State<CartPage> {
  late final AudioProvider audioProvider;
  bool isAgreed = false;
  @override
  void initState() {
    super.initState();
    audioProvider = Provider.of<AudioProvider>(context, listen: false);
    audioProvider.setPlayerState(context, GoodaliPlayerState.disposed);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, provider, _) {
        return GeneralScaffold(
          appBar: AppbarWithBackButton(),
          child: Container(
            margin: kIsWeb ? EdgeInsets.symmetric(horizontal: 155) : null,
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Таны сагс",
                            style: GoodaliTextStyles.titleText(
                              context,
                              fontSize: 32,
                            ),
                          ),
                          HSpacer(),
                          provider.products.isNotEmpty
                              ? Text(
                                  "${provider.products.length} Ширхэг",
                                  style: GoodaliTextStyles.titleText(
                                    context,
                                    textColor: GoodaliColors.grayColor,
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                      VSpacer(),
                      provider.products.isNotEmpty
                          ? Expanded(
                              child: ListView.separated(
                                itemCount: provider.products.length,
                                separatorBuilder: (context, index) => VSpacer(),
                                itemBuilder: (context, index) {
                                  final item = provider.products[index];
                                  return Container(
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: GoodaliColors.inputColor,
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(5),
                                          child: CachedNetworkImage(
                                            imageUrl: item.banner?.toUrl() ?? placeholder,
                                            width: 40,
                                            height: 40,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        HSpacer(),
                                        Expanded(
                                          child: Text(item.title ?? ""),
                                        ),
                                        HSpacer(),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomButton(
                                              onPressed: () {
                                                provider.removeProduct(item);
                                              },
                                              child: Icon(
                                                Icons.close,
                                                color: GoodaliColors.grayColor,
                                              ),
                                            ),
                                            VSpacer.sm(),
                                            Text(
                                              "${formatNumber(item.price ?? 0)}₮",
                                              style: GoodaliTextStyles.bodyText(context, fontSize: 16),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                VSpacer(size: 60),
                                Image.asset(
                                  "assets/images/empty_cart.png",
                                  width: 200,
                                ),
                                VSpacer(),
                                Text("Таны сагс хоосон байна...")
                              ],
                            ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 20,
                  left: 20,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Нийт төлөх дүн: ",
                            style: GoodaliTextStyles.bodyText(context),
                          ),
                          Text(
                            "${formatNumber(provider.getTotalPrice())}₮",
                            style: GoodaliTextStyles.bodyText(context, fontSize: 16, textColor: GoodaliColors.primaryColor),
                          ),
                        ],
                      ),
                      VSpacer(),
                      CustomButton(
                        onPressed: () {
                          setState(() {
                            isAgreed = !isAgreed;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: isAgreed ? GoodaliColors.primaryColor : GoodaliColors.borderColor, width: 2),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: isAgreed ? GoodaliColors.primaryColor : GoodaliColors.whiteColor,
                                  border: Border.all(color: isAgreed ? GoodaliColors.primaryColor : GoodaliColors.borderColor, width: 2),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.check,
                                    size: 12,
                                    color: GoodaliColors.whiteColor,
                                  ),
                                ),
                              ),
                              HSpacer(size: 10),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, TermPage.routeName);
                                  setState(() {
                                    isAgreed = !isAgreed;
                                  });
                                },
                                child: Text(
                                  "Гэрээтэй танилцан, зөвшөөрсөн",
                                  style: GoodaliTextStyles.bodyText(context, textColor: Colors.lightBlue, decoration: TextDecoration.underline),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      VSpacer(),
                      PrimaryButton(
                        text: "Худалдаж авах",
                        height: 50,
                        isEnable: provider.products.isNotEmpty && isAgreed,
                        onPressed: () {
                          Navigator.pushNamed(context, PaymentPage.routeName);
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
