class AlbumProduct {
  String? audio;
  int? audioCount;
  String? banner;
  String? body;
  int? id;
  bool? isBought;
  int? order;
  int? price;
  int? productId;
  int? status;
  String? title;

  AlbumProduct(
      {this.audio,
      this.audioCount,
      this.banner,
      this.body,
      this.id,
      this.isBought,
      this.order,
      this.price,
      this.productId,
      this.status,
      this.title});

  AlbumProduct.fromJson(Map<String, dynamic> json) {
    audio = json['audio'];
    audioCount = json['audio_count'];
    banner = json['banner'];
    body = json['body'];
    id = json['id'];
    isBought = json['is_bought'];
    order = json['order'];
    price = json['price'];
    productId = json['product_id'];
    status = json['status'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['audio'] = audio;
    data['audio_count'] = audioCount;
    data['banner'] = banner;
    data['body'] = body;
    data['id'] = id;
    data['is_bought'] = isBought;
    data['order'] = order;
    data['price'] = price;
    data['product_id'] = productId;
    data['status'] = status;
    data['title'] = title;
    return data;
  }
}
