import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Utils/utils.dart';
import 'package:goodali/controller/audioplayer_controller.dart';
import 'package:goodali/controller/pray_button_notifier.dart';
import 'package:goodali/controller/progress_notifier.dart';

class AudioplayerTimer extends StatelessWidget {
  final String title;
  final Duration totalDuration;
  final Duration savedDuration;
  final int id;
  const AudioplayerTimer(
      {Key? key,
      required this.title,
      required this.totalDuration,
      required this.savedDuration,
      required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: progressNotifier,
      builder: (context, ProgressBarState value, child) {
        var buttonState = buttonNotifier.value;
        var currently = currentlyPlaying.value;

        Duration duration = savedDuration;
        Duration position = value.current;

        bool isPlaying = currently?.id == id &&
                currently?.title == title &&
                buttonState == ButtonState.playing
            ? true
            : false;

        if (isPlaying) {
          return Text(formatTime(totalDuration - position) + "мин",
              style: const TextStyle(fontSize: 12, color: MyColors.black));
        } else {
          return Text(formatTime(totalDuration - duration) + "мин",
              style: const TextStyle(fontSize: 12, color: MyColors.black));
        }
      },
    );
  }
}
