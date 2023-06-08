
import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/controller/audioplayer_controller.dart';
import 'package:goodali/controller/default_audio_handler.dart';
import 'package:goodali/controller/pray_button_notifier.dart';
import 'package:goodali/models/products_model.dart';

class AudioPlayerButton extends StatelessWidget {
  final String title;
  final int id;
  final VoidCallback onPlay;
  final VoidCallback onPause;
  const AudioPlayerButton(
      {Key? key,
      required this.title,
      required this.onPlay,
      required this.onPause,
      required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: buttonNotifier,
      builder: (BuildContext context, ButtonState? buttonValue, Widget? child) {
        Products? currentlyPlay = currentlyPlaying.value;
        var currentTitle =
            currentlyPlay?.title ?? currentlyPlay?.lectureTitle ?? "";
        var currentID = currentlyPlay?.id ?? currentlyPlay?.id ?? "";
        bool isPlaying = currentID == id &&
                currentTitle == title &&
                buttonValue == ButtonState.playing
            ? true
            : false;
        bool isBuffering =
            currentTitle == title && buttonValue == ButtonState.loading
                ? true
                : false;

        if (isBuffering) {
          return const CircleAvatar(
              backgroundColor: MyColors.input,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 2,
                ),
              ));
        } else if (!isPlaying) {
          return CircleAvatar(
              backgroundColor: MyColors.input,
              child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.black,
                    size: 30.0,
                  ),
                  onPressed: () async {
                    if (currentTitle == title &&
                        buttonValue == ButtonState.paused) {
                      audioHandler.play();
                    } else {
                      onPlay();
                    }
                  }));
        } else {
          return CircleAvatar(
            backgroundColor: MyColors.input,
            child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.pause_rounded,
                  color: Colors.black,
                  size: 30.0,
                ),
                onPressed: () {
                  onPause();
                }),
          );
        }
      },
    );
  }
}
