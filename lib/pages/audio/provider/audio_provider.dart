import 'dart:async';
import 'package:flutter/material.dart';
import 'package:goodali/connection/models/product_response.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/utils/utils.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioProvider extends ChangeNotifier {
  bool _initiated = false;
  bool isSaved = false;
  GoodaliPlayerState? playerState;
  AudioPlayer? audioPlayer;
  StreamSubscription? sub;
  double progress = 0.0;
  BehaviorSubject<SeekBarData>? streamController;
  ProductResponseData? product;

  Future<void> setAudioPlayer(BuildContext context, ProductResponseData? data,
      {bool save = false}) async {
    if (!_initiated || data?.id != product?.id) {
      isSaved = save;
      await setPlayerState(context, GoodaliPlayerState.disposed);
      init(data);
      product = data;
      if (context.mounted) {
        audioPlayer?.seek(Duration(minutes: data?.pausedTime ?? 0));
        await setPlayerState(context, GoodaliPlayerState.paused);
      }
    }

    _initiated = true;
  }

  Stream<SeekBarData> get _seekBarDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, SeekBarData>(
        audioPlayer?.positionStream ?? Stream.empty(),
        audioPlayer?.bufferedPositionStream ?? Stream.empty(),
        audioPlayer?.durationStream ?? Stream.empty(),
        (position, bufferedPosition, duration) => SeekBarData(
          position: position,
          bufferedPosition: bufferedPosition,
          duration: duration ?? Duration.zero,
        ),
      );

  @override
  void dispose() {
    streamController?.close();
    audioPlayer?.dispose();
    super.dispose();
  }

  void init(ProductResponseData? data) async {
    audioPlayer = AudioPlayer();
    streamController = BehaviorSubject<SeekBarData>();
    sub = _seekBarDataStream.listen((event) {
      streamController?.sink.add(event);
    });

    if (audioPlayer == null || data == null) {
      return;
    }
    if (data.audio?.isNotEmpty == true ||
        data.audio != "Audio failed to upload") {
      await audioPlayer?.setUrl(data.audio!.toUrl());
    }
  }

  Future<void> setPlayerState(
    BuildContext context,
    GoodaliPlayerState state,
  ) async {
    playerState = state;
    switch (state) {
      case GoodaliPlayerState.playing:
        audioPlayer?.play();
        break;
      case GoodaliPlayerState.paused:
        audioPlayer?.pause();
        break;
      case GoodaliPlayerState.stopped:
        audioPlayer?.stop();
        break;
      case GoodaliPlayerState.disposed:
        if (isSaved) {
          saveSearchHistory(product?.id.toString() ?? "");
        }
        audioPlayer?.stop();
        await audioPlayer?.dispose();
        await sub?.cancel();
        await streamController?.close();
        streamController = null;
        playerState = null;
        product = null;
        _initiated = false;
        break;
      default:
        break;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  saveSearchHistory(String value) async {
    final prefs = await SharedPreferences.getInstance();

    final values = prefs.getStringList('listen_podcasts') ?? [];
    if (!values.contains(value)) {
      values.add(value);
      prefs.setStringList('listen_podcasts', values);
    } else {
      values.remove(value);
      values.add(value);
      prefs.setStringList('listen_podcasts', values);
    }
  }
}
