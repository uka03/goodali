class CourseProducts {
  String? banner;
  String? name;
  String? productId;
  String? body;
  int? id;

  CourseProducts({this.banner, this.id, this.name, this.productId, this.body});

  factory CourseProducts.fromJson(Map<String, dynamic> json) {
    return CourseProducts(
        banner: json['banner'],
        id: json['id'],
        name: json['name'],
        body: json['body'],
        productId: json['productId']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["banner"] = banner;
    data["id"] = id;
    data["name"] = name;
    data["body"] = body;
    data["productId"] = productId;

    return data;
  }
}
