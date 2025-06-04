import 'package:anawketaby/models/group_competition_creation_feature.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppFeature {
  static const String GROUP_CREATION_LIMIT_KEY = 'groupCreationLimit';

  int groupCreationLimit;

  AppFeature({
    required this.groupCreationLimit,
  });

  Map<String, dynamic> toJson() {
    return {
      GROUP_CREATION_LIMIT_KEY: groupCreationLimit,
    };
  }

  factory AppFeature.fromJson(Map<String, dynamic> doc) {
    AppFeature appGroup = AppFeature(
      groupCreationLimit: doc[GROUP_CREATION_LIMIT_KEY],
    );
    return appGroup;
  }

  factory AppFeature.fromDocument(DocumentSnapshot doc) {
    return AppFeature.fromJson(doc.data() as Map<String, dynamic>);
  }
}
