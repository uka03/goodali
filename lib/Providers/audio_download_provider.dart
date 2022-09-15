import 'package:flutter/material.dart';
import 'package:goodali/models/downloaded_audio_item.dart';

class AudioDownloadProvider with ChangeNotifier {
  List<DownloadedItem> _items = [];
  List<DownloadedItem> get items => _items;
}
