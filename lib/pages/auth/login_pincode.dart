import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:goodali/pages/auth/components/numeric_keyboard.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';

class Pincode extends StatefulWidget {
  const Pincode({
    super.key,
    required this.onleading,
    required this.onCompleted,
    this.bottomAction,
    required this.title,
    this.description,
    required this.withLeading,
  });
  final Function() onleading;
  final Widget? bottomAction;
  final String title;
  final String? description;
  final bool withLeading;
  final Function(String) onCompleted;

  @override
  State<Pincode> createState() => _PincodeState();
}

class _PincodeState extends State<Pincode> {
  String pinValue = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GoodaliColors.primaryBGColor,
      body: Column(
        children: [
          VSpacer.sm(),
          widget.withLeading
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: CustomButton(
                    onPressed: widget.onleading,
                    child: Image.asset(
                      "assets/icons/ic_arrow_left.png",
                      width: 30,
                      height: 30,
                    ),
                  ),
                )
              : SizedBox(),
          VSpacer(size: 50),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Center(
                      child: Text(
                        widget.title,
                        style: GoodaliTextStyles.titleText(
                          context,
                          fontSize: 24,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    widget.description?.isNotEmpty == true
                        ? VSpacer()
                        : SizedBox(),
                    widget.description?.isNotEmpty == true
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 50.0),
                            child: Text(
                              widget.description ?? "",
                              style: GoodaliTextStyles.bodyText(context),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : SizedBox(),
                    VSpacer(size: 40),
                    RatingBar.builder(
                      itemCount: 4,
                      itemSize: 12,
                      ignoreGestures: true,
                      initialRating: pinValue.length.toDouble(),
                      itemPadding: EdgeInsets.all(15),
                      onRatingUpdate: (value) {},
                      itemBuilder: (context, index) {
                        return Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            color: GoodaliColors.primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Column(
                  children: [
                    NumericKeyboard(
                      onKeyboardTab: (String value) {
                        if (pinValue.length < 4) {
                          setState(() {
                            pinValue = pinValue + value;
                          });
                        }
                        if (pinValue.length == 4) {
                          widget.onCompleted(pinValue);
                        }
                      },
                      deleteButton: () {
                        if (pinValue.isNotEmpty == true) {
                          setState(() {
                            pinValue =
                                pinValue.substring(0, pinValue.length - 1);
                          });
                        }
                      },
                    ),
                    widget.bottomAction ?? SizedBox()
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
