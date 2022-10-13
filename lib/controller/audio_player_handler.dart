// import 'dart:developer';

// import 'package:audio_service/audio_service.dart';
// import 'package:audio_session/audio_session.dart';
// import 'package:flutter/foundation.dart';
// import 'package:goodali/controller/audioplayer_controller.dart';

// import 'package:goodali/models/products_model.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:rxdart/rxdart.dart';

// class AudioPlayerHandler extends BaseAudioHandler
//     with SeekHandler, QueueHandler {
//   final _player = AudioPlayer();
//   var _queue = <MediaItem>[];
//   final _playlist = ConcatenatingAudioSource(children: []);
//   final currentSong = BehaviorSubject<Products>();
//   List<MediaItem> get queuea => _queue;
//   final _mediaItemExpando = Expando<MediaItem>();

//   AudioPlayerHandler() {
//     AudioSession.instance.then((session) {
//       session.configure(const AudioSessionConfiguration.speech());
//     });
//     _loadEmptyPlaylist();
//     _notifyAudioHandlerAboutPlaybackEvents();
//     // _listenForDurationChanges();
//     // _listenForCurrentSongIndexChanges();
//   }

//   Future<void> _loadEmptyPlaylist() async {
//     try {
//       await _player.setAudioSource(_playlist);
//     } catch (e) {
//       print("Error: $e");
//     }
//   }

//   void _listenForDurationChanges() {
//     _player.durationStream.listen((duration) {
//       var index = _player.currentIndex;

//       log(index.toString(), name: "currently playing index");
//       if (index == null || _queue.isEmpty) return;
//       _queue[index].copyWith(duration: duration);
//       mediaItem.add(_queue[index]);
//       log(_queue[index].title);
//     });
//   }

//   void _notifyAudioHandlerAboutPlaybackEvents() {
//     _player.playbackEventStream.listen((PlaybackEvent event) {
//       final playing = _player.playing;
//       playbackState.add(playbackState.value.copyWith(
//         controls: [
//           MediaControl.skipToPrevious,
//           if (playing) MediaControl.pause else MediaControl.play,
//           MediaControl.stop,
//           MediaControl.skipToNext,
//         ],
//         systemActions: const {
//           MediaAction.seek,
//         },
//         androidCompactActionIndices: const [0, 1, 3],
//         processingState: const {
//           ProcessingState.idle: AudioProcessingState.idle,
//           ProcessingState.loading: AudioProcessingState.loading,
//           ProcessingState.buffering: AudioProcessingState.buffering,
//           ProcessingState.ready: AudioProcessingState.ready,
//           ProcessingState.completed: AudioProcessingState.completed,
//         }[_player.processingState]!,
//         repeatMode: const {
//           LoopMode.off: AudioServiceRepeatMode.none,
//           LoopMode.one: AudioServiceRepeatMode.one,
//           LoopMode.all: AudioServiceRepeatMode.all,
//         }[_player.loopMode]!,
//         playing: playing,
//         updatePosition: _player.position,
//         bufferedPosition: _player.bufferedPosition,
//         speed: _player.speed,
//         queueIndex: event.currentIndex,
//       ));
//     });
//   }

//   @override
//   Future<void> play() async {
//     debugPrint("audio handler play");

//     _player.play();
//     return super.play();
//   }

//   @override
//   Future<void> skipToQueueItem(int index) async {
//     log(index.toString(), name: "Index");
//     final newIndex = _queue.indexWhere((item) => item.id == index.toString());
//     log(newIndex.toString(), name: "newIndex");
//     log(_queue[1].id.toString(), name: "_queue.length");
//     if (newIndex == -1) return;
//     mediaItem.add(_queue[newIndex]);
//     log(_queue[newIndex].title, name: "title");
//     _player.setUrl(_queue[newIndex].extras!['url']);
//   }

//   @override
//   Future<void> playMediaItem(MediaItem item) async {
//     debugPrint("play media item");
//     mediaItem.add(item);
//     if (item.extras!['saved_position'] > 0) {
//       _player.seek(Duration(seconds: item.extras!['saved_position']));
//     }
//     _player.setUrl(item.extras!['url']);
//   }

//   @override
//   Future<void> updateQueue(List<MediaItem> newQueue) async {
//     queue.add(_queue = newQueue);

//     await _player.setAudioSource(ConcatenatingAudioSource(
//         children: newQueue
//             .map((e) => AudioSource.uri(Uri.parse(e.extras!['url'])))
//             .toList()));
//   }

//   @override
//   Future<void> addQueueItems(List<MediaItem> mediaItems) {
//     final audioSource = mediaItems.map(_createAudioSource);
//     _playlist.addAll(audioSource.toList());

//     _playlist.clear();
//     _queue.clear();
//     final newQueue = queue.value..addAll(mediaItems);
//     queue.add(_queue = newQueue);
//     log(_queue.length.toString(), name: "title");
//     return super.addQueueItems(mediaItems);
//   }

//   @override
//   Future<void> pause() async {
//     _player.pause();
//     return super.pause();
//   }

//   UriAudioSource _createAudioSource(MediaItem mediaItem) {
//     return AudioSource.uri(
//       Uri.parse(mediaItem.extras!['url']),
//       tag: mediaItem,
//     );
//   }

//   @override
//   Future<void> seek(Duration position) {
//     _player.seek(position);
//     return super.pause();
//   }

//   @override
//   Future<void> skipToNext() => _player.seekToNext();

//   @override
//   Future<void> skipToPrevious() => _player.seekToPrevious();

//   @override
//   Future customAction(String name, [Map<String, dynamic>? extras]) async {
//     if (name == 'dispose') {
//       await _player.dispose();
//       super.stop();
//     }
//   }

//   @override
//   Future<void> stop() async {
//     await _player.stop();
//     return super.stop();
//   }
// }
