import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  int selectedTab = 0;

  void selectTab(int tab) {
    selectedTab = tab;
    notifyListeners();
  }
}
