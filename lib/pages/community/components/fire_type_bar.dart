import 'package:flutter/material.dart';
import 'package:goodali/pages/home/components/type_bar.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/utils.dart';

class FireTypeBar extends SliverPersistentHeaderDelegate {
  const FireTypeBar({
    required this.onChanged,
    required this.selectedType,
    required this.typeItems,
  });
  final Function(int index) onChanged;
  final int selectedType;
  final List<TypeItem> typeItems;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: GoodaliColors.primaryBGColor,
      child: TabBar(
        padding: EdgeInsets.symmetric(horizontal: 16),
        isScrollable: true,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorWeight: 4,
        tabAlignment: TabAlignment.start,
        labelPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
        onTap: onChanged,
        indicatorColor: GoodaliColors.primaryColor,
        labelColor: GoodaliColors.primaryColor,
        labelStyle: GoodaliTextStyles.titleText(
          context,
          fontWeight: FontWeight.w600,
        ),
        tabs: typeItems
            .map(
              (type) => TypeItemWidget(type: type, selectedType: selectedType),
            )
            .toList(),
      ),
    );
  }

  @override
  double get maxExtent => kToolbarHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
