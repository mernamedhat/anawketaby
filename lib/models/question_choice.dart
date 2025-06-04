class QuestionChoice {
  int? no;
  String? content;

  QuestionChoice(this.no, this.content);

  Map<String, dynamic> toJson() {
    return {
      'no': no,
      'content': content,
    };
  }

  factory QuestionChoice.clone(QuestionChoice questionChoice) {
    return QuestionChoice(questionChoice.no, questionChoice.content);
  }
}
