import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/models/group_feature.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';

class AppGroup {
  static const String ID_KEY = 'id';
  static const String SHARE_ID_KEY = 'shareID';
  static const String CREATOR_ID_KEY = 'creatorID';
  static const String CREATOR_FULL_NAME_KEY = 'creatorFullName';
  static const String LEADER_ID_KEY = 'leaderID';
  static const String LEADER_FULL_NAME_KEY = 'leaderFullName';
  static const String MODERATORS_IDS_KEY = 'moderatorsIDs';
  static const String MEMBERS_IDS_KEY = 'membersIDs';
  static const String MEMBERS_FCM_TOKENS_KEY = 'membersFCMTokens';
  static const String MEMBERS_PROFILES_KEY = 'membersProfiles';
  static const String NAME_KEY = 'name';
  static const String DESCRIPTION_KEY = 'description';
  static const String IMAGE_URL_KEY = 'imageURL';
  static const String CREATED_COMPETITIONS_KEY = 'createdCompetitions';
  static const String IS_ACTIVATED_KEY = 'isActivated';
  static const String IS_ARCHIVED_KEY = 'isArchived';
  static const String MEMBERS_LIMIT_KEY = 'membersLimit';
  static const String MODERATORS_LIMIT_KEY = 'moderatorsLimit';
  static const String GROUP_FEATURE_KEY = 'groupFeature';
  static const String TIME_CREATED_KEY = 'timeCreated';

  String? id;
  String? shareID;
  String creatorID;
  String creatorFullName;
  String leaderID;
  String leaderFullName;
  List<String> moderatorsIDs;
  List<String> membersIDs;
  List<String> membersFCMTokens;
  Map<String, dynamic> membersProfiles;
  String name;
  String description;
  String? imageURL;
  List<String> createdCompetitions = [];
  bool isActivated;
  bool isArchived;
  GroupFeature groupFeature;
  Timestamp? timeCreated;

  PlatformFile? tempPickedImage;

  AppGroup({
    this.id,
    this.shareID,
    required this.creatorID,
    required this.creatorFullName,
    required this.leaderID,
    required this.leaderFullName,
    required this.moderatorsIDs,
    required this.membersIDs,
    required this.membersFCMTokens,
    required this.membersProfiles,
    required this.name,
    required this.description,
    this.imageURL,
    required this.createdCompetitions,
    required this.isActivated,
    required this.isArchived,
    required this.groupFeature,
    this.timeCreated,
  });

  Map<String, dynamic> toJson() {
    return {
      ID_KEY: id,
      SHARE_ID_KEY: shareID,
      CREATOR_ID_KEY: creatorID,
      CREATOR_FULL_NAME_KEY: creatorFullName,
      LEADER_ID_KEY: leaderID,
      LEADER_FULL_NAME_KEY: leaderFullName,
      MODERATORS_IDS_KEY: moderatorsIDs,
      MEMBERS_IDS_KEY: membersIDs,
      MEMBERS_FCM_TOKENS_KEY: membersFCMTokens,
      MEMBERS_PROFILES_KEY: membersProfiles,
      NAME_KEY: name,
      DESCRIPTION_KEY: description,
      IMAGE_URL_KEY: imageURL,
      CREATED_COMPETITIONS_KEY: createdCompetitions,
      IS_ACTIVATED_KEY: isActivated,
      IS_ARCHIVED_KEY: isArchived,
      GROUP_FEATURE_KEY: groupFeature.toJson(),
      TIME_CREATED_KEY: timeCreated,
    };
  }

  factory AppGroup.fromJson(Map<String, dynamic> doc) {
    AppGroup appGroup = AppGroup(
      id: doc[ID_KEY],
      shareID: doc[SHARE_ID_KEY],
      creatorID: doc[CREATOR_ID_KEY],
      creatorFullName: doc[CREATOR_FULL_NAME_KEY],
      leaderID: doc[LEADER_ID_KEY],
      leaderFullName: doc[LEADER_FULL_NAME_KEY],
      moderatorsIDs: List<String>.from(doc[MODERATORS_IDS_KEY]),
      membersIDs: List<String>.from(doc[MEMBERS_IDS_KEY]),
      membersFCMTokens: List<String>.from(doc[MEMBERS_FCM_TOKENS_KEY]),
      membersProfiles: Map.from(doc[MEMBERS_PROFILES_KEY]),
      name: doc[NAME_KEY],
      description: doc[DESCRIPTION_KEY],
      imageURL: doc[IMAGE_URL_KEY],
      createdCompetitions: List<String>.from(doc[CREATED_COMPETITIONS_KEY]),
      isActivated: doc[IS_ACTIVATED_KEY],
      isArchived: doc[IS_ARCHIVED_KEY],
      groupFeature: GroupFeature.fromJson(doc[GROUP_FEATURE_KEY]),
      timeCreated: doc[TIME_CREATED_KEY],
    );
    return appGroup;
  }

  factory AppGroup.fromDocument(DocumentSnapshot doc) {
    return AppGroup.fromJson(doc.data() as Map<String, dynamic>);
  }

  bool isLeaderOrModerator(AppUser user) =>
      user.id == leaderID || moderatorsIDs.contains(user.id);
}
