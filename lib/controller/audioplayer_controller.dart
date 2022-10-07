import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:goodali/Utils/constans.dart';
import 'package:goodali/Utils/custom_catch_manager.dart';

import 'package:goodali/controller/duration_state.dart';
import 'package:goodali/controller/pray_button_notifier.dart';
import 'package:goodali/main.dart';
import 'package:goodali/models/audio_player_model.dart';
import 'package:goodali/models/podcast_list_model.dart';
import 'package:goodali/models/products_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final currentlyPlaying = ValueNotifier<Products?>(null);

final playerExpandProgress = ValueNotifier<double>(playerMinHeight);
final currentPlayingItem =
    ValueNotifier<MediaItem>(const MediaItem(id: "", title: ''));

final durationStateNotifier = ValueNotifier<DurationState>(const DurationState(
  progress: Duration.zero,
  buffered: Duration.zero,
  total: Duration.zero,
));
final buttonNotifier = ValueNotifier<ButtonState>(ButtonState.paused);

class AudioPlayerController with ChangeNotifier {
  AudioPlayerController() {
    initiliaze();
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

    audioHandler.mediaItem.listen((event) {
      final oldState = durationStateNotifier.value;
      durationStateNotifier.value = DurationState(
        progress: oldState.progress,
        buffered: oldState.buffered,
        total: event?.duration ?? Duration.zero,
      );
      // durationStateNotifier.notifyListeners();
    });
    audioHandler.playbackState.listen((event) {
      final oldState = durationStateNotifier.value;
      durationStateNotifier.value = DurationState(
        progress: event.position,
        buffered: event.bufferedPosition,
        total: oldState.total,
      );
      // durationStateNotifier.notifyListeners();
    });

    audioHandler.mediaItem.listen((event) {
      currentPlayingItem.value = event ?? MediaItem(id: "", title: "");
    });
  }

  Future<Duration> getSavedPosition(int moodItemID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> decodedAudioString = prefs.getStringList("save_audio") ?? [];
    List<AudioPlayerModel> decodedProduct = decodedAudioString
        .map((res) => AudioPlayerModel.fromJson(json.decode(res)))
        .toList();
    int? saveddouble;
    Duration savedPosition;
    for (var item in decodedProduct) {
      if (moodItemID == item.productID) {
        saveddouble = decodedProduct.isNotEmpty ? item.audioPosition ?? 0 : 0;
      }
    }
    savedPosition = Duration(milliseconds: saveddouble ?? 0);
    debugPrint("savedPosition $savedPosition");
    return savedPosition;
  }

  Future<FileInfo?> checkCachefor(String url) async {
    final FileInfo? value =
        await CustomCacheManager.instance.getFileFromCache(url);
    return value;
  }
}
