import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:goodali/Utils/constans.dart';
import 'package:goodali/Utils/utils.dart';
import 'package:goodali/controller/audioplayer_controller.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/audioScreens.dart/play_audio.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class CustomNavBarWidget extends StatelessWidget {
  final int selectedIndex;
  final List<PersistentBottomNavBarItem> items;
  final ValueChanged<int> onItemSelected;

  const CustomNavBarWidget({
    Key? key,
    required this.selectedIndex,
    required this.items,
    required this.onItemSelected,
  }) : super(key: key);

  Widget _buildItem(PersistentBottomNavBarItem item, bool isSelected) {
    return Container(
      alignment: Alignment.center,
      height: kBottomNavigationBarHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: IconTheme(
              data: IconThemeData(
                  size: 26.0,
                  color: isSelected
                      ? (item.activeColorSecondary ?? item.activeColorPrimary)
                      : item.inactiveColorPrimary ?? item.activeColorPrimary),
              child: item.icon,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Material(
              type: MaterialType.transparency,
              child: FittedBox(
                  child: Text(
                item.title ?? "",
                style: TextStyle(
                    color: isSelected
                        ? (item.activeColorSecondary ?? item.activeColorPrimary)
                        : item.inactiveColorPrimary,
                    fontWeight: FontWeight.w400,
                    fontSize: 12.0),
              )),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.red,
          child: SizedBox(
            width: double.infinity,
            height: kBottomNavigationBarHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: items.map((item) {
                int index = items.indexOf(item);
                return Flexible(
                  child: GestureDetector(
                    onTap: () {
                      onItemSelected(index);
                    },
                    child: _buildItem(item, selectedIndex == index),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        ValueListenableBuilder(
            valueListenable: currentlyPlaying,
            builder:
                (BuildContext context, Products? podcastItem, Widget? child) {
              return podcastItem != null
                  ? PlayAudio(
                      products: podcastItem,
                      albumName: podcastItem.albumTitle ?? "",
                    )
                  : Container();
            }),
      ],
    );
  }
}
