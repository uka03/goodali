import 'dart:developer';

import 'package:flutter/material.dart';

class ForumTagNotifier with ChangeNotifier {
  List<Map<String, dynamic>> _selectedForumNames = [];
  List<Map<String, dynamic>> get selectedForumNames => _selectedForumNames;

  final List<int> _selectedTagId = [];
  List<int> get selectedTagId => _selectedTagId;

  void setTags(Map<String, dynamic> tagName) {
    List<Map<String, dynamic>> tagList = [];
    tagList.add(tagName);
    _selectedTagId.add(tagName["id"]);

    _selectedForumNames = tagList;

    notifyListeners();
  }

  void removeTags(Map<String, dynamic> tagName) {
    _selectedForumNames.remove(tagName);
    _selectedTagId.remove(tagName["id"]);
    log(_selectedForumNames.length.toString(), name: 'removetags');
    notifyListeners();
  }

  void checkedTag(Map<String, dynamic> tagName) {}
}
