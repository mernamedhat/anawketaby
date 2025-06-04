import 'package:anawketaby/enums/points_history_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PointHistory {
  static const String TYPE_KEY = 'type';
  static const String COMPETITION_CODE_KEY = 'competitionCode';
  static const String COMPETITION_ID_KEY = 'competitionID';
  static const String POINTS_KEY = 'points';
  static const String PLACE_KEY = 'place';
  static const String TIME_CREATED_KEY = 'timeCreated';

  PointsHistoryType? type;
  int? competitionCode;
  String? competitionID;
  int? points;
  int? place;
  Timestamp? timeCreated;

  PointHistory({
    this.type,
    this.competitionCode,
    this.competitionID,
    this.points,
    this.place,
    this.timeCreated,
  });

  Map<String, dynamic> toJson() {
    return {
      TYPE_KEY: type.toString().replaceAll("PointsHistoryType.", ""),
      COMPETITION_CODE_KEY: competitionCode,
      COMPETITION_ID_KEY: competitionID,
      POINTS_KEY: points,
      PLACE_KEY: place,
      TIME_CREATED_KEY: timeCreated,
    };
  }

  factory PointHistory.fromJson(Map<String, dynamic> doc) {
    PointHistory pointHistory = PointHistory(
      type: _getPointsHistoryTypeFromString(doc[TYPE_KEY]),
      competitionCode: doc[COMPETITION_CODE_KEY],
      competitionID: doc[COMPETITION_ID_KEY],
      points: doc[POINTS_KEY],
      place: doc[PLACE_KEY],
      timeCreated: doc[TIME_CREATED_KEY],
    );
    return pointHistory;
  }

  static String getPointHistoryTypeName(PointsHistoryType? type) {
    switch (type) {
      case PointsHistoryType.registration:
        return "نقاط التسجيل";
      case PointsHistoryType.competition_participation:
        return "الاشتراك بالمسابقة";
      case PointsHistoryType.competition_winner:
        return "فوز بالمسابقة";
      case PointsHistoryType.competition_test_yourself:
        return "اختبر نفسك";
      default:
        return "";
    }
  }

  static _getPointsHistoryTypeFromString(String? value) {
    return PointsHistoryType.values.firstWhere((status) {
      return status.toString().replaceAll("PointsHistoryType.", "") == value;
    }, orElse: () => PointsHistoryType.registration);
  }
}
