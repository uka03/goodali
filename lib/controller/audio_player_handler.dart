import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:goodali/controller/audioplayer_controller.dart';
import 'package:goodali/controller/pray_button_notifier.dart';
import 'package:goodali/models/audio_player_model.dart';
import 'package:goodali/models/products_model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class AudioPlayerHandler extends BaseAudioHandler
    with SeekHandler, QueueHandler {
  final _player = AudioPlayer();
  var _queue = <MediaItem>[];
  final _playlist = ConcatenatingAudioSource(children: []);
  final currentSong = BehaviorSubject<Products>();
  List<MediaItem> get queuea => _queue;

  AudioPlayerHandler() {
    AudioSession.instance.then((session) {
      session.configure(const AudioSessionConfiguration.speech());
    });

    _loadEmptyPlaylist();
    _notifyAudioHandlerAboutPlaybackEvents();
    // _listenForSequenceStateChanges();
  }

  Future<void> _loadEmptyPlaylist() async {
    try {
      // print("dfjnodfnodnfndonfodnfn");
      // await _player.setAudioSource(_playlist);
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

  void _listenForSequenceStateChanges() {
    _player.sequenceStateStream.listen((SequenceState? sequenceState) {
      final sequence = sequenceState?.effectiveSequence;
      if (sequence == null || sequence.isEmpty) return;
      final items = sequence.map((source) => source.tag as MediaItem);
      queue.add(items.toList());
    });
  }

  @override
  Future<void> play() async {
    debugPrint("audio handler play");

    _player.play();
    return super.play();
  }

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index < 0 || index >= queue.value.length) return;

    log(index.toString(), name: "index");
    log(_queue[index].extras!['audioUrl'].toString(), name: "audioUrl");

    AudioPlayerController().getSavedPosition(_queue[index]).then((value) {
      log(value.toString(), name: "savedposition");
      _player.seek(Duration.zero, index: index);
    });
  }

  @override
  Future<void> updateQueue(List<MediaItem> newQueue) async {
    queue.add(_queue = newQueue);

    log(queuea.length.toString());
    await _player.setAudioSource(ConcatenatingAudioSource(
      children: queuea
          .map((item) => AudioSource.uri(Uri.parse(item.extras!['audioUrl'])))
          .toList(),
    ));
    return super.updateQueue(newQueue);
  }

  @override
  Future<void> playMediaItem(MediaItem item) {
    mediaItem.add(item);

    AudioPlayerController().getSavedPosition(item).then((value) {
      log(value.toString(), name: "savedposition");
      _player.setUrl(item.extras!['audioUrl'],
          initialPosition: Duration(milliseconds: value));
    });
    return super.playMediaItem(item);
  }

  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {
    final audioSource = _createAudioSource(mediaItem);
    _playlist.add(audioSource);

    final newQueue = queue.value..add(mediaItem);
    queue.add(newQueue);

    await _player.setAudioSource(_playlist);

    log(newQueue.length.toString());
  }

  UriAudioSource _createAudioSource(MediaItem mediaItem) {
    return AudioSource.uri(
      Uri.parse(mediaItem.extras!['audioUrl']),
      tag: mediaItem,
    );
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    final audioSource = mediaItems.map(_createAudioSource);
    _playlist.addAll(audioSource.toList());
    log(_playlist.length.toString(), name: "playlist lenght");

    final newQueue = queue.value..addAll(mediaItems);
    queue.add(_queue = newQueue);
    log(queuea.length.toString(), name: "queue lenght");
  }

  @override
  Future<void> pause() async {
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
