class Products {
  String? audio;
  String? banner;
  int? id;
  int? price;
  int? productId;
  String? title;
  String? intro;
  String? name;
  int? status;
  String? body;
  int? order;
  String? traingName;

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
      this.traingName});

  Products.fromJson(Map<String, dynamic> json) {
    audio = json['audio'];
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

    return data;
  }
}
