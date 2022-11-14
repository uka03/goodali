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
  bool? expiry;
  int? id;
  int? isBought;
  String? name;
  int? allTask;
  int? done;
  bool? opened;

  Lesson(
      {this.banner,
      this.expiry,
      this.id,
      this.isBought,
      this.name,
      this.opened,
      this.allTask,
      this.done});

  Lesson.fromJson(Map<String, dynamic> json) {
    banner = json['banner'] ?? "";
    expiry = json['expiry'] ?? false;
    id = json['id'] ?? 0;
    isBought = json['is_bought'] ?? 0;
    name = json['name'] ?? "";
    allTask = json['all_task'] ?? "";
    done = json['done'] ?? "";
    opened = json['opened'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['banner'] = banner;
    data['expiry'] = expiry;
    data['id'] = id;
    data['is_bought'] = isBought;
    data['name'] = name;
    data['all_task'] = allTask;
    data['done'] = done;
    data['opened'] = opened;
    return data;
  }
}
