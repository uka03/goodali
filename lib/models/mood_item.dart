class MoodItem {
  String? audio;
  String? banner;
  String? body;
  int? id;
  int? moodListId;
  int? order;
  int? status;
  String? title;

  MoodItem(
      {this.audio,
      this.banner,
      this.body,
      this.id,
      this.moodListId,
      this.order,
      this.status,
      this.title});

  MoodItem.fromJson(Map<String, dynamic> json) {
    audio = json['audio'];
    banner = json['banner'];
    body = json['body'];
    id = json['id'];
    moodListId = json['mood_list_id'];
    order = json['order'];
    status = json['status'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['audio'] = audio;
    data['banner'] = banner;
    data['body'] = body;
    data['id'] = id;
    data['mood_list_id'] = moodListId;
    data['order'] = order;
    data['status'] = status;
    data['title'] = title;
    return data;
  }
}
