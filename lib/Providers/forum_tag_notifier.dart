import 'dart:developer';

import 'package:flutter/material.dart';

class ForumTagNotifier with ChangeNotifier {
  List<String> _selectedForumNames = [];
  List<String> get selectedForumNames => _selectedForumNames;

  void setTags(List<String> tagName) {
    List<String> tagList = [
      ...{...tagName}
    ];

    _selectedForumNames = tagList;
    log(_selectedForumNames.length.toString(), name: 'setTags');
    notifyListeners();
  }

  void removeTags(String tagName) {
    _selectedForumNames.remove(tagName);

    log(_selectedForumNames.length.toString(), name: 'removetags');
    notifyListeners();
  }
}
