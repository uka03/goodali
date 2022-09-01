import 'package:flutter/material.dart';

class MyDelegate extends SliverPersistentHeaderDelegate {
  MyDelegate(this.tabbar);
  final TabBar tabbar;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: Colors.white, child: tabbar);
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => tabbar.preferredSize.height;

  @override
  // TODO: implement minExtent
  double get minExtent => tabbar.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
