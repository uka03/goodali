import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:goodali/connection/models/product_response.dart';
import 'package:goodali/pages/cart/cart_page.dart';
import 'package:goodali/pages/cart/provider/cart_provider.dart';
import 'package:goodali/pages/lesson/provider/lecture_provider.dart';
import 'package:goodali/shared/components/appbar_with_back.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/shared/components/general_scaffold.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/toasts.dart';
import 'package:provider/provider.dart';

class MembershipPage extends StatefulWidget {
  const MembershipPage({super.key, required this.data});
  final ProductResponseData? data;

  @override
  State<MembershipPage> createState() => _MembershipPageState();
}

class _MembershipPageState extends State<MembershipPage> {
  late final LessonProvider lessonProvider;
  late final CartProvider cartProvider;
  bool isAgreed = false;
  @override
  void initState() {
    super.initState();
    lessonProvider = Provider.of<LessonProvider>(context, listen: false);
    cartProvider = Provider.of<CartProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      lessonProvider.getCourses(id: widget.data?.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LessonProvider>(
      builder: (context, provider, _) {
        return GeneralScaffold(
          appBar: AppbarWithBackButton(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Та өөрт тохирох багц \nсонгоно уу",
                  textAlign: TextAlign.center,
                  style: GoodaliTextStyles.titleText(
                    context,
                    fontSize: 24,
                  ),
                ),
                ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.all(16),
                  itemCount: provider.courses.length,
                  separatorBuilder: (context, index) => VSpacer(),
                  itemBuilder: (context, index) {
                    final course = provider.courses[index];
                    return Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          border: Border.all(color: GoodaliColors.borderColor),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                course.name ?? "",
                                style: GoodaliTextStyles.titleText(context),
                              )),
                            ],
                          ),
                          VSpacer(),
                          HtmlWidget(course.body ?? ""),
                          VSpacer(),
                          CustomButton(
                            onPressed: () {
                              setState(() {
                                isAgreed = !isAgreed;
                              });
                            },
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: isAgreed
                                        ? GoodaliColors.primaryColor
                                        : GoodaliColors.whiteColor,
                                    border: Border.all(
                                        color: isAgreed
                                            ? GoodaliColors.primaryColor
                                            : GoodaliColors.borderColor,
                                        width: 2),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.check,
                                      size: 16,
                                      color: GoodaliColors.whiteColor,
                                    ),
                                  ),
                                ),
                                HSpacer(size: 10),
                                Expanded(
                                  child: Text("Гэрээтэй танилцан, зөвшөөрсөн"),
                                ),
                              ],
                            ),
                          ),
                          VSpacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              course.isBought == false
                                  ? CustomButton(
                                      onPressed: () {
                                        if (isAgreed) {
                                          cartProvider
                                              .addProduct(ProductResponseData(
                                            name: course.name,
                                            audio: null,
                                            audioCount: 0,
                                            banner: course.tBanner,
                                            body: course.body,
                                            id: course.id,
                                            moodId: null,
                                            isBought: course.isBought,
                                            isSpecial: 1,
                                            order: 1,
                                            price: course.price,
                                            productId: course.productId,
                                            status: 1,
                                            title: course.tName,
                                            pausedTime: null,
                                            totalTime: null,
                                            createdAt: null,
                                            expireAt: null,
                                            lectureTitle: null,
                                            albumTitle: null,
                                            albumId: course.price,
                                          ));
                                          Navigator.pushNamed(
                                              context, CartPage.routeName);
                                        } else {
                                          Toast.error(context,
                                              description:
                                                  "Та гэрээтэй танилцан зөвшөөрөх хэрэгтэй.");
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: GoodaliColors.primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 6),
                                        child: Text(
                                          "Сонгох",
                                          style: GoodaliTextStyles.titleText(
                                            context,
                                            fontSize: 14,
                                            textColor: GoodaliColors.whiteColor,
                                          ),
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                              Text(
                                "${course.price}₮",
                                style: GoodaliTextStyles.bodyText(context),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
