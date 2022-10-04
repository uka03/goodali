import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:goodali/Utils/constans.dart';
import 'package:goodali/Utils/urls.dart';
import 'package:goodali/controller/duration_state.dart';
import 'package:goodali/controller/pray_button_notifier.dart';
import 'package:goodali/main.dart';
import 'package:goodali/models/podcast_list_model.dart';
import 'package:just_audio/just_audio.dart';

final currentlyPlaying = ValueNotifier<PodcastListModel?>(null);

final playerExpandProgress = ValueNotifier<double>(playerMinHeight);
final currentPlayingItem =
    ValueNotifier<MediaItem>(MediaItem(id: "", title: ''));

final durationStateNotifier = ValueNotifier<DurationState>(const DurationState(
  progress: Duration.zero,
  buffered: Duration.zero,
  total: Duration.zero,
));
final buttonNotifier = ValueNotifier<ButtonState>(ButtonState.paused);

class AudioPlayerController with ChangeNotifier {
  AudioPlayerController() {
    initiliaze();
    // _loadPlaylist(podcastList);
  }

  Future<void> _loadPlaylist(List<PodcastListModel>? podcastList) async {
    print("dkndjffjfd");
    final playlist = podcastList;
    final mediaItems = playlist
        ?.map((song) => MediaItem(
            id: Urls.networkPath + (song.audio ?? ''),
            title: song.title ?? '',
            artUri: Uri.parse(Urls.networkPath + (song.banner ?? ''))))
        .toList();
  }

  initiliaze() {
    audioHandler.playbackState.listen((event) {
      final isPlaying = event.playing;

      final processingState = event.processingState;
      if (processingState == AudioProcessingState.loading ||
          processingState == AudioProcessingState.buffering) {
        buttonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        buttonNotifier.value = ButtonState.paused;
      } else if (processingState != AudioProcessingState.completed) {
        buttonNotifier.value = ButtonState.playing;
      } else {
        audioHandler.seek(Duration.zero);
        audioHandler.pause();
      }
    });

    audioHandler.playbackState.listen((event) {
      print(event.position);
      final oldState = durationStateNotifier.value;
      durationStateNotifier.value = DurationState(
        progress: event.position,
        buffered: event.bufferedPosition,
        total: oldState.total,
      );
      durationStateNotifier.notifyListeners();
    });

    audioHandler.mediaItem.listen((event) {
      print("bufferedPosition ${event?.duration}");
      print("title ${event?.duration}");
      final oldState = durationStateNotifier.value;
      durationStateNotifier.value = DurationState(
        progress: oldState.progress,
        buffered: oldState.buffered,
        total: event?.duration ?? Duration.zero,
      );
      durationStateNotifier.notifyListeners();
    });

    audioHandler.mediaItem.listen((event) {
      currentPlayingItem.value = event ?? MediaItem(id: "", title: "");
    });

    //   audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
    //     final oldState = durationStateNotifier.value;
    //     durationStateNotifier.value = DurationState(
    //       progress: oldState.progress,
    //       buffered: bufferedPosition,
    //       total: oldState.total,
    //     );
    //     durationStateNotifier.notifyListeners();
    //   });

    //   audioPlayer.durationStream.listen((totalDuration) {
    //     final oldState = durationStateNotifier.value;
    //     durationStateNotifier.value = DurationState(
    //       progress: oldState.progress,
    //       buffered: oldState.buffered,
    //       total: totalDuration,
    //     );
    //     durationStateNotifier.notifyListeners();
    //   });
    // }
  }

  void play() => audioHandler.play();
  void pause() => audioHandler.pause();

  void seek(Duration position) => audioHandler.seek(position);
}
