class CoursesItems {
  int? allTask;
  String? banner;
  int? done;
  int? id;
  String? name;

  CoursesItems({this.allTask, this.banner, this.done, this.id, this.name});

  CoursesItems.fromJson(Map<String, dynamic> json) {
    allTask = json['all_task'];
    banner = json['banner'];
    done = json['done'];
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['all_task'] = allTask;
    data['banner'] = banner;
    data['done'] = done;
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
