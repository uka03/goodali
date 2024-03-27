import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:goodali/pages/auth/components/numeric_keyboard.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';

class RecoveryConfirm extends StatefulWidget {
  const RecoveryConfirm({
    super.key,
    required this.onleading,
    required this.onCompleted,
    this.bottomAction,
    required this.title,
    this.description,
  });
  final Function() onleading;
  final Widget? bottomAction;
  final String title;
  final String? description;
  final Function(String) onCompleted;

  @override
  State<RecoveryConfirm> createState() => _RecoveryConfirmState();
}

class _RecoveryConfirmState extends State<RecoveryConfirm> {
  String pinValue = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GoodaliColors.primaryBGColor,
      body: Column(
        children: [
          VSpacer.sm(),
          Align(
            alignment: Alignment.centerLeft,
            child: CustomButton(
              onPressed: widget.onleading,
              child: Image.asset(
                "assets/icons/ic_arrow_left.png",
                width: 30,
                height: 30,
              ),
            ),
          ),
          VSpacer(size: 50),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      widget.title,
                      style: GoodaliTextStyles.titleText(
                        context,
                        fontSize: 24,
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
                      itemSize: 56,
                      unratedColor: GoodaliColors.inputColor,
                      ignoreGestures: true,
                      initialRating: pinValue.length.toDouble(),
                      itemPadding: EdgeInsets.all(8),
                      onRatingUpdate: (value) {},
                      itemBuilder: (context, index) {
                        String? number;
                        if (pinValue.length > index) {
                          number = pinValue[index];
                        }
                        return Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: GoodaliColors.inputColor,
                            borderRadius: BorderRadius.circular(80),
                          ),
                          child: Center(
                              child: Text(
                            number ?? "",
                            style: GoodaliTextStyles.titleText(
                              context,
                              fontSize: 24,
                            ),
                          )),
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
