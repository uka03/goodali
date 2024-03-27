import 'package:flutter/material.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/utils.dart';

class TypeBar extends StatelessWidget {
  const TypeBar({
    super.key,
    required this.onChanged,
    required this.selectedType,
    required this.typeItems,
  });
  final Function(int index) onChanged;
  final int selectedType;
  final List<TypeItem> typeItems;

  @override
  Widget build(BuildContext context) {
    return TabBar(
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
    );
  }
}

class TypeItemWidget extends StatelessWidget {
  const TypeItemWidget({
    super.key,
    required this.type,
    required this.selectedType,
  });

  final TypeItem type;
  final int selectedType;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(3),
          bottomRight: Radius.circular(3),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Center(
        child: Text(
          type.title,
          style: GoodaliTextStyles.titleText(
            context,
            textColor: selectedType == type.index
                ? GoodaliColors.primaryColor
                : GoodaliColors.grayColor,
            fontWeight:
                selectedType == type.index ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
