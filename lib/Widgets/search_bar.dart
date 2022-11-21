import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/screens/Auth/search_screen.dart';
import 'package:iconly/iconly.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchBar extends StatelessWidget {
  final String? title;
  const SearchBar({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color: MyColors.input,
      ),
      child: Row(
        children: [
          const Icon(IconlyLight.search, color: MyColors.gray),
          const SizedBox(width: 14),
          SizedBox(
            width: 200,
            child: TextField(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                _showSearch(context);
              },
              readOnly: true,
              cursorColor: MyColors.primaryColor,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: title ?? "Хайх..."),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showSearch(BuildContext context) async {
    final searchText = await showSearch<String>(
      context: context,
      delegate: SearchScreen(
        onSearchChanged: _getRecentSearchesLike,
      ),
    );
    await _saveToRecentSearches(searchText ?? "");
  }

  Future<List<String>> _getRecentSearchesLike(String query) async {
    final pref = await SharedPreferences.getInstance();
    final allSearches = pref.getStringList("recentSearches");
    return allSearches?.where((search) => search.startsWith(query)).toList() ??
        [];
  }

  Future<void> _saveToRecentSearches(String? searchText) async {
    if (searchText == null || searchText == "") return;
    final pref = await SharedPreferences.getInstance();

    Set<String> allSearches =
        pref.getStringList("recentSearches")?.toSet() ?? {};

    allSearches = {searchText, ...allSearches};
    pref.setStringList("recentSearches", allSearches.toList());
  }
}
