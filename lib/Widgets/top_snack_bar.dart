import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

class CustomTopSnackBar extends StatefulWidget {
  final int type;
  final String? text;
  final String? description;

  //Error  = 0;
  //Success  = 1;
  //Warning  = 2;
  const CustomTopSnackBar(
      {Key? key, required this.type, this.text, this.description})
      : super(key: key);

  @override
  State<CustomTopSnackBar> createState() => _CustomTopSnackBarState();
}

class _CustomTopSnackBarState extends State<CustomTopSnackBar> {
  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case 0:
        return CustomSnackBar.error(
            messagePadding: const EdgeInsets.symmetric(horizontal: 40),
            textStyle: const TextStyle(color: MyColors.black, fontSize: 16),
            iconRotationAngle: 0,
            iconPositionTop: 27,
            iconPositionLeft: 15,
            icon: Container(
              height: 30,
              width: 25,
              decoration: BoxDecoration(
                color: MyColors.error,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 18),
            ),
            backgroundColor: Colors.white,
            message: widget.text ?? "");
      case 1:
        return CustomSnackBar.success(
            messagePadding: const EdgeInsets.symmetric(horizontal: 40),
            iconRotationAngle: 0,
            iconPositionTop: 27,
            iconPositionLeft: 15,
            textStyle: const TextStyle(color: MyColors.black, fontSize: 16),
            icon: Container(
              height: 30,
              width: 25,
              decoration: BoxDecoration(
                color: MyColors.success,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(Icons.done, color: Colors.white, size: 18),
            ),
            backgroundColor: Colors.white,
            message: widget.text ?? "");
      case 2:
        return CustomSnackBar.info(
            messagePadding: const EdgeInsets.symmetric(horizontal: 40),
            iconRotationAngle: 0,
            iconPositionTop: -10,
            iconPositionLeft: 20,
            icon: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: MyColors.secondary,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(Icons.info, color: Colors.white, size: 18),
            ),
            backgroundColor: Colors.white,
            message: widget.text ?? "");

      default:
        return CustomSnackBar.success(
            messagePadding: const EdgeInsets.symmetric(horizontal: 40),
            iconRotationAngle: 0,
            iconPositionTop: -10,
            iconPositionLeft: 20,
            textStyle: const TextStyle(color: MyColors.black, fontSize: 16),
            icon: Container(
              margin: const EdgeInsets.symmetric(vertical: 35, horizontal: 0),
              padding: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: MyColors.success,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(Icons.done, color: Colors.white, size: 18),
            ),
            backgroundColor: Colors.white,
            message: widget.text ?? "");
    }
  }
}
