import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

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

class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  final _player = AudioPlayer();

  AudioPlayerHandler() {
    // _player.playbackEventStream.map(_transformEvent).pipe(playbackState);

    // mediaItem.add(item);
    _transformEvent();
    // _listenForDurationChanges();
    // _listenForCurrentSongIndexChanges();
    // _listenForSequenceStateChanges();
  }
  void _transformEvent() {
    _player.playbackEventStream.listen((PlaybackEvent event) {
      playbackState.add(playbackState.value.copyWith(
        controls: [
          // MediaControl.rewind,
          MediaControl.skipToPrevious,
          if (_player.playing) MediaControl.pause else MediaControl.play,
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
        playing: _player.playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
        // queueIndex: event.currentIndex,
      ));
    });
  }

  void _listenForDurationChanges() {
    print("_listenForDurationChanges");
    _player.positionStream.listen((duration) {});
    _player.positionStream.listen((duration) {
      // final newMediaItem = _player.currentIndex.copyWith(duration: duration);

      // mediaItem.add(newMediaItem);
    });
  }

  @override
  Future<void> play() async {
    print("audio handler play");

    _player.play();
    return super.play();
  }

  @override
  Future<void> playMediaItem(MediaItem item) async {
    mediaItem.add(item);
    print("player media item");

    _player.setAudioSource(AudioSource.uri(Uri.parse(item.id)),
        initialPosition: item.extras?['position'] != Duration.zero
            ? Duration(microseconds: (item.extras?['position'] * 1000).toInt())
            : Duration.zero);
  }

  @override
  Future<void> pause() async {
    print("audio handler pause");

    _player.pause();
    return super.pause();
  }

  @override
  Future<void> seek(Duration position) {
    print("audio handler seeeeek");
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
