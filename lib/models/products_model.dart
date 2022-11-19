import 'package:audio_service/audio_service.dart';
import 'package:flutter/rendering.dart';
import 'package:goodali/Utils/urls.dart';
import 'package:hive/hive.dart';

part 'products_model.g.dart';

@HiveType(typeId: 0)
class Products extends HiveObject {
  @HiveField(0)
  int? id;
  @HiveField(1)
  int? price;
  @HiveField(2)
  int? productId;
  @HiveField(3)
  String? title;
  @HiveField(4)
  String? intro;
  @HiveField(5)
  String? name;
  @HiveField(6)
  int? status;
  @HiveField(7)
  String? body;
  @HiveField(8)
  int? order;
  @HiveField(9)
  String? traingName;
  @HiveField(10)
  String? albumTitle;
  @HiveField(11)
  String? lectureTitle;
  @HiveField(12)
  bool? isBought;
  @HiveField(13)
  bool? played;
  @HiveField(14)
  int? audioCount;
  @HiveField(15)
  int? position;
  @HiveField(16)
  int? duration;
  @HiveField(17)
  String? trainingBanner;
  @HiveField(18)
  String? audio;
  @HiveField(19)
  String? banner;
  @HiveField(20)
  int? moodListId;
  @HiveField(21)
  bool? isDownloaded;
  @HiveField(22)
  String? opennedDate;
  @HiveField(23)
  int? isSpecial;
  @HiveField(24)
  String? downloadedPath;
  @HiveField(25)
  int? introDuration;

  Products(
      {this.audio,
      this.banner,
      this.id,
      this.price,
      this.productId,
      this.title,
      this.body,
      this.intro,
      this.name,
      this.order,
      this.status,
      this.traingName,
      this.albumTitle,
      this.moodListId,
      this.lectureTitle,
      this.audioCount,
      this.isBought = false,
      this.trainingBanner,
      this.opennedDate,
      this.isSpecial,
      this.downloadedPath,
      this.isDownloaded = false});

  Products.fromJson(Map<String, dynamic> json) {
    audio = json['audio'] ?? "";
    albumTitle = json['album_title'] ?? "";
    lectureTitle = json['lecture_title'] ?? "";
    banner = json['banner'] ?? "";
    id = json['id'] ?? 0;
    price = json['price'] ?? 0;
    productId = json['product_id'] ?? 0;
    title = json['title'] ?? "";
    name = json['name'] ?? "";
    body = json['body'] ?? "";
    intro = json['intro'] ?? "";
    order = json['order'] ?? 0;
    status = json['status'] ?? 0;
    traingName = json['t_name'] ?? "";
    isBought = json['is_bought'] ?? false;
    audioCount = json['audio_count'] ?? 0;
    trainingBanner = json['t_banner'] ?? "";
    duration = json['duration'] ?? 0;
    introDuration = json['intro_duration'] ?? 0;
    position = json['position'] ?? 0;
    moodListId = json['mood_list_id'] ?? 0;
    played = json['played'] ?? false;
    isDownloaded = json['is_downloaded'] ?? false;
    opennedDate = json['openned_date'] ?? "";
    isSpecial = json['is_special'] ?? 0;
    downloadedPath = json['downloaded_ath'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['audio'] = audio;
    data['banner'] = banner;
    data['id'] = id;
    data['price'] = price;
    data['product_id'] = productId;
    data['title'] = title;
    data['intro'] = intro;
    data['body'] = body;
    data['name'] = name;
    data['order'] = order;
    data['status'] = status;
    data['t_name'] = traingName;
    data['album_title'] = albumTitle;
    data['lecture_title'] = lectureTitle;
    data['is_bought'] = isBought;
    data["audio_count"] = audioCount;
    data['t_banner'] = trainingBanner;
    data['duration'] = duration;
    data['position'] = position;
    data['played'] = played;
    data['mood_list_id'] = moodListId;
    data['is_downloaded'] = isDownloaded;
    data['openned_date'] = opennedDate;
    data['is_special'] = isSpecial;
    data['downloaded_ath'] = downloadedPath;
    data['intro_duration'] = introDuration;
    return data;
  }

  MediaItem toMediaItem() => MediaItem(
        id: id.toString(),
        title: title ?? "",
        artUri: Uri.parse(Urls.networkPath + (audio ?? "")),
        extras: <String, dynamic>{
          'url': Urls.networkPath + (audio ?? ""),
          'position': position ?? 0,
          'duration': duration ?? 0,
        },
      );
}
