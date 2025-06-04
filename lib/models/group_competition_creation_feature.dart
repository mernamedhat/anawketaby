import 'package:anawketaby/enums/competition_creation_feature.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupCompetitionCreationFeature {
  static const String FEATURE_KEY = 'feature';
  static const String VALUE_KEY = 'value';
  static const String PROPERTIES_KEY = 'properties';
  static const String PROPERTIES_DEFAULT_KEY = 'default';

  CompetitionCreationFeature feature;
  bool value;
  Map<String, dynamic>? properties;

  GroupCompetitionCreationFeature({
    required this.feature,
    required this.value,
    this.properties,
  });

  Map<String, dynamic> toJson() {
    return {
      FEATURE_KEY: feature.name,
      VALUE_KEY: value,
      PROPERTIES_KEY: properties,
    };
  }

  factory GroupCompetitionCreationFeature.fromJson(Map<String, dynamic> doc) {
    GroupCompetitionCreationFeature appGroup = GroupCompetitionCreationFeature(
      feature: competitionCreationFeatureFromString(doc[FEATURE_KEY]),
      value: doc[VALUE_KEY],
      properties:
          (doc[PROPERTIES_KEY] != null) ? Map.from(doc[PROPERTIES_KEY]) : null,
    );
    return appGroup;
  }

  factory GroupCompetitionCreationFeature.fromDocument(DocumentSnapshot doc) {
    return GroupCompetitionCreationFeature.fromJson(
        doc.data() as Map<String, dynamic>);
  }
}
