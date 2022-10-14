import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/controller/audioplayer_controller.dart';
import 'package:goodali/controller/default_audio_handler.dart';
import 'package:goodali/controller/duration_state.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

class PlayerProgressBar extends StatelessWidget {
  const PlayerProgressBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DurationState>(
        valueListenable: durationStateNotifier,
        builder: (context, durationValue, widget) {
          final position = durationValue.progress ?? Duration.zero;
          final buffered = durationValue.buffered ?? Duration.zero;
          final duration = durationValue.total ?? Duration.zero;

          return ProgressBar(
            progress: position,
            buffered: buffered,
            total: duration,
            thumbColor: MyColors.primaryColor,
            thumbGlowColor: MyColors.primaryColor,
            timeLabelTextStyle: const TextStyle(color: MyColors.gray),
            progressBarColor: MyColors.primaryColor,
            bufferedBarColor: MyColors.primaryColor.withOpacity(0.3),
            baseBarColor: MyColors.border1,
            onSeek: (duration) {
              audioHandler.seek(duration);
              audioHandler.play();
            },
          );
        });
  }
}
