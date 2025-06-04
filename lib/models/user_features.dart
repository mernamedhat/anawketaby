import 'package:anawketaby/models/app_feature.dart';
import 'package:anawketaby/models/group_feature.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserFeatures {
  static const String APP_FEATURE_KEY = 'appFeature';
  static const String GROUP_FEATURE_KEY = 'groupFeature';

  AppFeature? appFeature;
  GroupFeature? groupFeature;

  UserFeatures({
    required this.appFeature,
    required this.groupFeature,
  });

  Map<String, dynamic> toJson() {
    return {
      APP_FEATURE_KEY: appFeature?.toJson(),
      GROUP_FEATURE_KEY: groupFeature?.toJson(),
    };
  }

  factory UserFeatures.fromJson(Map<String, dynamic> doc) {
    UserFeatures appGroup = UserFeatures(
      appFeature: (doc[APP_FEATURE_KEY] != null)
          ? AppFeature.fromJson(doc[APP_FEATURE_KEY])
          : null,
      groupFeature: (doc[GROUP_FEATURE_KEY] != null)
          ? GroupFeature.fromJson(doc[GROUP_FEATURE_KEY])
          : null,
    );
    return appGroup;
  }

  factory UserFeatures.fromDocument(DocumentSnapshot doc) {
    return UserFeatures.fromJson(doc.data() as Map<String, dynamic>);
  }
}
