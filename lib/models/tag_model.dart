class TagModel {
  String? description;
  int? id;
  String? name;
  String? banner;

  TagModel({this.description, this.id, this.name, this.banner});

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      description: json['description'],
      id: json['id'],
      name: json['name'],
      banner: json['banner'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["description"] = description;
    data["id"] = id;
    data["name"] = name;
    data["banner"] = banner;

    return data;
  }
}
