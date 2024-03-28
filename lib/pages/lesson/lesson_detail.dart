import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:goodali/connection/models/product_response.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/auth/provider/auth_provider.dart';
import 'package:goodali/pages/cart/provider/cart_provider.dart';
import 'package:goodali/pages/home/provider/home_provider.dart';
import 'package:goodali/pages/lesson/membership_page.dart';
import 'package:goodali/shared/components/appbar_with_back.dart';
import 'package:goodali/shared/components/general_scaffold.dart';
import 'package:goodali/utils/constants.dart';
import 'package:goodali/utils/globals.dart';
import 'package:goodali/utils/primary_button.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/toasts.dart';
import 'package:provider/provider.dart';

class LessonDetail extends StatefulWidget {
  const LessonDetail({
    super.key,
    this.data,
    this.isBought = false,
    this.id,
  });

  final ProductResponseData? data;
  final int? id;
  final bool isBought;

  @override
  State<LessonDetail> createState() => _LessonDetailState();
}

class _LessonDetailState extends State<LessonDetail> {
  ProductResponseData? data;
  late CartProvider cartProvider;
  late AuthProvider authProvider;
  late HomeProvider homeProvider;
  @override
  void initState() {
    super.initState();

    cartProvider = Provider.of<CartProvider>(context, listen: false);
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (widget.data != null) {
        data = widget.data;
      } else if (widget.id != null) {
        showLoader();
        data = await Provider.of<HomeProvider>(context, listen: false)
            .getLesson(id: widget.id);
        dismissLoader();
      }
      setState(() {});

      authProvider.getMe();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GeneralScaffold(
      appBar: AppbarWithBackButton(),
      actionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: PrimaryButton(
          height: 50,
          text: "Худалдаж авах",
          textFontSize: 16,
          onPressed: () {
            if (authProvider.token?.isNotEmpty == true) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MembershipPage(
                    data: data,
                  ),
                ),
              );
            } else {
              Toast.error(context,
                  description:
                      "Та уг үйлдэлийг хийхийн тулд нэвтрэх хэрэгтэй.");
            }
          },
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ClipRRect(
              child: CachedNetworkImage(
                imageUrl: data?.banner.toUrl() ?? placeholder,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: HtmlWidget(
                data?.body ?? "",
                textStyle: GoodaliTextStyles.bodyText(context),
              ),
            )
          ],
        ),
      ),
    );
  }
}
