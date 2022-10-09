import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/controller/audioplayer_controller.dart';
import 'package:goodali/controller/duration_state.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class AudioProgressBar extends StatelessWidget {
  final Duration savedPosition;
  final Duration? totalDuration;
  final bool? isPlayed;
  const AudioProgressBar(
      {Key? key,
      required this.savedPosition,
      required this.totalDuration,
      this.isPlayed = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      child: ValueListenableBuilder(
        valueListenable: durationStateNotifier,
        builder: (BuildContext context, DurationState value, Widget? child) {
          Duration position = value.progress ?? Duration.zero;
          Duration duration =
              value.total ?? totalDuration ?? const Duration(minutes: 60);

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
                  value: (position.inSeconds.toDouble() / 10))
            ],
          );
        },
      ),
    );
  }
}
