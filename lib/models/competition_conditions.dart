import 'package:anawketaby/enums/church.dart';
import 'package:anawketaby/enums/church_role.dart';
import 'package:anawketaby/enums/gender.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';

class CompetitionConditions {
  static const String GENDER_KEY = 'gender';
  static const String CHURCHES_KEY = 'church';
  static const String CHURCHES_ROLE_KEY = 'churchRole';
  static const String AGE_FROM_KEY = 'ageFrom';
  static const String AGE_TO_KEY = 'ageTo';
  static const String COMPETITIONS_IDS_KEY = 'competitionsIDs';
  static const String FOLLOWERS_ONLY_KEY = 'followersOnly';

  Gender? gender;
  List<Church>? churches;
  List<ChurchRole>? churchRoles;
  Timestamp? ageFrom;
  Timestamp? ageTo;
  List<String>? competitionsIDs;
  bool followersOnly;

  CompetitionConditions({
    this.gender,
    this.churches,
    this.churchRoles,
    this.ageFrom,
    this.ageTo,
    this.competitionsIDs,
    this.followersOnly = false,
  });

  Map<String, dynamic> toJson() {
    return {
      GENDER_KEY: (gender != null) ? gender?.name : null,
      CHURCHES_KEY:
          (churches != null) ? churches?.map((e) => e.name).toList() : null,
      CHURCHES_ROLE_KEY: (churchRoles != null)
          ? churchRoles?.map((e) => e.name).toList()
          : null,
      AGE_FROM_KEY: ageFrom,
      AGE_TO_KEY: ageTo,
      COMPETITIONS_IDS_KEY: competitionsIDs,
      FOLLOWERS_ONLY_KEY: followersOnly,
    };
  }

  factory CompetitionConditions.fromJson(Map<String, dynamic> doc) {
    CompetitionConditions competition = CompetitionConditions(
      gender: (doc[GENDER_KEY] != null)
          ? _getGenderFromString(doc[GENDER_KEY])
          : null,
      churches: (doc[CHURCHES_KEY] != null)
          ? List.from(
              doc[CHURCHES_KEY].map((e) => _getChurchFromString(e)).toList())
          : null,
      churchRoles: (doc[CHURCHES_ROLE_KEY] != null)
          ? List.from(doc[CHURCHES_ROLE_KEY]
              .map((e) => _getChurchRoleFromString(e))
              .toList())
          : null,
      ageFrom: doc[AGE_FROM_KEY],
      ageTo: doc[AGE_TO_KEY],
      competitionsIDs: (doc[COMPETITIONS_IDS_KEY] != null)
          ? List.from(doc[COMPETITIONS_IDS_KEY])
          : null,
      followersOnly: doc[FOLLOWERS_ONLY_KEY],
    );
    return competition;
  }

  static String getChurchName(Church? church) {
    switch (church) {
      case Church.orthodox:
        return "ارثوذكس";
      case Church.catholics:
        return "كاثوليك";
      case Church.protestant:
        return "بروتستانت";
      case Church.other:
        return "غير ذلك";
      default:
        return "";
    }
  }

  static String getChurchRoleName(ChurchRole? churchRole) {
    switch (churchRole) {
      case ChurchRole.notBelong:
        return "لا أنمتي لكنيسة";
      case ChurchRole.normal:
        return "مخدوم داخل الكنيسة";
      case ChurchRole.servant:
        return "خادم أو شماس";
      case ChurchRole.leader:
        return "قائد أو أمين خدمة";
      case ChurchRole.priest:
        return "كاهن أو راعي";
      default:
        return "";
    }
  }

  static String getGenderName(Gender gender) {
    switch (gender) {
      case Gender.male:
        return "ذكر";
      case Gender.female:
        return "انثى";
      default:
        return "";
    }
  }

  static _getChurchFromString(String? value) {
    return Church.values.firstWhere(
        (status) => status.toString().replaceAll("Church.", "") == value,
        orElse: () => Church.values.first);
  }

  static _getChurchRoleFromString(String? value) {
    return ChurchRole.values.firstWhereOrNull(
        (status) => status.toString().replaceAll("ChurchRole.", "") == value);
  }

  static _getGenderFromString(String? value) {
    return Gender.values.firstWhere(
        (status) => status.name == value,
        orElse: () => Gender.values.first);
  }
}
