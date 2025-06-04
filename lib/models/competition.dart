import 'package:anawketaby/enums/competition_creation_feature.dart';
import 'package:anawketaby/enums/competition_level.dart';
import 'package:anawketaby/enums/competition_type.dart';
import 'package:anawketaby/enums/competition_winner.dart';
import 'package:anawketaby/models/app_group.dart';
import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/models/competition_conditions.dart';
import 'package:anawketaby/models/competition_question.dart';
import 'package:anawketaby/models/group_competition_creation_feature.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';

class Competition {
  static const String ID_KEY = 'id';
  static const String COMPETITION_CODE_KEY = 'competitionCode';
  static const String CREATOR_ID_KEY = 'creatorID';
  static const String CREATOR_FULL_NAME_KEY = 'creatorFullName';
  static const String NAME_KEY = 'name';
  static const String DESCRIPTION_KEY = 'description';
  static const String READS_KEY = 'reads';
  static const String PARTICIPATION_POINTS_KEY = 'participationPoints';
  static const String URL_KEY = 'url';
  static const String COMPETITION_TYPE_KEY = 'competitionType';
  static const String COMPETITION_TEAM_COUNT_KEY = 'competitionTeamCount';
  static const String COMPETITION_LEVEL_KEY = 'competitionLevel';
  static const String COMPETITION_WINNER_KEY = 'competitionWinner';
  static const String DURATION_PER_COMPETITION_KEY = 'durationPerCompetition';
  static const String DURATION_COMPETITION_KEY = 'durationCompetitionSeconds';
  static const String REMAINING_TIME_CONSIDER_KEY = 'remainingTimeConsider';
  static const String SHUFFLE_QUESTIONS_KEY = 'shuffleQuestions';
  static const String CAN_BACK_KEY = 'canBack';
  static const String IS_PUBLISHED_BEFORE_START_TIME_KEY =
      'isPublishBeforeStartTime';
  static const String IS_POPULAR_KEY = 'isPopular';
  static const String IS_TEST_YOURSELF_KEY = 'isTestYourself';
  static const String IS_RESULT_PUBLISHED_KEY = 'isResultPublished';
  static const String ARCHIVED_KEY = 'archived';
  static const String CLOSED_KEY = 'closed';
  static const String CLOSED_PASSWORD_KEY = 'closedPassword';
  static const String IMAGE_URL_KEY = 'imageURL';
  static const String PARTICIPANTS_COUNT_KEY = 'participantsCount';
  static const String TIME_START_KEY = 'timeStart';
  static const String TIME_END_KEY = 'timeEnd';
  static const String TIME_CALCULATE_RESULTS_KEY = 'timeCalculateResults';
  static const String TIME_PUBLISHED_KEY = 'timePublished';
  static const String TIME_RESULT_PUBLISHED_KEY = 'timeResultPublished';
  static const String TIME_CREATED_KEY = 'timeCreated';
  static const String TIME_LAST_EDIT_KEY = 'timeLastEdit';
  static const String QUESTIONS_KEY = 'questions';
  static const String WINNERS_IDS_KEY = 'winnersIDs';
  static const String COMPETITION_CONDITIONS_KEY = 'competitionConditions';
  static const String TOTAL_POINTS_KEY = 'totalPoints';
  static const String GROUPS_IDS_KEY = 'groupsIDs';

  String? id;
  int? competitionCode;
  String? creatorID;
  String? creatorFullName;
  String? name;
  String? description;
  List<String>? reads;
  int? participationPoints;
  String? url;
  CompetitionType? competitionType;
  int? competitionTeamCount;
  CompetitionLevel? competitionLevel;
  CompetitionWinner? competitionWinner;
  bool? durationPerCompetition;
  int? durationCompetitionSeconds;
  bool? shuffleQuestions;
  bool? remainingTimeConsider;
  bool? canBack;
  bool? isPublishBeforeStartTime = false;
  bool? isPopular = false;
  bool? isTestYourself = false;
  bool? isResultPublished = false;
  bool? archived = false;
  bool? closed;
  String? closedPassword;
  String? imageURL;
  int? participantsCount;
  List<String>? groupsIDs;
  Timestamp? timeStart;
  Timestamp? timeEnd;
  Timestamp? timeCalculateResults;
  Timestamp? timePublished;
  Timestamp? timeResultPublished;
  Timestamp? timeCreated;
  Timestamp? timeLastEdit;

  CompetitionConditions? competitionConditions;
  int? totalPoints;

  List<CompetitionQuestion> questions = [];
  List<String>? winnersIDs = [];

  bool landSummary = false;

  PlatformFile? tempPickedImage;

  Competition({
    this.id,
    this.competitionCode,
    this.creatorID,
    this.creatorFullName,
    this.name,
    this.description,
    this.reads,
    this.participationPoints,
    this.url,
    this.competitionType,
    this.competitionTeamCount,
    this.competitionLevel,
    this.competitionWinner,
    this.durationPerCompetition,
    this.durationCompetitionSeconds,
    this.shuffleQuestions,
    this.remainingTimeConsider,
    this.canBack,
    this.isPublishBeforeStartTime,
    this.isPopular,
    this.isTestYourself,
    this.isResultPublished,
    this.archived,
    this.closed,
    this.closedPassword,
    this.imageURL,
    this.participantsCount,
    this.groupsIDs,
    this.timeStart,
    this.timeEnd,
    this.timeCalculateResults,
    this.timePublished,
    this.timeResultPublished,
    this.timeCreated,
    this.timeLastEdit,
    questions,
    this.winnersIDs,
    this.competitionConditions,
    this.totalPoints,
  }) {
    if (questions != null) {
      questions.forEach((question) {
        if (question is Map)
          this.questions.add(
              CompetitionQuestion.fromJson(question as Map<String, dynamic>));
        else
          this.questions.add(question);
      });
    }
    if (competitionConditions == null) {
      competitionConditions = CompetitionConditions();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      ID_KEY: id,
      COMPETITION_CODE_KEY: competitionCode,
      CREATOR_ID_KEY: creatorID,
      CREATOR_FULL_NAME_KEY: creatorFullName,
      NAME_KEY: name,
      DESCRIPTION_KEY: description,
      READS_KEY: reads,
      PARTICIPATION_POINTS_KEY: participationPoints,
      URL_KEY: url,
      COMPETITION_TYPE_KEY:
          competitionType?.toString().replaceAll("CompetitionType.", ""),
      COMPETITION_TEAM_COUNT_KEY: competitionTeamCount,
      COMPETITION_LEVEL_KEY:
          competitionLevel.toString().replaceAll("CompetitionLevel.", ""),
      COMPETITION_WINNER_KEY:
          competitionWinner.toString().replaceAll("CompetitionWinner.", ""),
      DURATION_PER_COMPETITION_KEY: durationPerCompetition,
      DURATION_COMPETITION_KEY: durationCompetitionSeconds,
      SHUFFLE_QUESTIONS_KEY: shuffleQuestions,
      REMAINING_TIME_CONSIDER_KEY: remainingTimeConsider,
      CAN_BACK_KEY: canBack,
      IS_PUBLISHED_BEFORE_START_TIME_KEY: isPublishBeforeStartTime,
      IS_POPULAR_KEY: isPopular,
      IS_TEST_YOURSELF_KEY: isTestYourself,
      IS_RESULT_PUBLISHED_KEY: isResultPublished,
      ARCHIVED_KEY: archived,
      CLOSED_KEY: closed,
      CLOSED_PASSWORD_KEY: closedPassword,
      IMAGE_URL_KEY: imageURL,
      PARTICIPANTS_COUNT_KEY: participantsCount,
      GROUPS_IDS_KEY: groupsIDs,
      TIME_START_KEY: timeStart,
      TIME_END_KEY: timeEnd,
      TIME_CALCULATE_RESULTS_KEY: timeCalculateResults,
      TIME_PUBLISHED_KEY: timePublished,
      TIME_RESULT_PUBLISHED_KEY: timeResultPublished,
      TIME_CREATED_KEY: timeCreated,
      TIME_LAST_EDIT_KEY: timeLastEdit,
      QUESTIONS_KEY: questions.map((e) => e.toJson()).toList(),
      WINNERS_IDS_KEY: winnersIDs,
      COMPETITION_CONDITIONS_KEY: competitionConditions?.toJson(),
      TOTAL_POINTS_KEY: totalPoints,
    };
  }

  factory Competition.fromJson(Map<String, dynamic> doc) {
    Competition competition = Competition(
      id: doc[ID_KEY],
      competitionCode: doc[COMPETITION_CODE_KEY],
      creatorID: doc[CREATOR_ID_KEY],
      creatorFullName: doc[CREATOR_FULL_NAME_KEY],
      name: doc[NAME_KEY],
      description: doc[DESCRIPTION_KEY],
      reads: List.from(doc[READS_KEY]),
      participationPoints: doc[PARTICIPATION_POINTS_KEY],
      url: doc[URL_KEY],
      competitionType: (doc[COMPETITION_TYPE_KEY] != null)
          ? _getCompetitionTypeFromString(doc[COMPETITION_TYPE_KEY])
          : CompetitionType.individual,
      competitionTeamCount: doc[COMPETITION_TEAM_COUNT_KEY],
      competitionLevel:
          _getCompetitionLevelFromString(doc[COMPETITION_LEVEL_KEY]),
      competitionWinner:
          _getCompetitionWinnerFromString(doc[COMPETITION_WINNER_KEY]),
      durationPerCompetition: doc[DURATION_PER_COMPETITION_KEY],
      durationCompetitionSeconds: doc[DURATION_COMPETITION_KEY],
      shuffleQuestions: doc[SHUFFLE_QUESTIONS_KEY],
      remainingTimeConsider: doc[REMAINING_TIME_CONSIDER_KEY],
      canBack: doc[CAN_BACK_KEY],
      isPublishBeforeStartTime: doc[IS_PUBLISHED_BEFORE_START_TIME_KEY],
      isPopular: doc[IS_POPULAR_KEY],
      isTestYourself: doc[IS_TEST_YOURSELF_KEY],
      isResultPublished: doc[IS_RESULT_PUBLISHED_KEY],
      archived: doc[ARCHIVED_KEY],
      closed: doc[CLOSED_KEY],
      closedPassword: doc[CLOSED_PASSWORD_KEY],
      imageURL: doc[IMAGE_URL_KEY],
      participantsCount: doc[PARTICIPANTS_COUNT_KEY],
      groupsIDs:
          (doc[GROUPS_IDS_KEY] != null) ? List.from(doc[GROUPS_IDS_KEY]) : null,
      timeStart: doc[TIME_START_KEY],
      timeEnd: doc[TIME_END_KEY],
      timeCalculateResults: doc[TIME_CALCULATE_RESULTS_KEY],
      timePublished: doc[TIME_PUBLISHED_KEY],
      timeResultPublished: doc[TIME_RESULT_PUBLISHED_KEY],
      timeCreated: doc[TIME_CREATED_KEY],
      timeLastEdit: doc[TIME_LAST_EDIT_KEY],
      questions: doc[QUESTIONS_KEY],
      winnersIDs: List.from(doc[WINNERS_IDS_KEY]),
      competitionConditions: (doc[COMPETITION_CONDITIONS_KEY] != null)
          ? CompetitionConditions.fromJson(doc[COMPETITION_CONDITIONS_KEY])
          : null,
      totalPoints: doc[TOTAL_POINTS_KEY],
    );
    return competition;
  }

  factory Competition.fromDocument(DocumentSnapshot doc) {
    return Competition.fromJson(doc.data() as Map<String, dynamic>);
  }

  factory Competition.clone(Competition original) {
    return Competition(
      id: original.id,
      competitionCode: original.competitionCode,
      creatorID: original.creatorID,
      creatorFullName: original.creatorFullName,
      name: original.name,
      description: original.description,
      reads: original.reads,
      participationPoints: original.participationPoints,
      url: original.url,
      competitionType: original.competitionType,
      competitionTeamCount: original.competitionTeamCount,
      competitionLevel: original.competitionLevel,
      competitionWinner: original.competitionWinner,
      durationPerCompetition: original.durationPerCompetition,
      durationCompetitionSeconds: original.durationCompetitionSeconds,
      shuffleQuestions: original.shuffleQuestions,
      remainingTimeConsider: original.remainingTimeConsider,
      canBack: original.canBack,
      isPublishBeforeStartTime: original.isPublishBeforeStartTime,
      isPopular: original.isPopular,
      isTestYourself: original.isTestYourself,
      isResultPublished: original.isResultPublished,
      archived: original.archived,
      closed: original.closed,
      closedPassword: original.closedPassword,
      imageURL: original.imageURL,
      participantsCount: original.participantsCount,
      timeStart: original.timeStart,
      groupsIDs: original.groupsIDs,
      timeEnd: original.timeEnd,
      timeCalculateResults: original.timeCalculateResults,
      timePublished: original.timePublished,
      timeResultPublished: original.timeResultPublished,
      timeCreated: original.timeCreated,
      timeLastEdit: original.timeLastEdit,
      questions: original.questions,
      winnersIDs: original.winnersIDs,
      totalPoints: original.totalPoints,
    );
  }

  bool isUserAcceptToEnter(AppUser appUser,
      {bool checkUserWithinTeam = false}) {
    if (competitionConditions == null ||
        (competitionType == CompetitionType.teams && !checkUserWithinTeam)) {
      return true;
    } else {
      if (competitionConditions!.gender != null &&
          competitionConditions!.gender != appUser.gender) {
        return false;
      } else if (competitionConditions!.churches != null &&
          !competitionConditions!.churches!.contains(appUser.church)) {
        return false;
      } else if (competitionConditions!.churchRoles != null &&
          !competitionConditions!.churchRoles!.contains(appUser.churchRole)) {
        return false;
      } else if (competitionConditions!.ageFrom != null &&
          (appUser.birthDate == null ||
              competitionConditions!.ageFrom!.toDate().year <
                  appUser.birthDate!.toDate().year ||
              competitionConditions!.ageTo!.toDate().year >
                  appUser.birthDate!.toDate().year)) {
        return false;
      } else if (competitionConditions!.competitionsIDs != null) {
        for (final id in competitionConditions!.competitionsIDs!) {
          if (!appUser.participatedCompetitions.contains(id) &&
              !appUser.participatedCompetitionsTest.keys.contains(id)) {
            return false;
          }
        }
      }
      return true;
    }
  }

  bool isUserMustFollow(AppUser appUser) {
    if (competitionConditions == null) {
      return true;
    } else {
      return competitionConditions!.followersOnly &&
          !appUser.following.contains(this.creatorID);
    }
  }

  bool isFeatureAllowed(
      AppUser user, AppGroup? group, CompetitionCreationFeature feature) {
    if (group != null)
      return group.groupFeature.groupCompetitionCreationFeature
              .firstWhereOrNull((e) => e.feature == feature)
              ?.value ??
          false;
    else
      return true;
  }

  dynamic featureDefault(
    AppUser user,
    AppGroup? group,
    CompetitionCreationFeature feature,
    dynamic defaultVal,
  ) {
    if (group != null)
      return group.groupFeature.groupCompetitionCreationFeature
                  .firstWhereOrNull((e) => e.feature == feature)
                  ?.properties?[
              GroupCompetitionCreationFeature.PROPERTIES_DEFAULT_KEY] ??
          defaultVal;
    else
      return defaultVal;
  }

  static _getCompetitionTypeFromString(String? value) {
    return CompetitionType.values.firstWhere((status) {
      return status.toString().replaceAll("CompetitionType.", "") == value;
    }, orElse: () => CompetitionType.individual);
  }

  static _getCompetitionLevelFromString(String? value) {
    return CompetitionLevel.values.firstWhere((status) {
      return status.toString().replaceAll("CompetitionLevel.", "") == value;
    }, orElse: () => CompetitionLevel.easy);
  }

  static _getCompetitionWinnerFromString(String? value) {
    return CompetitionWinner.values.firstWhere((status) {
      return status.toString().replaceAll("CompetitionWinner.", "") == value;
    }, orElse: () => CompetitionWinner.one);
  }
}
