import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:goodali/controller/audioplayer_controller.dart';
import 'package:goodali/controller/pray_button_notifier.dart';
import 'package:goodali/models/products_model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

Future<AudioHandler> initAudioService() async {
  return await AudioService.init(
    builder: () => AudioPlayerHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.goodali.goodali.audio',
      androidNotificationChannelName: 'Audio Service',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );
}

class AudioPlayerHandler extends BaseAudioHandler
    with SeekHandler, QueueHandler {
  final _player = AudioPlayer();
  final _playlist = ConcatenatingAudioSource(children: []);
  final currentSong = BehaviorSubject<Products>();

  AudioPlayerHandler() {
    AudioSession.instance.then((session) {
      session.configure(const AudioSessionConfiguration.speech());
    });
    _loadEmptyPlaylist();
    _notifyAudioHandlerAboutPlaybackEvents();
  }

  Future<void> _loadEmptyPlaylist() async {
    try {
      await _player.setAudioSource(_playlist);
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    }
  }

  void _notifyAudioHandlerAboutPlaybackEvents() {
    _player.playbackEventStream.listen((PlaybackEvent event) {
      final playing = _player.playing;
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
        },
        androidCompactActionIndices: const [0, 1, 3],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_player.processingState]!,
        repeatMode: const {
          LoopMode.off: AudioServiceRepeatMode.none,
          LoopMode.one: AudioServiceRepeatMode.one,
          LoopMode.all: AudioServiceRepeatMode.all,
        }[_player.loopMode]!,
        playing: playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
        queueIndex: event.currentIndex,
      ));
    });
  }

  MediaItem toMediaItem(Products audioItem) => MediaItem(
        id: audioItem.audio ?? "",
        title: audioItem.title ?? audioItem.name ?? "",
        artUri: Uri.parse(audioItem.banner ?? ""),
      );

  @override
  Future<void> play() async {
    debugPrint("audio handler play");

    _player.play();
    return super.play();
  }

  @override
  Future<void> playMediaItem(MediaItem item) async {
    mediaItem.add(item);
    _player.setUrl(
      item.id,
      initialPosition: item.extras?['position'] != Duration.zero
          ? Duration(microseconds: (item.extras?['position'] * 1000).toInt())
          : Duration.zero,
    );
    // await _player.setAudioSource(
    //   AudioSource.uri(Uri.parse(item.id)),
    //   initialPosition: item.extras?['position'] != Duration.zero
    //       ? Duration(milliseconds: item.extras?['position'])
    //       : Duration.zero,
    // );
    // if (item.extras?['isDownloaded'] == true) {
    //   _player.setFilePath(item.id,
    //       initialPosition: item.extras?['position'] != Duration.zero
    //           ? Duration(
    //               microseconds: (item.extras?['position'] * 1000).toInt())
    //           : Duration.zero,
    //       preload: false);
    // } else {

    // }
  }

  UriAudioSource _createAudioSource(MediaItem mediaItem) {
    if (mediaItem.extras?['isDownloaded'] == true) {
      return AudioSource.uri(
        Uri.file(mediaItem.id),
        tag: mediaItem,
      );
    } else {
      return AudioSource.uri(
        Uri.parse(mediaItem.id),
        tag: mediaItem,
      );
    }
  }

  @override
  Future<void> pause() async {
    buttonNotifier.value = ButtonState.paused;
    _player.pause();
    return super.pause();
  }

  @override
  Future<void> seek(Duration position) {
    _player.seek(position);
    return super.pause();
  }

  @override
  Future<void> skipToNext() => _player.seekToNext();

  @override
  Future<void> skipToPrevious() => _player.seekToPrevious();

  @override
  Future customAction(String name, [Map<String, dynamic>? extras]) async {
    if (name == 'dispose') {
      await _player.dispose();
      super.stop();
    }
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    return super.stop();
  }
}
