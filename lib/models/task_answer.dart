class TaskAnswers {
  String? taskID;
  String? taskFieldData;
  int? isAnswered;

  TaskAnswers({this.taskID, this.taskFieldData, this.isAnswered});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['task_id'] = taskID;
    data['text_field_data'] = taskFieldData;
    data['is_answered'] = isAnswered;

    return data;
  }

  factory TaskAnswers.fromJson(Map<String, dynamic> json) {
    return TaskAnswers(
      taskID: json['task_id'],
      taskFieldData: json['text_field_data'],
      isAnswered: json['is_answered'],
    );
  }
}
