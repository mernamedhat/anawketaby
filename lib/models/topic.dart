import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';

class Topic {
  static const String ID_KEY = 'id';
  static const String TOPIC_ID_KEY = 'topicID';
  static const String COMPETITIONS_IDS_KEY = 'competitionsIDs';
  static const String CREATOR_ID_KEY = 'creatorID';
  static const String CREATOR_FULL_NAME_KEY = 'creatorFullName';
  static const String NAME_KEY = 'name';
  static const String DESCRIPTION_KEY = 'description';
  static const String IMAGE_URL_KEY = 'imageURL';
  static const String TIME_CREATED_KEY = 'timeCreated';
  static const String FOLLOWERS_KEY = 'followers';
  static const String IS_ABLE_FOLLOWING_KEY = 'isAbleFollowing';
  static const String IS_SHOWING_KEY = 'isShowing';
  static const String RESULT_URL_KEY = 'resultURL';

  String? id;
  String? topicID;
  String? creatorID;
  String? creatorFullName;
  String? name;
  String? description;
  String? resultURL;
  String? imageURL;
  List<String> competitionsIDs;
  List<String>? followers;
  bool? isAbleFollowing;
  bool? isShowing;
  Timestamp? timeCreated;

  PlatformFile? tempPickedImage;

  Topic({
    this.id,
    this.topicID,
    this.creatorID,
    this.creatorFullName,
    this.name,
    this.description,
    this.resultURL,
    this.imageURL,
    this.competitionsIDs = const [],
    this.followers,
    this.isAbleFollowing,
    this.isShowing,
    this.timeCreated,
  });

  Map<String, dynamic> toJson() {
    return {
      ID_KEY: id,
      TOPIC_ID_KEY: topicID,
      CREATOR_ID_KEY: creatorID,
      CREATOR_FULL_NAME_KEY: creatorFullName,
      NAME_KEY: name,
      DESCRIPTION_KEY: description,
      RESULT_URL_KEY: resultURL,
      IMAGE_URL_KEY: imageURL,
      COMPETITIONS_IDS_KEY: competitionsIDs,
      FOLLOWERS_KEY: followers,
      IS_ABLE_FOLLOWING_KEY: isAbleFollowing,
      IS_SHOWING_KEY: isShowing,
      TIME_CREATED_KEY: timeCreated,
    };
  }

  factory Topic.fromJson(Map<String, dynamic> doc) {
    Topic topic = Topic(
      id: doc[ID_KEY],
      topicID: doc[TOPIC_ID_KEY],
      creatorID: doc[CREATOR_ID_KEY],
      creatorFullName: doc[CREATOR_FULL_NAME_KEY],
      name: doc[NAME_KEY],
      description: doc[DESCRIPTION_KEY],
      resultURL: doc[RESULT_URL_KEY],
      imageURL: doc[IMAGE_URL_KEY],
      competitionsIDs: List.from(doc[COMPETITIONS_IDS_KEY]),
      followers: List.from(doc[FOLLOWERS_KEY]),
      isAbleFollowing: doc[IS_ABLE_FOLLOWING_KEY],
      isShowing: doc[IS_SHOWING_KEY],
      timeCreated: doc[TIME_CREATED_KEY],
    );
    return topic;
  }

  factory Topic.fromDocument(DocumentSnapshot doc) {
    return Topic.fromJson(doc.data() as Map<String, dynamic>);
  }
}
