// import 'package:audio_service/audio_service.dart';
// import 'package:audio_session/audio_session.dart';
// import 'package:goodali/repository.dart/podcast_repository.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:rxdart/rxdart.dart';

// late AudioHandler audioHandler;

// Future<void> initAudioHandler() async => audioHandler = await AudioService.init(
//       builder: () => AudioPlayerHandler(),
//       config: const AudioServiceConfig(
//         androidNotificationChannelId: 'com.ryanheise.myapp.channel.audio',
//         androidNotificationChannelName: 'Audio playback',
//         androidNotificationOngoing: true,
//       ),
//     );

// /// An [AudioHandler] for playing a single item.
// class AudioPlayerHandler extends BaseAudioHandler
//     with QueueHandler, SeekHandler {
//   List<MediaItem> _podcastList = [];
//   final _playlist = ConcatenatingAudioSource(children: []);
//   final _player = AudioPlayer();
//   final _mediaItemExpando = Expando<MediaItem>();
//   @override
//   final BehaviorSubject<double> speed = BehaviorSubject.seeded(1.0);
//   final BehaviorSubject<List<MediaItem>> _recentSubject =
//       BehaviorSubject.seeded(<MediaItem>[]);

//   /// Initialise our audio handler.
//   AudioPlayerHandler() {
//     _init();
//   }
//   Future<void> _init() async {
//     final session = await AudioSession.instance;
//     await session.configure(const AudioSessionConfiguration.speech());
//     // Activate the audio session before playing audio.
//     if (await session.setActive(true)) {
//       play();
//     } else {
//       // The request was denied and the app should not play audio
//     }
//     // Broadcast speed changes. Debounce so that we don't flood the notification
//     // with updates.
//     speed.debounceTime(const Duration(milliseconds: 250)).listen((speed) {
//       playbackState.add(playbackState.value.copyWith(speed: speed));
//     });
//     // Load and broadcast the initial queue
//     _podcastList = await PodcastRepository.getPodcastList();
//     queue.add(_podcastList);

//     mediaItem
//         .whereType<MediaItem>()
//         .listen((item) => _recentSubject.add([item]));
//     // Broadcast media item changes.
//     _player.currentIndexStream.listen((index) {
//       if (index != null) mediaItem.add(queue.value[index]);
//     });
//     // Propagate all events from the audio player to AudioService clients.
//     _player.playbackEventStream.listen(_broadcastState);
//     // In this example, the service stops when reaching the end.
//     _player.processingStateStream.listen((state) {
//       if (state == ProcessingState.completed) stop();
//     });
//     try {
//       // After a cold restart (on Android), _player.load jumps straight from
//       // the loading state to the completed state. Inserting a delay makes it
//       // work. Not sure why!
//       //await Future.delayed(Duration(seconds: 2)); // magic delay
//       await _player.setAudioSource(ConcatenatingAudioSource(
//         children: queue.value
//             .map((item) => AudioSource.uri(Uri.parse(item.id)))
//             .toList(),
//       ));
//     } catch (e) {
//       // ignore: avoid_print
//       print("Error: $e");
//     }
//   }

//   // In this simple example, we handle only 4 actions: play, pause, seek and
//   // stop. Any button press from the Flutter UI, notification, lock screen or
//   // headset will be routed through to these 4 methods so that you can handle
//   // your audio playback logic in one place.

//   @override
//   Future<void> play() => _player.play();

//   @override
//   Future<void> pause() => _player.pause();

//   @override
//   Future<void> seek(Duration position) => _player.seek(position);

//   @override
//   Future<void> stop() => _player.stop();

//   /// Transform a just_audio event into an audio_service state.
//   ///
//   /// This method is used from the constructor. Every event received from the
//   /// just_audio player will be transformed into an audio_service state so that
//   /// it can be broadcast to audio_service clients.
//   void _broadcastState(PlaybackEvent event) {
//     final playing = _player.playing;
//     playbackState.add(playbackState.value.copyWith(
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
//       queueIndex: event.currentIndex,
//     ));
//   }
// }
