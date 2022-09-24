class CourseLesson {
  int? id;
  Lesson? lesson;

  CourseLesson({this.id, this.lesson});

  CourseLesson.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lesson = json['lesson'] != null ? Lesson.fromJson(json['lesson']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (lesson != null) {
      data['lesson'] = lesson!.toJson();
    }
    return data;
  }
}

class Lesson {
  String? banner;
  String? expiry;
  int? id;
  bool? isBought;
  String? name;

  Lesson({this.banner, this.expiry, this.id, this.isBought, this.name});

  Lesson.fromJson(Map<String, dynamic> json) {
    banner = json['banner'] ?? "";
    expiry = json['expiry'] ?? "";
    id = json['id'] ?? 0;
    isBought = json['is_bought'] ?? false;
    name = json['name'] ?? "";
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
