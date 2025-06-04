import 'package:cloud_firestore/cloud_firestore.dart';

class CompetitionParticipant {
  String? id;
  int? points;
  List<int>? questionsOrder;
  List? answers;
  bool? statusStarted;
  bool? statusFinished;
  Timestamp? timeStarted;
  Timestamp? timeFinished;
  Timestamp? timeParticipated;
  int? totalAnswerSeconds;

  CompetitionParticipant({
    this.id,
    this.points,
    this.questionsOrder,
    this.answers,
    this.statusStarted,
    this.statusFinished,
    this.timeStarted,
    this.timeFinished,
    this.timeParticipated,
    this.totalAnswerSeconds,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'points': points,
      'questionsOrder': questionsOrder,
      'answers': answers,
      'statusStarted': statusStarted,
      'statusFinished': statusFinished,
      'timeStarted': timeStarted,
      'timeFinished': timeFinished,
      'timeParticipated': timeParticipated,
      'totalAnswerSeconds': totalAnswerSeconds,
    };
  }

  factory CompetitionParticipant.fromJson(Map<String, dynamic> doc) {
    CompetitionParticipant competition = CompetitionParticipant(
      id: doc['id'],
      points: doc['points'],
      questionsOrder: (doc['questionsOrder'] != null)
          ? List<int>.from(doc['questionsOrder'])
          : null,
      answers: List.from(doc['answers']),
      statusStarted: doc['statusStarted'],
      statusFinished: doc['statusFinished'],
      timeStarted: doc['timeStarted'],
      timeFinished: doc['timeFinished'],
      timeParticipated: doc['timeParticipated'],
      totalAnswerSeconds: doc['totalAnswerSeconds'],
    );
    return competition;
  }

  factory CompetitionParticipant.fromDocument(DocumentSnapshot doc) {
    return CompetitionParticipant.fromJson(doc.data() as Map<String, dynamic>);
  }
}
