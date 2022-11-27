import 'dart:convert';
import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:goodali/Utils/constans.dart';
import 'package:goodali/Utils/custom_catch_manager.dart';
import 'package:goodali/Utils/urls.dart';
import 'package:goodali/controller/audio_session.dart';
import 'package:goodali/controller/default_audio_handler.dart';

import 'package:goodali/controller/duration_state.dart';
import 'package:goodali/controller/podcast_state.dart';
import 'package:goodali/controller/pray_button_notifier.dart';
import 'package:goodali/controller/progress_notifier.dart';
import 'package:goodali/models/audio_player_model.dart';
import 'package:goodali/models/products_model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

final currentlyPlaying = ValueNotifier<Products?>(null);
final playlistNotifier = ValueNotifier<List<String>>([]);
final playerExpandProgress = ValueNotifier<double>(playerMinHeight);
final currentPlayingItem =
    ValueNotifier<MediaItem>(const MediaItem(id: "", title: ''));

final currentPlayingSong = ValueNotifier<String>("");

final durationStateNotifier = ValueNotifier<DurationState>(
    const DurationState(Duration.zero, Duration.zero, Duration.zero));
final buttonNotifier = ValueNotifier<ButtonState>(ButtonState.paused);
final progressNotifier = ValueNotifier<ProgressBarState>(const ProgressBarState(
  current: Duration.zero,
  total: Duration.zero,
  buffered: Duration.zero,
));

final podcastsNotifier =
    ValueNotifier<PodcastState>(const PodcastState([], false));

class AudioPlayerController with ChangeNotifier {
  AudioPlayer audioPlayer = AudioPlayer();

  AudioPlayerController() {
    AudioSession.instance.then((audioSession) async {
      await audioSession.configure(const AudioSessionConfiguration.speech());
      AudioSessionSettings.handleInterruption(audioSession);
    });
  }

  void initiliaze() {
    _listenToPosition();
    _listenToTotalDuration();
    _listenToPlaybackState();
    listenToChangesInPlaylist();
  }

  _listenToPlaybackState() {
    audioHandler.playbackState.listen((event) {
      final isPlaying = event.playing;

      final processingState = event.processingState;
      // log('state $processingState : playing: $isPlaying');
      // if (currentlyPlaying.value != null) {
      //   log('${currentlyPlaying.value!.title}');
      // }

      if ((processingState == AudioProcessingState.idle ||
              processingState == AudioProcessingState.error) &&
          !isPlaying) {
        // var item = currentlyPlaying.value;
        // if (item != null) {
        //   item.position = durationStateNotifier.value.progress!.inMilliseconds;
        //   item.save();
        // }
      }
      if (processingState == AudioProcessingState.ready && isPlaying == true) {
        buttonNotifier.value = ButtonState.playing;
      } else if (processingState == AudioProcessingState.loading ||
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
  }

  void listenToChangesInPlaylist() {
    audioHandler.queue.listen((playlist) {
      if (playlist.isEmpty) {
        playlistNotifier.value = [];
      } else {
        final newList = playlist.map((item) => item.title).toList();
        playlistNotifier.value = newList;
      }
    });
  }

  void _listenToPosition() {
    audioHandler.playbackState.listen((event) {
      final oldState = durationStateNotifier.value;
      durationStateNotifier.value = DurationState(
        event.position,
        event.bufferedPosition,
        oldState.total,
      );
    });
  }

  void _listenToTotalDuration() {
    audioHandler.mediaItem.listen((mediaItem) {
      final oldState = durationStateNotifier.value;
      log(mediaItem?.duration.toString() ?? "", name: "totalDuration");
      durationStateNotifier.value = DurationState(
        oldState.progress,
        oldState.buffered,
        mediaItem?.duration ?? Duration.zero,
      );
    });
  }

  Future<int> getSavedPosition(AudioPlayerModel mediaItem) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> decodedAudioString = prefs.getStringList("save_audio") ?? [];
    List<AudioPlayerModel> decodedProduct = decodedAudioString
        .map((res) => AudioPlayerModel.fromJson(json.decode(res)))
        .toList();
    int savedPosition = 0;

    for (var item in decodedProduct) {
      if (mediaItem.title == item.title) {
        savedPosition = decodedProduct.isNotEmpty ? item.audioPosition ?? 0 : 0;
      }
    }

    log("savedPosition $savedPosition");
    return savedPosition;
  }

  savePosition(AudioPlayerModel audio) async {
    List<AudioPlayerModel> _audioItems = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _audioItems.add(audio);
    List<String> encodedProducts =
        _audioItems.map((res) => json.encode(res.toJson())).toList();
    prefs.setStringList("save_audio", encodedProducts);
  }

  Future<FileInfo?> checkCachefor(String url) async {
    final FileInfo? value =
        await CustomCacheManager.instance.getFileFromCache(url);
    return value;
  }

  toAudioModel(Products item) => AudioPlayerModel(
      productID: item.productId,
      audioPosition: 0,
      audioUrl: item.audio,
      banner: item.banner,
      title: item.title);

  toMediaItem(AudioPlayerModel products) => MediaItem(
      id: products.productID.toString(),
      artUri: Uri.parse(Urls.networkPath + products.banner!),
      extras: {"url": products.audioUrl},
      duration: Duration(milliseconds: products.audioPosition ?? 0),
      title: products.title ?? "");
}

List<Products> activeList = [];

Future<bool> initiliazePodcast() async {
  List<MediaItem> mediaItems = [];
  audioHandler.queue.value.clear();

  log(activeList.length.toString(), name: "lesture list");

  for (var item in activeList) {
    MediaItem mediaItem = MediaItem(
      id: item.id.toString(),
      artUri: Uri.parse(Urls.networkPath + item.banner!),
      title: item.title!,
      duration: item.duration != 0 && item.duration != null
          ? Duration(milliseconds: item.duration!)
          : null,
      extras: {
        'url': Urls.networkPath + item.audio!,
        'downloadedPath': item.downloadedPath ?? ""
      },
    );

    mediaItems.add(mediaItem);
  }

  //Audio queue нь mediaItems тай адил биш байвал
  //Queue рүү нэмнэ.

  var firstItem = await audioHandler.queue.first;
  if (audioHandler.queue.value.isEmpty ||
      identical(firstItem, mediaItems.first) == true) {
    log("initiliaze add queue lecture", name: mediaItems.length.toString());
    await audioHandler.addQueueItems(mediaItems);

    return true;
  }
  return false;
}
