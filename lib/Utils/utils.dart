import 'package:html/parser.dart';

final types = [
  TypeItem(index: 0, title: "Сонсох"),
  TypeItem(index: 1, title: "Унших"),
  TypeItem(index: 2, title: "Мэдрэх"),
  TypeItem(index: 3, title: "Сургалт"),
];
final fireTypes = [
  TypeItem(index: 0, title: "Хүний байгаль"),
  TypeItem(index: 1, title: "Түүдэг гал"),
  TypeItem(index: 2, title: "Миний нандин"),
];

class TypeItem {
  final String title;
  final int index;
  TypeItem({
    required this.title,
    required this.index,
  });
}

class SeekBarData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
  SeekBarData({
    required this.duration,
    required this.bufferedPosition,
    required this.position,
  });
}

String removeHtmlTags(String htmlString, {String? placeholder}) {
  // Parse HTML string to get the text content
  var document = parse(htmlString);
  String text = parse(document.body!.text).documentElement!.text;

  // Remove extra whitespace characters
  text = text.trim().replaceAll(RegExp(r'\s+'), ' ');
  if (text.isNotEmpty == true) {
    return text;
  } else {
    return placeholder ?? "";
  }
}

enum GoodaliPlayerState {
  /// initial state, stop has been called or an error occurred.
  stopped,

  /// Currently playing audio.
  playing,

  /// Pause has been called.
  paused,

  /// The audio successfully completed (reached the end).
  completed,

  /// The player has been disposed and should not be used anymore.
  disposed,
}

String parseHtmlString(String htmlString) {
  final document = parse(htmlString);
  final String parsedString = parse(document.body?.text).documentElement!.text;

  return parsedString;
}

String parseDuration(Duration? duration) {
  return duration != null
      ? "${duration.inHours} цаг ${(duration.inMinutes % 60).toInt()} мин"
      : "0 цаг 0 мин";
}

int getListViewlength(int? length, {int? max}) {
  if (length == null) {
    return 0;
  }
  if (length > (max ?? 3)) {
    return max ?? 3;
  }

  return length;
}
