import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:iconly/iconly.dart';

class FilterButton extends StatelessWidget {
  final Function onPress;
  const FilterButton({Key? key, required this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        radius: 26,
        backgroundColor: MyColors.primaryColor,
        child: IconButton(
          splashRadius: 10,
          onPressed: () {
            onPress();
          },
          icon: const Icon(IconlyLight.filter, color: Colors.white),
        ),
      ),
    );
  }
}
