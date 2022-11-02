import 'package:flutter/material.dart';

class MyDelegate extends SliverPersistentHeaderDelegate {
  MyDelegate(this.tabbar, {this.container});
  final TabBar tabbar;
  final Widget? container;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
        color: Colors.white,
        child: Column(children: [container ?? const SizedBox(), tabbar]));
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => container == null
      ? tabbar.preferredSize.height
      : tabbar.preferredSize.height + 40;

  @override
  // TODO: implement minExtent
  double get minExtent => container == null
      ? tabbar.preferredSize.height
      : tabbar.preferredSize.height + 40;
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
