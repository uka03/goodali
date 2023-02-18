class FaqModel {
  String? answer;
  String? question;

  FaqModel({
    this.answer,
    this.question,
  });

  FaqModel.fromJson(Map<String, dynamic> json) {
    answer = json['answer'];

    question = json['question'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['answer'] = answer;

    data['question'] = question;
    return data;
  }
}
