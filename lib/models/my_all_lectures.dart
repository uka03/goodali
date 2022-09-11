class AllLectures {
  String? albumTitle;
  String? lectureTitle;
  String? audio;
  String? banner;
  String? body;
  int? price;
  int? productId;

  AllLectures(
      {this.albumTitle,
      this.audio,
      this.banner,
      this.body,
      this.lectureTitle,
      this.price,
      this.productId});

  AllLectures.fromJson(Map<String, dynamic> json) {
    albumTitle = json['album_title'];
    audio = json['audio'];
    banner = json['banner'];
    body = json['body'];
    lectureTitle = json['lecture_title'];
    price = json['price'];
    productId = json['product_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['album_title'] = albumTitle;
    data['lecture_title'] = lectureTitle;
    data['audio'] = audio;
    data['banner'] = banner;
    data['body'] = body;
    data['price'] = price;
    data['product_id'] = productId;
    return data;
  }
}
