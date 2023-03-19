import 'package:flutter/material.dart';
import 'package:goodali/controller/audioplayer_controller.dart';
import 'package:goodali/controller/default_audio_handler.dart';
import 'package:goodali/controller/pray_button_notifier.dart';

class PlayerButtons extends StatelessWidget {
  final String title;
  const PlayerButtons({Key? key, required this.title}) : super(key: key);

  Future<void> updateSavedPosition() async {
    var item = currentlyPlaying.value;

    if (item != null) {
      if (item.title == title) {}
      item.position = durationStateNotifier.value.progress!.inMilliseconds;

      return item.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: buttonNotifier,
      builder: (BuildContext context, ButtonState? buttonValue, Widget? widget) {
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
              onPressed: () async {
                audioHandler.pause();
                try {
                  await updateSavedPosition();
                } catch (e) {
                  debugPrint(e.toString());
                }
              },
            );
          default:
            return Container();
        }
      },
    );
  }
}
