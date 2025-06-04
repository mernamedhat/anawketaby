import 'package:anawketaby/enums/question_types.dart';
import 'package:anawketaby/models/question_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CompetitionQuestion {
  int? orderNo;
  QuestionTypes questionType;
  String? content;
  List<QuestionChoice> choices = [];
  List<QuestionChoice> constantChoices = [];
  List<dynamic>? answer;
  int? durationSeconds;
  int? points;
  String? read;

  List<dynamic>? userAnswer = [];
  int? userAnswerRemainingSeconds;

  CompetitionQuestion({
    this.orderNo,
    required this.questionType,
    this.content,
    choices,
    constantChoices,
    this.answer,
    this.durationSeconds,
    this.points,
    this.read,
  }) {
    choices?.forEach((question) {
      if (question is Map)
        this.choices.add(QuestionChoice(question["no"], question["content"]));
      else
        this.choices.add(question);
    });
    constantChoices?.forEach((question) {
      if (question is Map)
        this
            .constantChoices
            .add(QuestionChoice(question["no"], question["content"]));
      else
        this.constantChoices.add(question);
    });
  }

  Map<String, dynamic> toJson() {
    return {
      'orderNo': orderNo,
      'questionType': questionType.toString().replaceAll("QuestionTypes.", ""),
      'content': content,
      'choices': choices.map((e) => e.toJson()).toList(),
      'constantChoices': constantChoices.map((e) => e.toJson()).toList(),
      'answer': answer,
      'durationSeconds': durationSeconds,
      'points': points,
      'read': read,
    };
  }

  factory CompetitionQuestion.fromJson(Map<String, dynamic> doc) {
    CompetitionQuestion competitionQuestion = CompetitionQuestion(
      orderNo: doc['orderNo'],
      questionType: _getQuestionTypeFromString(doc['questionType']),
      content: doc['content'],
      choices: doc['choices'],
      constantChoices: doc['constantChoices'],
      answer: doc['answer'],
      durationSeconds: doc['durationSeconds'],
      points: doc['points'],
      read: doc['read'],
    );
    return competitionQuestion;
  }

  factory CompetitionQuestion.fromDocument(DocumentSnapshot doc) {
    return CompetitionQuestion.fromJson(doc.data() as Map<String, dynamic>);
  }

  factory CompetitionQuestion.clone(CompetitionQuestion question) {
    return CompetitionQuestion(
      questionType: question.questionType,
      choices: question.choices.map((e) => QuestionChoice.clone(e)).toList(),
      constantChoices:
          question.constantChoices.map((e) => QuestionChoice.clone(e)).toList(),
      content: question.content,
      answer: question.answer,
      points: question.points,
      orderNo: question.orderNo,
      durationSeconds: question.durationSeconds,
      read: question.read,
    );
  }

  static _getQuestionTypeFromString(String? value) {
    return QuestionTypes.values.firstWhere((status) {
      return status.toString().replaceAll("QuestionTypes.", "") == value;
    }, orElse: () => QuestionTypes.tf);
  }
}
