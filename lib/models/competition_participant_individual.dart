import 'package:anawketaby/models/competition_participant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CompetitionParticipantIndividual extends CompetitionParticipant {
  String? fullName;
  String? profilePhotoURL;
  String? fcmToken;

  CompetitionParticipantIndividual({
    id,
    points,
    questionsOrder,
    answers,
    statusStarted,
    statusFinished,
    timeStarted,
    timeFinished,
    timeParticipated,
    totalAnswerSeconds,
    this.fullName,
    this.profilePhotoURL,
    this.fcmToken,
  }) : super(
          id: id,
          points: points,
          questionsOrder: questionsOrder,
          answers: answers,
          statusStarted: statusStarted,
          statusFinished: statusFinished,
          timeStarted: timeStarted,
          timeFinished: timeFinished,
          timeParticipated: timeParticipated,
          totalAnswerSeconds: totalAnswerSeconds,
        );

  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'fullName': fullName,
      'profilePhotoURL': profilePhotoURL,
      'fcmToken': fcmToken,
    });
    return json;
  }

  factory CompetitionParticipantIndividual.fromJson(Map<String, dynamic> doc) {
    CompetitionParticipantIndividual competition =
        CompetitionParticipantIndividual(
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
      fullName: doc['fullName'],
      profilePhotoURL: doc['profilePhotoURL'],
      fcmToken: doc['fcmToken'],
    );
    return competition;
  }

  factory CompetitionParticipantIndividual.fromDocument(DocumentSnapshot doc) {
    return CompetitionParticipantIndividual.fromJson(
        doc.data() as Map<String, dynamic>);
  }
}
