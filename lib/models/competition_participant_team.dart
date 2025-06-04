import 'package:anawketaby/models/competition_participant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CompetitionParticipantTeam extends CompetitionParticipant {
  static const String LEADER_ID_KEY = 'leaderID';
  static const String LEADER_FULL_NAME_KEY = 'leaderFullName';
  static const String MEMBERS_IDS_KEY = 'membersIDs';
  static const String MEMBERS_FCM_TOKENS_KEY = 'membersFCMTokens';
  static const String MEMBERS_PROFILES_KEY = 'membersProfiles';
  static const String NAME_KEY = 'name';
  static const String DESCRIPTION_KEY = 'description';
  static const String IMAGE_URL_KEY = 'imageURL';

  String leaderID;
  String leaderFullName;
  List<String> membersIDs;
  List<String> membersFCMTokens;
  Map<String, dynamic> membersProfiles;
  String name;
  String description;
  String? imageURL;

  CompetitionParticipantTeam({
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
    required this.leaderID,
    required this.leaderFullName,
    required this.membersIDs,
    required this.membersFCMTokens,
    required this.membersProfiles,
    required this.name,
    required this.description,
    required this.imageURL,
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
      LEADER_ID_KEY: leaderID,
      LEADER_FULL_NAME_KEY: leaderFullName,
      MEMBERS_IDS_KEY: membersIDs,
      MEMBERS_FCM_TOKENS_KEY: membersFCMTokens,
      MEMBERS_PROFILES_KEY: membersProfiles,
      NAME_KEY: name,
      DESCRIPTION_KEY: description,
      IMAGE_URL_KEY: imageURL,
    });
    return json;
  }

  factory CompetitionParticipantTeam.fromJson(Map<String, dynamic> doc) {
    CompetitionParticipantTeam competition = CompetitionParticipantTeam(
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
      leaderID: doc[LEADER_ID_KEY],
      leaderFullName: doc[LEADER_FULL_NAME_KEY],
      membersIDs: List<String>.from(doc[MEMBERS_IDS_KEY]),
      membersFCMTokens: List<String>.from(doc[MEMBERS_FCM_TOKENS_KEY]),
      membersProfiles: Map.from(doc[MEMBERS_PROFILES_KEY]),
      name: doc[NAME_KEY],
      description: doc[DESCRIPTION_KEY],
      imageURL: doc[IMAGE_URL_KEY],
    );
    return competition;
  }

  factory CompetitionParticipantTeam.fromDocument(DocumentSnapshot doc) {
    return CompetitionParticipantTeam.fromJson(
        doc.data() as Map<String, dynamic>);
  }
}
