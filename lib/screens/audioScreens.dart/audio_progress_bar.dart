import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:goodali/Providers/audio_provider.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/controller/duration_state.dart';
import 'package:goodali/main.dart';
import 'package:goodali/models/audio_player_model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

class AudioProgressBar extends StatelessWidget {
  final Stream<DurationState> durationState;
  final int productID;
  final AudioPlayerProvider? audioPosition;
  final bool? isChinese;
  final AudioPlayer? audioPlayer;
  const AudioProgressBar(
      {Key? key,
      required this.durationState,
      required this.productID,
      this.audioPosition,
      this.isChinese = false,
      this.audioPlayer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DurationState>(
        stream: durationState,
        builder: (context, snapshot) {
          final durationState = snapshot.data;
          final position = durationState?.progress ?? Duration.zero;
          final buffered = durationState?.buffered ?? Duration.zero;
          final duration = durationState?.total ?? Duration.zero;

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
            onSeek: (duration) async {
              if (isChinese == true) {
                await audioPlayer?.seek(duration);
                await audioPlayer?.play();
              } else {
                await audioHandler.seek(duration);
                await audioHandler.play();
              }

              AudioPlayerModel _audio = AudioPlayerModel(
                  productID: productID, audioPosition: position.inMilliseconds);
              audioPosition?.addAudioPosition(_audio);
            },
          );
        });
  }
}
