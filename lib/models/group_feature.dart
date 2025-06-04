import 'package:anawketaby/models/group_competition_creation_feature.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupFeature {
  static const String MEMBERS_LIMIT_KEY = 'membersLimit';
  static const String MODERATORS_LIMIT_KEY = 'moderatorsLimit';
  static const String GROUP_COMPETITION_CREATION_FEATURES_KEY =
      'groupCompetitionCreationFeature';

  int membersLimit;
  int moderatorsLimit;
  List<GroupCompetitionCreationFeature> groupCompetitionCreationFeature;

  GroupFeature({
    required this.membersLimit,
    required this.moderatorsLimit,
    required this.groupCompetitionCreationFeature,
  });

  Map<String, dynamic> toJson() {
    return {
      MEMBERS_LIMIT_KEY: membersLimit,
      MODERATORS_LIMIT_KEY: moderatorsLimit,
      GROUP_COMPETITION_CREATION_FEATURES_KEY:
          groupCompetitionCreationFeature.map((e) => e.toJson()).toList(),
    };
  }

  factory GroupFeature.fromJson(Map<String, dynamic> doc) {
    GroupFeature appGroup = GroupFeature(
      membersLimit: doc[MEMBERS_LIMIT_KEY],
      moderatorsLimit: doc[MODERATORS_LIMIT_KEY],
      groupCompetitionCreationFeature: List<Map<String, dynamic>>.from(
              doc[GROUP_COMPETITION_CREATION_FEATURES_KEY])
          .map((e) => GroupCompetitionCreationFeature.fromJson(e))
          .toList(),
    );
    return appGroup;
  }

  factory GroupFeature.fromDocument(DocumentSnapshot doc) {
    return GroupFeature.fromJson(doc.data() as Map<String, dynamic>);
  }
}
