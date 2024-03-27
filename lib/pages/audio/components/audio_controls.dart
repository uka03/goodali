import 'package:flutter/material.dart';
import 'package:goodali/pages/audio/provider/audio_provider.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/utils.dart';
import 'package:just_audio/just_audio.dart';

class AudioControls extends StatelessWidget {
  const AudioControls({
    super.key,
    required this.audioProvider,
    required this.positionData,
  });

  final AudioProvider audioProvider;
  final SeekBarData? positionData;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomButton(
          onPressed: () {
            if (positionData?.duration != null &&
                positionData?.position != null) {
              if (positionData!.position > Duration(seconds: 5)) {
                audioProvider.audioPlayer?.seek(
                  positionData!.position - Duration(seconds: 5),
                );
              }
            }
          },
          child: Container(
            decoration: BoxDecoration(
                color: GoodaliColors.inputColor,
                borderRadius: BorderRadius.circular(50)),
            padding: EdgeInsets.all(15),
            child: Image.asset(
              "assets/icons/ic_replay_5.png",
              width: 30,
              height: 30,
              color: GoodaliColors.blackColor,
              fit: BoxFit.cover,
            ),
          ),
        ),
        HSpacer(size: 20),
        StreamBuilder<PlayerState>(
          stream: audioProvider.audioPlayer?.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                  decoration: BoxDecoration(
                      color: GoodaliColors.primaryColor,
                      borderRadius: BorderRadius.circular(50)),
                  padding: EdgeInsets.all(22),
                  child: CircularProgressIndicator(
                    color: GoodaliColors.whiteColor,
                  ));
            } else if (playing != true) {
              return audioBtn(
                icon: Icons.play_arrow_rounded,
                onPressed: () {
                  audioProvider.setPlayerState(
                      context, GoodaliPlayerState.playing);
                },
              );
            } else if (processingState != ProcessingState.completed) {
              return audioBtn(
                icon: Icons.pause_rounded,
                onPressed: () {
                  audioProvider.setPlayerState(
                      context, GoodaliPlayerState.paused);
                },
              );
            } else {
              audioProvider.setPlayerState(
                  context, GoodaliPlayerState.completed);
              return audioBtn(
                icon: Icons.replay,
                onPressed: () {
                  audioProvider.setPlayerState(
                      context, GoodaliPlayerState.playing);
                  audioProvider.audioPlayer?.seek(
                    Duration.zero,
                    index: audioProvider.audioPlayer?.effectiveIndices!.first,
                  );
                },
              );
            }
          },
        ),
        HSpacer(size: 20),
        CustomButton(
          onPressed: () {
            if (positionData?.duration != null &&
                positionData?.position != null) {
              if (positionData!.duration - Duration(seconds: 15) >
                  positionData!.position) {
                audioProvider.audioPlayer?.seek(
                  positionData!.position + Duration(seconds: 15),
                );
              }
            }
          },
          child: Container(
            decoration: BoxDecoration(
                color: GoodaliColors.inputColor,
                borderRadius: BorderRadius.circular(50)),
            padding: EdgeInsets.all(15),
            child: Image.asset(
              "assets/icons/ic_forward_15.png",
              width: 30,
              height: 30,
              fit: BoxFit.cover,
              color: GoodaliColors.blackColor,
            ),
          ),
        ),
      ],
    );
  }

  CustomButton audioBtn(
      {required IconData icon, required Function() onPressed}) {
    return CustomButton(
      onPressed: onPressed,
      child: Container(
        decoration: BoxDecoration(
            color: GoodaliColors.primaryColor,
            borderRadius: BorderRadius.circular(50)),
        padding: EdgeInsets.all(20),
        child: Icon(
          icon,
          size: 40,
          color: GoodaliColors.whiteColor,
        ),
      ),
    );
  }
}
