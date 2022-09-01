import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:goodali/controller/playlist_reposetory.dart';
import 'package:goodali/controller/pray_button_notifier.dart';
import 'package:goodali/controller/progress_notifier.dart';
import 'package:goodali/controller/service_locator.dart';
import 'package:goodali/models/products_model.dart';
import 'package:just_audio/just_audio.dart';

class PageManager {
  final _audioHandler = getIt<AudioHandler>();

  void init(List<Products> productsList) async {
    await _loadPlaylist(productsList);
    _listenToPlaybackState();
    _listenToCurrentPosition();
    _listenToBufferedPosition();
    _listenToTotalDuration();
  }

  Future<void> _loadPlaylist(List<Products> productsList) async {
    print("load songs");
    final songRepository = getIt<PlaylistRepository>();
    final playlist = await songRepository.fetchInitialPlaylist(productsList);

    // _audioHandler.addQueueItems(mediaItems);
  }

  // Listeners: Updates going to the UI
  final progressNotifier = ProgressNotifier();
  final isFirstSongNotifier = ValueNotifier<bool>(true);
  final playButtonNotifier = PlayButtonNotifier();

  void play() => _audioHandler.play();
  void pause() => _audioHandler.pause();
  void seek(Duration position) => _audioHandler.seek(position);

  void _listenToPlaybackState() {
    _audioHandler.playbackState.listen((playbackState) {
      final isPlaying = playbackState.playing;
      final processingState = playbackState.processingState;
      if (processingState == AudioProcessingState.loading ||
          processingState == AudioProcessingState.buffering) {
        playButtonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        playButtonNotifier.value = ButtonState.paused;
      } else if (processingState != AudioProcessingState.completed) {
        playButtonNotifier.value = ButtonState.playing;
      } else {
        _audioHandler.seek(Duration.zero);
        _audioHandler.pause();
      }
    });
  }

  void _listenToCurrentPosition() {
    AudioService.position.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });
  }

  void _listenToBufferedPosition() {
    _audioHandler.playbackState.listen((playbackState) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: playbackState.bufferedPosition,
        total: oldState.total,
      );
    });
  }

  void _listenToTotalDuration() {
    _audioHandler.mediaItem.listen((mediaItem) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: mediaItem?.duration ?? Duration.zero,
      );
    });
  }

  void dispose() {
    _audioHandler.customAction('dispose');
  }

  void stop() {
    _audioHandler.stop();
  }
}
