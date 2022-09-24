import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/screens/Auth/search_screen.dart';
import 'package:iconly/iconly.dart';

class SearchBar extends StatelessWidget {
  final String? title;
  const SearchBar({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(18),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color: MyColors.input,
      ),
      child: Row(
        children: [
          const Icon(IconlyLight.search),
          const SizedBox(width: 14),
          SizedBox(
            width: 200,
            child: TextField(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();

                showSearch(context: context, delegate: SearchScreen());
              },
              cursorColor: MyColors.primaryColor,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: title ?? "Хайх..."),
            ),
          ),
        ],
      ),
    );
  }
}
