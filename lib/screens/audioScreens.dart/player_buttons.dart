import 'package:flutter/material.dart';
import 'package:goodali/Providers/audio_provider.dart';
import 'package:goodali/controller/audioplayer_controller.dart';
import 'package:goodali/controller/pray_button_notifier.dart';
import 'package:goodali/main.dart';
import 'package:goodali/models/audio_player_model.dart';
import 'package:goodali/models/products_model.dart';
import 'package:provider/provider.dart';

class PlayerButtons extends StatelessWidget {
  const PlayerButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioPosition =
        Provider.of<AudioPlayerProvider>(context, listen: false);
    return ValueListenableBuilder(
      valueListenable: buttonNotifier,
      builder:
          (BuildContext context, ButtonState? buttonValue, Widget? widget) {
        Products? currentlyPlay = currentlyPlaying.value;
        final position = durationStateNotifier.value.progress;
        switch (buttonValue) {
          case ButtonState.loading:
            return const CircularProgressIndicator(color: Colors.white);
          case ButtonState.paused:
            return IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 40.0,
              ),
              onPressed: () {
                audioHandler.play();
              },
            );
          case ButtonState.playing:
            return IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.pause_rounded,
                color: Colors.white,
                size: 40.0,
              ),
              onPressed: () {
                AudioPlayerModel _audio = AudioPlayerModel(
                    productID: currentlyPlay?.id ?? 0,
                    audioPosition: position?.inMilliseconds ?? 0);
                audioPosition.addAudioPosition(_audio);
                audioHandler.pause();
              },
            );
          default:
            return Container();
        }
      },
    );
  }
}
