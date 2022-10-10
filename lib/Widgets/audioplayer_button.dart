import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/controller/audioplayer_controller.dart';
import 'package:goodali/controller/pray_button_notifier.dart';
import 'package:goodali/models/products_model.dart';

class AudioPlayerButton extends StatelessWidget {
  final String title;
  final Function onPlay;
  final Function onPause;
  const AudioPlayerButton(
      {Key? key,
      required this.title,
      required this.onPlay,
      required this.onPause})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: currentlyPlaying,
      builder: (BuildContext context, Products? value, Widget? child) {
        var buttonState = buttonNotifier.value;
        var currentTitle = value?.title ?? value?.lectureTitle ?? "";
        log(currentTitle);
        bool isPlaying =
            currentTitle == title && buttonState == ButtonState.playing
                ? true
                : false;

        if (!isPlaying) {
          return CircleAvatar(
              backgroundColor: MyColors.input,
              child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.black,
                    size: 30.0,
                  ),
                  onPressed: () {
                    onPlay();
                  }));
        } else if (buttonState == ButtonState.loading) {
          return const CircleAvatar(
              backgroundColor: MyColors.input,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 2,
                ),
              ));
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
