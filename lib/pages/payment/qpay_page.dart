import 'package:flutter/material.dart';
import 'package:goodali/pages/cart/provider/cart_provider.dart';
import 'package:goodali/pages/payment/components/payment_item.dart';
import 'package:goodali/shared/components/appbar_with_back.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/constants.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/toasts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class QpayPage extends StatefulWidget {
  const QpayPage({super.key});

  static String routeName = "/qpay_page";

  @override
  State<QpayPage> createState() => _QpayPageState();
}

class _QpayPageState extends State<QpayPage> {
  late CartProvider cartProvider;

  @override
  void initState() {
    super.initState();
    cartProvider = Provider.of<CartProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      cartProvider.createOrder(invoiceType: 0);
    });
  }

  openBankApp(String url) async {
    final bool canLaunchApp = await launchUrlString(url);
    if (canLaunchApp) {
      await launchUrlString(url);
    } else {
      if (mounted) {
        Toast.error(context,
            description: "Тухайн банкны аппликейшн олдсонгүй.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, provider, _) {
      final urls = provider.paymentDetail.urls;
      return Scaffold(
        backgroundColor: GoodaliColors.primaryBGColor,
        appBar: AppbarWithBackButton(),
        body: SafeArea(
          child: Column(
            children: [
              Text(
                "Банк сонгох",
                style: GoodaliTextStyles.titleText(
                  context,
                  fontSize: 24,
                ),
              ),
              VSpacer(),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.all(16),
                  itemCount: urls?.length ?? 0,
                  separatorBuilder: (context, index) => VSpacer(),
                  itemBuilder: (context, index) {
                    final url = urls?[index];
                    return PaymentItem(
                      onPressed: () {
                        openBankApp(url?.link ?? "");
                      },
                      logoPath: url?.logo ?? placeholder,
                      logoOnline: true,
                      text: url?.name ?? "",
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
