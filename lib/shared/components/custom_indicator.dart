import 'package:flutter/material.dart';
import 'package:goodali/utils/colors.dart';

class CustomIndicator extends StatelessWidget {
  const CustomIndicator({
    super.key,
    this.current = 0,
    required this.length,
    this.dotSize,
    this.activeDotSize,
    this.height,
    this.activeColor,
    this.color,
    this.axisSize,
    this.indicatorHeight,
  });

  final int current;
  final int length;
  final double? dotSize;
  final double? activeDotSize;
  final double? height;
  final double? indicatorHeight;
  final Color? activeColor;
  final Color? color;
  final MainAxisSize? axisSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: indicatorHeight ?? 25,
      child: Row(
        mainAxisSize: axisSize ?? MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(length, (index) => index)
            .asMap()
            .entries
            .map((entry) {
          return AnimatedContainer(
            width: current == entry.key
                ? (activeDotSize ?? 37)
                : (dotSize ?? 24.0),
            height: height ?? 8.0,
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: current == entry.key
                  ? activeColor ?? GoodaliColors.whiteColor
                  : color ?? GoodaliColors.whiteColor.withOpacity(0.2),
            ),
            duration: Duration(milliseconds: 500),
          );
        }).toList(),
      ),
    );
  }
}
