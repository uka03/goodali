import 'dart:developer';

import 'package:flutter/material.dart';

class ForumTagNotifier with ChangeNotifier {
  List<Map<String, dynamic>> _selectedForumNames = [];
  List<Map<String, dynamic>> get selectedForumNames => _selectedForumNames;

  final List<int> _selectedTagId = [];
  List<int> get selectedTagId => _selectedTagId;

  void setTags(Map<String, dynamic> tagName) {
    // List<Map<String, dynamic>> tagList = _selectedForumNames;
    // tagList.add(tagName);
    _selectedTagId.add(tagName["id"]);

    _selectedForumNames.add(tagName);

    notifyListeners();
  }

  void removeTags(Map<String, dynamic> tagName) {
    log(tagName.toString());
    _selectedForumNames.removeWhere((item) => item['name'] == tagName['name']);

    // int idx = 0;
    // for (var cur in _selectedForumNames) {
    //   if (cur['id'] == tagName['id']) {
    //     _selectedForumNames.removeAt(idx);
    //   }
    //   idx++;
    // }
    _selectedTagId.remove(tagName["id"]);
    log(_selectedForumNames.length.toString(), name: 'removetags');
    log(_selectedForumNames.toString());
    notifyListeners();
  }

  void checkedTag(Map<String, dynamic> tagName) {}
}
