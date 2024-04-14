import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:goodali/pages/album/album_page.dart';
import 'package:goodali/pages/article/article_page.dart';
import 'package:goodali/pages/auth/auth_web_page.dart';
import 'package:goodali/pages/auth/provider/auth_provider.dart';
import 'package:goodali/pages/cart/cart_page.dart';
import 'package:goodali/pages/cart/provider/cart_provider.dart';
import 'package:goodali/pages/podcast/podcast_page.dart';
import 'package:goodali/pages/profile/profile_edit.dart';
import 'package:goodali/pages/search/search_page.dart';
import 'package:goodali/pages/video/videos_page.dart';
import 'package:goodali/shared/components/action_item.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/shared/components/custom_input.dart';
import 'package:goodali/shared/provider/navigator_provider.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:provider/provider.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({
    super.key,
    this.title,
    this.bottom,
    this.actions,
    this.leading,
    this.onSearch,
    this.haveNotification,
    this.hasPresident = false,
  });

  final String? title;
  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final List<Widget>? actions;
  final VoidCallback? onSearch;
  final bool? haveNotification;
  final bool hasPresident;

  @override
  get preferredSize => bottom != null ? Size.fromHeight(hasPresident ? 90 : 60 + bottom!.preferredSize.height) : Size.fromHeight(hasPresident ? 90 : 60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: GoodaliColors.primaryBGColor,
      centerTitle: false,
      titleSpacing: 0,
      leading: leading,
      title: Container(
        padding: const EdgeInsets.only(left: 16.0),
        alignment: Alignment.centerLeft,
        child: Text(
          title ?? "",
          style: GoodaliTextStyles.titleText(
            context,
            fontSize: 32,
          ),
        ),
      ),
      actions: actions ?? [],
    );
  }
}

class CustomWebAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomWebAppbar({
    super.key,
    this.title,
    this.bottom,
    this.actions,
    this.onSearch,
    this.haveNotification,
  });

  final String? title;
  final PreferredSizeWidget? bottom;
  final List<Widget>? actions;
  final VoidCallback? onSearch;
  final bool? haveNotification;

  @override
  get preferredSize => bottom != null ? Size.fromHeight(64 + bottom!.preferredSize.height) : Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final items = <String>[
      'Цомог',
      'Подкаст',
      'Видео',
      'Бичвэр',
    ];
    final itemsProfile = <String>[
      'Би',
      'Миний мэдээлэл',
      'Пин код солих',
      'Нийтлэг асуулт хариулт',
      'Гарах'
    ];
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: GoodaliColors.primaryBGColor,
      centerTitle: false,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Consumer<NavigationProvider>(builder: (context, navigtation, _) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              HSpacer.lg(),
              CustomButton(
                onPressed: () {
                  navigtation.selectTab(0);
                },
                child: Image.asset(
                  "assets/images/logo.png",
                  height: 32,
                ),
              ),
              HSpacer.lg(),
              Expanded(
                child: CustomInput(
                  controller: TextEditingController(),
                  readOnly: true,
                  onTap: () {
                    if (Navigator.canPop(context)) {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    }
                    Navigator.pushNamed(context, SearchPage.routeName);
                  },
                ),
              ),
              HSpacer.lg(),
              DropdownButtonHideUnderline(
                child: DropdownButton2(
                  customButton: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        Text(
                          "Сэтгэл",
                          style: GoodaliTextStyles.titleText(context, fontSize: 14),
                        ),
                        HSpacer(),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 20,
                          color: GoodaliColors.grayColor,
                        ),
                      ],
                    ),
                  ),
                  onChanged: (value) {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                    switch (value) {
                      case "Цомог":
                        Navigator.pushNamed(context, AlbumPage.routeName);
                        break;
                      case "Подкаст":
                        Navigator.pushNamed(context, PodcastPage.routeName);
                        break;
                      case "Видео":
                        Navigator.pushNamed(context, VideosPage.routeName);
                        break;
                      case "Бичвэр":
                        Navigator.pushNamed(context, ArticlePage.routeName);
                        break;
                      default:
                    }
                  },
                  items: items
                      .map(
                        (item) => DropdownMenuItem<String>(
                          value: item,
                          child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                            child: Text(
                              item,
                              style: GoodaliTextStyles.bodyText(context),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  dropdownStyleData: DropdownStyleData(
                    width: 160,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: GoodaliColors.primaryBGColor,
                    ),
                    offset: Offset(0, -10),
                  ),
                ),
              ),
              CustomButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  }
                  navigtation.selectTab(1);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      Text(
                        "Түүдэг гал",
                        style: GoodaliTextStyles.titleText(context, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              HSpacer(),
              Consumer<AuthProvider>(builder: (context, provider, _) {
                if (provider.token.isNotEmpty == true) {
                  return Row(
                    children: [
                      Consumer<CartProvider>(builder: (context, cartProviderConsumer, _) {
                        return ActionItem(
                          iconPath: 'assets/icons/ic_cart.png',
                          onPressed: () {
                            Navigator.of(context).pushNamed(CartPage.routeName);
                          },
                          isDot: cartProviderConsumer.products.isNotEmpty,
                          count: cartProviderConsumer.products.length,
                        );
                      }),
                      HSpacer(),
                      Consumer<AuthProvider>(builder: (context, authProvider, _) {
                        return DropdownButtonHideUnderline(
                          child: DropdownButton2(
                            customButton: Container(
                              margin: EdgeInsets.symmetric(horizontal: 8),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(color: GoodaliColors.inputColor, borderRadius: BorderRadius.circular(20)),
                              child: Image.asset(
                                'assets/icons/ic_profile.png',
                                width: 24,
                                color: GoodaliColors.grayColor,
                              ),
                            ),
                            onChanged: (value) {
                              switch (value?.toLowerCase()) {
                                case "би":
                                  if (Navigator.canPop(context)) {
                                    Navigator.popUntil(context, (route) => route.isFirst);
                                  }
                                  navigtation.selectTab(2);
                                  break;
                                case "миний мэдээлэл":
                                  if (Navigator.canPop(context)) {
                                    Navigator.popUntil(context, (route) => route.isFirst);
                                  }
                                  Navigator.pushNamed(context, ProfileEdit.routeName);
                                  break;
                                case "гарах":
                                  navigtation.selectTab(0);
                                  if (Navigator.canPop(context)) {
                                    Navigator.popUntil(context, (route) => route.isFirst);
                                  }
                                  authProvider.logout();
                                  break;
                                default:
                              }
                            },
                            items: itemsProfile
                                .map(
                                  (item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                                      child: Text(
                                        item,
                                        style: GoodaliTextStyles.bodyText(context, textColor: item.toLowerCase() == "гарах" ? GoodaliColors.errorColor : GoodaliColors.blackColor),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            dropdownStyleData: DropdownStyleData(
                              width: 160,
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: GoodaliColors.primaryBGColor,
                              ),
                              offset: Offset(0, -10),
                            ),
                          ),
                        );
                      })
                    ],
                  );
                }
                return CustomButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AuthWebPage.routeName);
                  },
                  child: Container(
                    decoration: BoxDecoration(color: GoodaliColors.primaryColor, borderRadius: BorderRadius.circular(8)),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      "Нэвтрэх",
                      style: GoodaliTextStyles.bodyText(context, fontSize: 14, textColor: GoodaliColors.whiteColor),
                    ),
                  ),
                );
              }),
              HSpacer.lg(),
            ],
          );
        }),
      ),
      actions: actions ?? [],
    );
  }
}
