import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:goodali/controller/audioplayer_controller.dart';

class IntroItem extends StatefulWidget {
  const IntroItem({Key? key}) : super(key: key);

  @override
  State<IntroItem> createState() => _IntroItemState();
}

class _IntroItemState extends State<IntroItem> {
  AudioPlayerController audioPlayerController = AudioPlayerController();
  List<MediaItem> mediaItems = [];
  MediaItem mediaItem = const MediaItem(id: "", title: "");
  FileInfo? fileInfo;
  File? audioFile;
  Stream<FileResponse>? fileStream;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  Duration savedPosition = Duration.zero;

  int saveddouble = 0;
  int currentIndex = 0;
  bool isClicked = false;
  bool isPlaying = false;
  String url = "";
  bool isbgPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
