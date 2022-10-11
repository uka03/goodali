import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:goodali/controller/audioplayer_controller.dart';

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
  final _mediaItemExpando = Expando<MediaItem>();

  AudioPlayerHandler() {
    AudioSession.instance.then((session) {
      session.configure(const AudioSessionConfiguration.speech());
    });

    _loadEmptyPlaylist();
    _notifyAudioHandlerAboutPlaybackEvents();
    _listenForDurationChanges();
    // _listenForCurrentSongIndexChanges();
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

  void _listenForDurationChanges() {
    _player.durationStream.listen((duration) {
      var index = _player.currentIndex;

      log(index.toString(), name: "currently playing index");
      if (index == null || _queue.isEmpty) return;
      _queue[index].copyWith(duration: duration);
      mediaItem.add(_queue[index]);
      log(_queue[index].title);
    });
  }

  void _listenForCurrentSongIndexChanges() {
    _player.currentIndexStream.listen((index) {
      final playlist = queue.value;
      log(playlist.length.toString(), name: "hduf");
      log(index.toString(), name: "currentlyindex");
      if (index == null || _queue.isEmpty) return;
      mediaItem.add(playlist[index]);
    });
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

  @override
  Future<void> play() async {
    debugPrint("audio handler play");

    _player.play();
    return super.play();
  }

  @override
  Future<void> skipToQueueItem(int index) async {
    // log(queue.value.length.toString(), name: "queue.value");
    // if (index < 0 || index >= queue.value.length) return;

    // log(index.toString(), name: "index");
    // log(_queue[index].extras!['url'].toString(), name: "url");

    // _player.seek(Duration(seconds: savedPosition), index: index);
    // return super.skipToQueueItem(index);
  }

  @override
  Future<void> playFromMediaId(String mediaId, [Map<String, dynamic>? extras]) {
    if (extras!['saved_position'] > 0) {
      _player.seek(extras['saved_position']);
    }
    return super.playFromMediaId(mediaId, extras);
  }

  @override
  Future<void> updateQueue(List<MediaItem> newQueue) async {
    log(newQueue.length.toString(), name: "newQueue");
    queue.add(_queue = newQueue);
    await _playlist.clear();
    await _playlist.addAll(_itemsToSources(newQueue));
  }

  List<AudioSource> _itemsToSources(List<MediaItem> mediaItems) =>
      mediaItems.map(_itemToSource).toList();

  AudioSource _itemToSource(MediaItem mediaItem) {
    final audioSource = AudioSource.uri(Uri.parse(mediaItem.extras!['url']));
    _mediaItemExpando[audioSource] = mediaItem;
    return audioSource;
  }

  UriAudioSource _createAudioSource(MediaItem mediaItem) {
    return AudioSource.uri(
      Uri.parse(mediaItem.extras!['audioUrl']),
      tag: mediaItem,
    );
  }

  @override
  Future<void> playMediaItem(MediaItem item) {
    mediaItem.add(item);
    if (item.extras!['saved_position'] > 0) {
      _player.seek(Duration(seconds: item.extras!['saved_position']));
    }
    return super.playMediaItem(item);
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    final audioSource = mediaItems.map(_createAudioSource);
    _playlist.addAll(audioSource.toList());

    final newQueue = queue.value..addAll(mediaItems);
    queue.add(_queue = newQueue);
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
