import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Utils/utils.dart';
import 'package:goodali/controller/audioplayer_controller.dart';
import 'package:goodali/controller/duration_state.dart';
import 'package:goodali/controller/pray_button_notifier.dart';

class AudioplayerTimer extends StatelessWidget {
  final Duration savedPosition;
  final Duration leftPosition;
  final String title;

  const AudioplayerTimer(
      {Key? key,
      required this.savedPosition,
      required this.leftPosition,
      required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: durationStateNotifier,
      builder: (context, DurationState value, child) {
        var buttonState = buttonNotifier.value;
        var currently = currentlyPlaying.value;

        Duration duration = value.total ?? leftPosition;
        Duration position = value.progress ?? Duration.zero;

        bool isPlaying =
            currently?.title == title && buttonState == ButtonState.playing
                ? true
                : false;

        if (isPlaying) {
          return Text(formatTime(duration - position) + "мин",
              style: const TextStyle(fontSize: 12, color: MyColors.black));
        } else {
          return Text(formatTime(leftPosition) + "мин",
              style: const TextStyle(fontSize: 12, color: MyColors.black));
        }
      },
    );
  }
}
