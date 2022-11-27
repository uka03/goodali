import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:goodali/controller/audioplayer_controller.dart';

import 'package:goodali/controller/progress_notifier.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

import '../Providers/local_database.dart';

late AudioHandler audioHandler;
final HiveDataStore dataStore = HiveDataStore();
final HiveBoughtDataStore dataAlbumStore = HiveBoughtDataStore();
final HiveMoodDataStore dataMoodStore = HiveMoodDataStore();
final HiveIntroDataStore dataIntroStore = HiveIntroDataStore();
Future<void> initAudioHandler() async => audioHandler = await AudioService.init(
      builder: () => AudioPlayerHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.ryanheise.myapp.channel.audio',
        androidNotificationChannelName: 'Audio playback',
        androidNotificationOngoing: true,
        androidNotificationIcon: 'mipmap/ic_launcher_round',
        androidStopForegroundOnPause: true,
      ),
    );

/// An [AudioHandler] for playing a single item.
class AudioPlayerHandler extends BaseAudioHandler
    with QueueHandler, SeekHandler {
  final _player = AudioPlayer();

  @override
  final BehaviorSubject<double> speed = BehaviorSubject.seeded(1.0);
  final BehaviorSubject<List<MediaItem>> _recentSubject =
      BehaviorSubject.seeded(<MediaItem>[]);

  /// Initialise our audio handler.
  AudioPlayerHandler() {
    _init();
  }
  Future<void> _init() async {
    if (queue.value.isNotEmpty) return;
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Activate the audio session before playing audio.
    if (await session.setActive(true)) {
      play();
    } else {
      // The request was denied and the app should not play audio
    }
    // Broadcast speed changes. Debounce so that we don't flood the notification
    // with updates.
    speed.debounceTime(const Duration(milliseconds: 250)).listen((speed) {
      playbackState.add(playbackState.value.copyWith(speed: speed));
    });
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    stop();
    queue.add(mediaItems);
    var index = 0;
    mediaItem
        .whereType<MediaItem>()
        .listen((item) => _recentSubject.add([item]));
    // Broadcast media item changes.
    _player.currentIndexStream.listen((index) {
      index = index;
      if (index != null) mediaItem.add(queue.value[index]);
    });
    // Propagate all events from the audio player to AudioService clients.
    _player.playbackEventStream.listen(_broadcastState);
    // In this example, the service stops when reaching the end.
    _player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) stop();
    });
    _player.positionStream.listen((event) {
      progressNotifier.value = ProgressBarState(
        current: event,
        total: event,
        buffered: event,
      );

      dataStore.updatePosition(
          currentlyPlaying.value?.title! ?? "",
          currentlyPlaying.value?.id! ?? 0,
          durationStateNotifier.value.progress?.inMilliseconds ?? 0);

      dataAlbumStore.updatePosition(
          currentlyPlaying.value?.title! ?? "",
          currentlyPlaying.value?.id! ?? 0,
          durationStateNotifier.value.progress?.inMilliseconds ?? 0);

      dataMoodStore.updatePosition(currentlyPlaying.value?.title! ?? "",
          currentlyPlaying.value?.id! ?? 0, event.inMilliseconds);

      dataIntroStore.updatePosition(currentlyPlaying.value?.title! ?? "",
          currentlyPlaying.value?.id! ?? 0, event.inMilliseconds);
    });
    try {
      // After a cold restart (on Android), _player.load jumps straight from
      // the loading state to the completed state. Inserting a delay makes it
      // work. Not sure why!
      //await Future.delayed(Duration(seconds: 2)); // magic delay

      await _player.setAudioSource(ConcatenatingAudioSource(
        children: queue.value.map((item) {
          // if (item.extras?['downloadedPath'] != "") {
          //   print("tatagdsan");
          //   print(item.extras?['downloadedPath']);
          //   print(Uri.parse(item.extras?['downloadedPath']));
          //   return AudioSource.uri(Uri.parse(item.extras?['downloadedPath']));
          // } else {
          print("tatagdaagu");
          return AudioSource.uri(Uri.parse(item.extras!['url']));
          // }
        }).toList(),
      ));
    } catch (e) {
      // ignore: avoid_print
      print("Error: $e");
    }
  }

  @override
  Future<void> skipToQueueItem(int index) async {
    // Then default implementations of skipToNext and skipToPrevious provided by
    // the [QueueHandler] mixin will delegate to this method.

    if (index < 0 || index >= queue.value.length) return;

    _player.seek(Duration.zero, index: index);
    // Demonstrate custom events.
    customEvent.add('skip to $index');
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) async {
    print(position);
    return _player.seek(position);
  }

  @override
  Future<void> stop() => _player.stop();

  void _broadcastState(PlaybackEvent event) {
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
      playing: playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    ));
  }

  @override
  Future<void> playMediaItem(MediaItem item) async {
    mediaItem.add(item);
    if (item.extras!['saved_position'] > 0) {
      _player.seek(Duration(seconds: item.extras!['saved_position']));

      _player.setUrl(item.extras!['url']);
    }
  }
}

// import 'package:audio_service/audio_service.dart';
// import 'package:audio_session/audio_session.dart';
// import 'package:flutter/foundation.dart';
// import 'package:goodali/Utils/urls.dart';
// import 'package:goodali/controller/audioplayer_controller.dart';
// import 'package:goodali/models/products_model.dart';
// import 'package:goodali/repository.dart/podcast_repository.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:rxdart/rxdart.dart';

// late AudioHandler audioHandler;
// final playlistNotifier = ValueNotifier<List<String>>([]);
// final currentSongTitleNotifier = ValueNotifier<String>('');

// Future<void> initAudioHandler() async {
//   audioHandler = await AudioService.init(
//     builder: () => AudioPlayerHandlerImpl(),
//     config: const AudioServiceConfig(
//       androidNotificationIcon: 'mipmap/ic_launcher_round',
//       androidNotificationChannelId: 'com.example.example.audio',
//       androidNotificationChannelName: 'Audio Service',
//       androidNotificationOngoing: true,
//       androidStopForegroundOnPause: true,
//     ),
//   );
// }

// void listenToChangesInPlaylist() {
//   audioHandler.queue.listen((playlist) {
//     if (playlist.isEmpty) {
//       playlistNotifier.value = [];
//       currentSongTitleNotifier.value = '';
//     } else {
//       final newList = playlist.map((item) => item.title).toList();
//       playlistNotifier.value = newList;
//     }
//   });
// }

// abstract class AudioPlayerHandler implements AudioHandler {
//   Stream<QueueState> get queueState;
//   ValueStream<double> get volume;
// }

// class AudioPlayerHandlerImpl extends BaseAudioHandler
//     with QueueHandler, SeekHandler
//     implements AudioPlayerHandler {
//   final BehaviorSubject<List<MediaItem>> _recentSubject =
//       BehaviorSubject.seeded(<MediaItem>[]);

//   List<MediaItem> _podcastList = [];
//   final _player = AudioPlayer();
//   final _playlist = ConcatenatingAudioSource(children: []);
//   @override
//   final BehaviorSubject<double> volume = BehaviorSubject.seeded(1.0);
//   final BehaviorSubject<double> speed = BehaviorSubject.seeded(1.0);
//   final _mediaItemExpando = Expando<MediaItem>();

//   Stream<List<IndexedAudioSource>> get _effectiveSequence => Rx.combineLatest3<
//               List<IndexedAudioSource>?,
//               List<int>?,
//               bool,
//               List<IndexedAudioSource>?>(_player.sequenceStream,
//           _player.shuffleIndicesStream, _player.shuffleModeEnabledStream,
//           (sequence, shuffleIndices, shuffleModeEnabled) {
//         if (sequence == null) return [];
//         if (!shuffleModeEnabled) return sequence;
//         if (shuffleIndices == null) return null;
//         if (shuffleIndices.length != sequence.length) return null;
//         return shuffleIndices.map((i) => sequence[i]).toList();
//       }).whereType<List<IndexedAudioSource>>();

//   int? getQueueIndex(
//       int? currentIndex, bool shuffleModeEnabled, List<int>? shuffleIndices) {
//     final effectiveIndices = _player.effectiveIndices ?? [];
//     final shuffleIndicesInv = List.filled(effectiveIndices.length, 0);
//     for (var i = 0; i < effectiveIndices.length; i++) {
//       shuffleIndicesInv[effectiveIndices[i]] = i;
//     }
//     return (shuffleModeEnabled &&
//             ((currentIndex ?? 0) < shuffleIndicesInv.length))
//         ? shuffleIndicesInv[currentIndex ?? 0]
//         : currentIndex;
//   }

//   @override
//   Stream<QueueState> get queueState =>
//       Rx.combineLatest3<List<MediaItem>, PlaybackState, List<int>, QueueState>(
//           queue,
//           playbackState,
//           _player.shuffleIndicesStream.whereType<List<int>>(),
//           (queue, playbackState, shuffleIndices) => QueueState(
//                 queue,
//                 playbackState.queueIndex,
//                 playbackState.shuffleMode == AudioServiceShuffleMode.all
//                     ? shuffleIndices
//                     : null,
//                 playbackState.repeatMode,
//               )).where((state) =>
//           state.shuffleIndices == null ||
//           state.queue.length == state.shuffleIndices!.length);

//   AudioPlayerHandlerImpl() {
//     _init();
//   }
//   Future<void> _init() async {
//     final session = await AudioSession.instance;
//     await session.configure(const AudioSessionConfiguration.speech());
//     // Broadcast speed changes. Debounce so that we don't flood the notification
//     // with updates.
//     speed.debounceTime(const Duration(milliseconds: 250)).listen((speed) {
//       playbackState.add(playbackState.value.copyWith(speed: speed));
//     });
//     // Load and broadcast the initial queue
//     _podcastList = await PodcastRepository.getPodcastList();
//     await updateQueue(_podcastList);
//     // For Android 11, record the most recent item so it can be resumed.
//     mediaItem
//         .whereType<MediaItem>()
//         .listen((item) => _recentSubject.add([item]));
//     // Broadcast media item changes.
//     Rx.combineLatest4<int?, List<MediaItem>, bool, List<int>?, MediaItem?>(
//         _player.currentIndexStream,
//         queue,
//         _player.shuffleModeEnabledStream,
//         _player.shuffleIndicesStream,
//         (index, queue, shuffleModeEnabled, shuffleIndices) {
//       final queueIndex =
//           getQueueIndex(index, shuffleModeEnabled, shuffleIndices);
//       return (queueIndex != null && queueIndex < queue.length)
//           ? queue[queueIndex]
//           : null;
//     }).whereType<MediaItem>().distinct().listen(mediaItem.add);
//     // Propagate all events from the audio player to AudioService clients.
//     _player.playbackEventStream.listen(_broadcastState);
//     _player.shuffleModeEnabledStream
//         .listen((enabled) => _broadcastState(_player.playbackEvent));
//     // In this example, the service stops when reaching the end.
//     _player.processingStateStream.listen((state) {
//       if (state == ProcessingState.completed) {
//         stop();
//         _player.seek(Duration.zero, index: 0);
//       }
//     });
//     // Broadcast the current queue.
//     _effectiveSequence
//         .map((sequence) =>
//             sequence.map((source) => _mediaItemExpando[source]!).toList())
//         .pipe(queue);
//     // Load the playlist.
//     _playlist.addAll(queue.value.map(_itemToSource).toList());
//     _player.playbackEventStream.map(_broadcastState).pipe(playbackState);
//     await _player.setAudioSource(_playlist);
//   }

//   AudioSource _itemToSource(MediaItem mediaItem) {
//     final audioSource = AudioSource.uri(Uri.parse(mediaItem.id));
//     _mediaItemExpando[audioSource] = mediaItem;
//     return audioSource;
//   }

//   List<AudioSource> _itemsToSources(List<MediaItem> mediaItems) =>
//       mediaItems.map(_itemToSource).toList();

//   @override
//   Future<void> addQueueItem(MediaItem mediaItem) async {
//     await _playlist.add(_itemToSource(mediaItem));
//   }

//   @override
//   Future<void> addQueueItems(List<MediaItem> mediaItems) async {
//     await _playlist.addAll(_itemsToSources(mediaItems));
//   }

//   @override
//   Future<void> insertQueueItem(int index, MediaItem mediaItem) async {
//     await _playlist.insert(index, _itemToSource(mediaItem));
//   }

//   @override
//   Future<void> updateQueue(List<MediaItem> queue) async {
//     await _playlist.clear();
//     await _playlist.addAll(_itemsToSources(queue));
//   }

//   @override
//   Future<void> updateMediaItem(MediaItem mediaItem) async {
//     final index = queue.value.indexWhere((item) => item.id == mediaItem.id);
//     _mediaItemExpando[_player.sequence![index]] = mediaItem;
//   }

//   @override
//   Future<void> removeQueueItem(MediaItem mediaItem) async {
//     final index = queue.value.indexOf(mediaItem);
//     await _playlist.removeAt(index);
//   }

//   Future<void> moveQueueItem(int currentIndex, int newIndex) async {
//     await _playlist.move(currentIndex, newIndex);
//   }

//   @override
//   Future<void> skipToNext() => _player.seekToNext();

//   @override
//   Future<void> skipToPrevious() => _player.seekToPrevious();

//   @override
//   Future<void> skipToQueueItem(int index) async {
//     if (index < 0 || index >= _playlist.children.length) return;
//     // This jumps to the beginning of the queue item at [index].
//     _player.seek(Duration.zero,
//         index: _player.shuffleModeEnabled
//             ? _player.shuffleIndices![index]
//             : index);
//   }

//   @override
//   Future<void> play() => _player.play();

//   @override
//   Future<void> pause() => _player.pause();

//   @override
//   Future<void> seek(Duration position) => _player.seek(position);

//   @override
//   Future<void> stop() async {
//     await _player.stop();
//     await playbackState.firstWhere(
//         (state) => state.processingState == AudioProcessingState.idle);
//   }

//   void _broadcastState(PlaybackEvent event) {
//     final playing = _player.playing;
//     final queueIndex = getQueueIndex(
//         event.currentIndex, _player.shuffleModeEnabled, _player.shuffleIndices);
//     return playbackState.add(playbackState.value.copyWith(
//       controls: [
//         MediaControl.skipToPrevious,
//         if (playing) MediaControl.pause else MediaControl.play,
//         MediaControl.stop,
//         MediaControl.skipToNext,
//       ],
//       systemActions: const {
//         MediaAction.seek,
//         MediaAction.seekForward,
//         MediaAction.seekBackward,
//       },
//       androidCompactActionIndices: const [0, 1, 3],
//       processingState: const {
//         ProcessingState.idle: AudioProcessingState.idle,
//         ProcessingState.loading: AudioProcessingState.loading,
//         ProcessingState.buffering: AudioProcessingState.buffering,
//         ProcessingState.ready: AudioProcessingState.ready,
//         ProcessingState.completed: AudioProcessingState.completed,
//       }[_player.processingState]!,
//       playing: playing,
//       updatePosition: _player.position,
//       bufferedPosition: _player.bufferedPosition,
//       speed: _player.speed,
//       queueIndex: queueIndex,
//     ));
//   }
// }

// class QueueState {
//   static const QueueState empty =
//       QueueState([], 0, [], AudioServiceRepeatMode.none);

//   final List<MediaItem> queue;
//   final int? queueIndex;
//   final List<int>? shuffleIndices;
//   final AudioServiceRepeatMode repeatMode;

//   const QueueState(
//       this.queue, this.queueIndex, this.shuffleIndices, this.repeatMode);

//   bool get hasPrevious =>
//       repeatMode != AudioServiceRepeatMode.none || (queueIndex ?? 0) > 0;
//   bool get hasNext =>
//       repeatMode != AudioServiceRepeatMode.none ||
//       (queueIndex ?? 0) + 1 < queue.length;
// }
