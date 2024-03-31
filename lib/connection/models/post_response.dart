import 'package:goodali/connection/models/base_response.dart';
import 'package:goodali/connection/models/tag_response.dart';
import 'package:json_annotation/json_annotation.dart';
part 'post_response.g.dart';

@JsonSerializable()
class PostResponse extends BaseResponse {
  List<PostResponseData?>? data;

  PostResponse({
    this.data,
    super.message,
    super.msg,
    super.status,
  });

  factory PostResponse.fromJson(Map<String, dynamic> json) =>
      _$PostResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$PostResponseToJson(this);
}

@JsonSerializable()
class PostResponseData {
  final String? avatar;
  final String? body;
  @JsonKey(name: "created_at")
  final String? createdAt;
  final int? id;
  int? likes;
  @JsonKey(name: "nick_name")
  final String? nickname;
  @JsonKey(name: "post_type")
  final int? postType;
  @JsonKey(name: "self_like")
  bool? selfLike;
  List<TagResponseData?>? tags;
  final String? title; // Define tags as List<TagResponse?>
  dynamic replys; // Define replys as dynamic type
  @JsonKey(includeToJson: false, includeFromJson: false)
  List<ReplyResponse?> get replyList {
    // Convert replys to List<ReplyResponse?> if it's a String
    if (replys == null || replys == "") {
      return [];
    }
    // If replys is already a List<ReplyResponse?>, return it directly
    final List<dynamic> parsedList = replys;
    return parsedList.map((e) => ReplyResponse.fromJson(e)).toList();
  }

  PostResponseData({
    required this.avatar,
    this.body,
    this.createdAt,
    this.id,
    this.likes,
    this.nickname,
    this.postType,
    this.replys,
    this.tags,
    this.title,
    this.selfLike,
  });

  factory PostResponseData.fromJson(Map<String, dynamic> json) {
    return _$PostResponseDataFromJson(json);
  }

  Map<String, dynamic> toJson() => _$PostResponseDataToJson(this);
}

@JsonSerializable()
class ReplyResponse {
  @JsonKey(name: "nick_name")
  final String? nickname;
  final String? text;

  ReplyResponse({
    required this.nickname,
    required this.text,
  });
  factory ReplyResponse.fromJson(Map<String, dynamic> json) =>
      _$ReplyResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ReplyResponseToJson(this);
}
