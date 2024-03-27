import 'package:flutter/material.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/text_styles.dart';

class AppbarWithBackButton extends StatelessWidget
    implements PreferredSizeWidget {
  const AppbarWithBackButton(
      {super.key,
      this.title,
      this.titleWidget,
      this.bottom,
      this.actions,
      this.leading,
      this.centerTitle = false,
      this.bgColor,
      this.onleading});

  final String? title;
  final Widget? titleWidget;
  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final List<Widget>? actions;
  final Function()? onleading;
  final bool centerTitle;
  final Color? bgColor;

  @override
  get preferredSize => bottom != null
      ? Size.fromHeight(50 + bottom!.preferredSize.height)
      : const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: bgColor ?? GoodaliColors.primaryBGColor,
      centerTitle: centerTitle,
      leading: leading ??
          IconButton(
            onPressed: () {
              if (onleading != null) {
                onleading!();
              }
              Navigator.pop(context);
            },
            icon: Image.asset(
              "assets/icons/ic_arrow_left.png",
              width: 30,
              height: 30,
            ),
          ),
      title: titleWidget ??
          Row(
            children: [
              Expanded(
                child: Text(
                  title ?? "",
                  maxLines: 2,
                  style: GoodaliTextStyles.titleText(context),
                  softWrap: true,
                ),
              ),
            ],
          ),
      actions: actions,
    );
  }
}
