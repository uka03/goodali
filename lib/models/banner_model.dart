class BannerModel {
  String? banner;
  int? productID;
  int? productType;
  int? id;
  String? title;
  int? status;

  BannerModel(
      {this.banner, this.id, this.productID, this.productType, this.title});

  BannerModel.fromJson(Map<String, dynamic> json) {
    banner = json['banner'];
    id = json['id'];
    productID = json['product_id'];
    productType = json['product_type'];
    title = json['title'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['banner'] = banner;
    data['product_id'] = productID;
    data['product_type'] = productType;
    data['title'] = title;
    data['status'] = status;
    data['id'] = id;
    return data;
  }
}
