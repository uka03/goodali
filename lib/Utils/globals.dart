import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

final GlobalKey<NavigatorState> appKey = GlobalKey();

showLoader() {
  EasyLoading.show();
}

dismissLoader() {
  EasyLoading.dismiss();
}
