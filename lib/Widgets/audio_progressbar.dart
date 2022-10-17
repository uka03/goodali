import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/controller/audioplayer_controller.dart';
import 'package:goodali/controller/duration_state.dart';
import 'package:goodali/controller/pray_button_notifier.dart';
import 'package:goodali/models/products_model.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class AudioProgressBar extends StatelessWidget {
  final Duration totalDuration;
  final Duration savedPostion;
  final String title;
  const AudioProgressBar(
      {Key? key,
      required this.totalDuration,
      required this.savedPostion,
      required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      child: ValueListenableBuilder(
        valueListenable: durationStateNotifier,
        builder: (BuildContext context, DurationState value, Widget? child) {
          Duration position = value.progress ?? Duration.zero;
          Duration duration = totalDuration;
          var playState = buttonNotifier.value;
          bool isPlaying = false;
          if (currentlyPlaying.value != null) {
            isPlaying = currentlyPlaying.value!.title == title;
          }

          return SfLinearGauge(
            minimum: 0,
            maximum: (duration.inSeconds.toDouble() / 10),
            showLabels: false,
            showAxisTrack: false,
            showTicks: false,
            ranges: [
              LinearGaugeRange(
                position: LinearElementPosition.inside,
                edgeStyle: LinearEdgeStyle.bothCurve,
                startValue: 0,
                color: MyColors.border1,
                endValue: (duration.inSeconds.toDouble() / 10),
              ),
            ],
            barPointers: [
              LinearBarPointer(
                  position: LinearElementPosition.inside,
                  edgeStyle: LinearEdgeStyle.bothCurve,
                  color: MyColors.primaryColor,
                  value: (playState == ButtonState.playing && isPlaying
                      ? position.inSeconds.toDouble() / 10
                      : savedPostion.inSeconds.toDouble() / 10))
            ],
          );
        },
      ),
    );
  }
}
