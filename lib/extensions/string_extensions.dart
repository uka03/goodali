import 'package:goodali/utils/constants.dart';

extension StringExtensions on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }

  bool isValidPassword() {
    return RegExp(
            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
        .hasMatch(this);
  }

  bool isValidUsername() {
    return RegExp(r'^[A-Za-z0-9_.]+$').hasMatch(this);
  }

  bool isValidName() {
    return RegExp(r'^[a-zA-Z-]+$').hasMatch(this);
  }
}

extension NullableStringExtensions on String? {
  String toUrl({bool isUser = false}) {
    if (this == null ||
        this?.isEmpty == true ||
        this == "Image failed to upload") {
      return isUser ? userPlaceholder : placeholder;
    }
    return "$hostUrl$this";
  }

  String orEmpty() {
    switch (this == null) {
      case false:
        return this!;
      default:
        return "";
    }
  }
}
