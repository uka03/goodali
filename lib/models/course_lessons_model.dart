class CourseLessons {
  String? banner;
  String? expiry;
  int? id;
  bool? isBought;
  String? name;

  CourseLessons({this.banner, this.expiry, this.id, this.isBought, this.name});

  CourseLessons.fromJson(Map<String, dynamic> json) {
    banner = json['banner'];
    expiry = json['expiry'];
    id = json['id'];
    isBought = json['is_bought'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['banner'] = banner;
    data['expiry'] = expiry;
    data['id'] = id;
    data['is_bought'] = isBought;
    data['name'] = name;
    return data;
  }
}
