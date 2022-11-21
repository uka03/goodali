import 'dart:developer';

import 'package:flutter/material.dart';

class ForumTagNotifier with ChangeNotifier {
  List<Map<String, dynamic>> _selectedForumNames = [];
  List<Map<String, dynamic>> get selectedForumNames => _selectedForumNames;

  void setTags(List<Map<String, dynamic>> tagName) {
    List<Map<String, dynamic>> tagList = [
      ...{...tagName}
    ];

    _selectedForumNames = tagList;
    log(_selectedForumNames.length.toString(), name: 'setTags');
    notifyListeners();
  }

  void removeTags(Map<String, dynamic> tagName) {
    _selectedForumNames.remove(tagName);

    log(_selectedForumNames.length.toString(), name: 'removetags');
    notifyListeners();
  }

  void checkedTag(Map<String, dynamic> tagName) {}
}
