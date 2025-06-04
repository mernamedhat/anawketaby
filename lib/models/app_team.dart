import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';

class AppTeam {
  static const String ID_KEY = 'id';
  static const String CREATOR_ID_KEY = 'creatorID';
  static const String CREATOR_FULL_NAME_KEY = 'creatorFullName';
  static const String LEADER_ID_KEY = 'leaderID';
  static const String LEADER_FULL_NAME_KEY = 'leaderFullName';
  static const String MEMBERS_IDS_KEY = 'membersIDs';
  static const String MEMBERS_FCM_TOKENS_KEY = 'membersFCMTokens';
  static const String MEMBERS_PROFILES_KEY = 'membersProfiles';
  static const String NAME_KEY = 'name';
  static const String DESCRIPTION_KEY = 'description';
  static const String IMAGE_URL_KEY = 'imageURL';
  static const String PARTICIPATED_COMPETITIONS_KEY =
      'participatedCompetitions';
  static const String TIME_CREATED_KEY = 'timeCreated';

  String? id;
  String creatorID;
  String creatorFullName;
  String leaderID;
  String leaderFullName;
  List<String> membersIDs;
  List<String> membersFCMTokens;
  Map<String, dynamic> membersProfiles;
  String name;
  String description;
  String? imageURL;
  List<String> participatedCompetitions = [];
  Timestamp? timeCreated;

  PlatformFile? tempPickedImage;

  AppTeam({
    this.id,
    required this.creatorID,
    required this.creatorFullName,
    required this.leaderID,
    required this.leaderFullName,
    required this.membersIDs,
    required this.membersFCMTokens,
    required this.membersProfiles,
    required this.name,
    required this.description,
    this.imageURL,
    required this.participatedCompetitions,
    this.timeCreated,
  });

  Map<String, dynamic> toJson() {
    return {
      ID_KEY: id,
      CREATOR_ID_KEY: creatorID,
      CREATOR_FULL_NAME_KEY: creatorFullName,
      LEADER_ID_KEY: leaderID,
      LEADER_FULL_NAME_KEY: leaderFullName,
      MEMBERS_IDS_KEY: membersIDs,
      MEMBERS_FCM_TOKENS_KEY: membersFCMTokens,
      MEMBERS_PROFILES_KEY: membersProfiles,
      NAME_KEY: name,
      DESCRIPTION_KEY: description,
      IMAGE_URL_KEY: imageURL,
      PARTICIPATED_COMPETITIONS_KEY: participatedCompetitions,
      TIME_CREATED_KEY: timeCreated,
    };
  }

  factory AppTeam.fromJson(Map<String, dynamic> doc) {
    AppTeam appTeam = AppTeam(
      id: doc[ID_KEY],
      creatorID: doc[CREATOR_ID_KEY],
      creatorFullName: doc[CREATOR_FULL_NAME_KEY],
      leaderID: doc[LEADER_ID_KEY],
      leaderFullName: doc[LEADER_FULL_NAME_KEY],
      membersIDs: List<String>.from(doc[MEMBERS_IDS_KEY]),
      membersFCMTokens: List<String>.from(doc[MEMBERS_FCM_TOKENS_KEY]),
      membersProfiles: Map.from(doc[MEMBERS_PROFILES_KEY]),
      name: doc[NAME_KEY],
      description: doc[DESCRIPTION_KEY],
      imageURL: doc[IMAGE_URL_KEY],
      participatedCompetitions:
          List<String>.from(doc[PARTICIPATED_COMPETITIONS_KEY]),
      timeCreated: doc[TIME_CREATED_KEY],
    );
    return appTeam;
  }

  factory AppTeam.fromDocument(DocumentSnapshot doc) {
    return AppTeam.fromJson(doc.data() as Map<String, dynamic>);
  }
}
