import 'package:anawketaby/enums/church.dart';
import 'package:anawketaby/enums/church_role.dart';
import 'package:anawketaby/enums/gender.dart';
import 'package:anawketaby/models/user_features.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppUser {
  User? firebaseUser;
  String? id;
  String? fullName;
  String? phone;
  String? email;
  String? profilePhotoURL;
  Church? church;
  Gender? gender;
  Timestamp? birthDate;
  ChurchRole? churchRole;
  num? points;
  List<Map<String, dynamic>> pointsHistory = [];
  String? fcmToken;
  List<String>? followers = [];
  List<String> following = [];
  List<String?>? topicsFollowing = [];
  bool? isAdmin;
  List<String> participatedCompetitions = [];
  Map<String, dynamic> participatedCompetitionsTest = Map();
  UserFeatures? userFeatures;
  Timestamp? timeCreated;
  Timestamp? timeLastEdited;

  // Verification phone
  String? verificationId;
  num? resendToken;
  Timestamp? lastTryTime;

  // Temp photo
  PlatformFile? tempPickedImage;

  AppUser({
    this.firebaseUser,
    this.id,
    this.fullName,
    this.phone,
    this.email,
    this.profilePhotoURL,
    this.church,
    this.gender,
    this.birthDate,
    this.churchRole,
    this.points,
    pointsHistory = const [],
    this.fcmToken,
    this.followers = const [],
    this.following = const [],
    this.topicsFollowing = const [],
    this.isAdmin,
    this.participatedCompetitions = const [],
    this.participatedCompetitionsTest = const {},
    this.userFeatures,
    this.timeCreated,
    this.timeLastEdited,
    this.verificationId,
    this.resendToken,
    this.lastTryTime,
  }) {
    if (pointsHistory != null) {
      this.pointsHistory = List<Map<String, dynamic>>.from(pointsHistory);
      this
          .pointsHistory
          .sort((e, n) => n["timeCreated"].compareTo(e["timeCreated"]));
    }
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'phone': phone,
      'email': email,
      'profilePhotoURL': profilePhotoURL,
      'church':
          (church != null) ? church.toString().replaceAll("Church.", "") : null,
      'gender':
          (gender != null) ? gender.toString().replaceAll("Gender.", "") : null,
      'birthDate': birthDate,
      'churchRole': churchRole.toString().replaceAll("ChurchRole.", ""),
      'points': points,
      'pointsHistory': pointsHistory,
      'fcmToken': fcmToken,
      'followers': followers,
      'following': following,
      'topicsFollowing': topicsFollowing,
      'isAdmin': isAdmin,
      'participatedCompetitions': participatedCompetitions,
      'participatedCompetitionsTest': participatedCompetitionsTest,
      'userFeatures': userFeatures?.toJson(),
      'timeCreated': timeCreated,
      'timeLastEdited': timeLastEdited,
      'phoneVerificationID': verificationId ?? FieldValue.delete(),
      'phoneResendToken': resendToken ?? FieldValue.delete(),
      'phoneLastTryTime': lastTryTime ?? FieldValue.delete(),
    };
  }

  factory AppUser.fromJson(
      Map<String, dynamic>? doc, firebaseUser, String? docID) {
    if (doc == null) {
      return AppUser(
        firebaseUser: firebaseUser,
      );
    }

    AppUser user = AppUser(
      firebaseUser: firebaseUser,
      id: docID,
      fullName: doc['fullName'],
      phone: doc['phone'],
      email: doc['email'],
      profilePhotoURL: doc['profilePhotoURL'],
      church:
          (doc['church'] != null) ? _getChurchFromString(doc['church']) : null,
      gender:
          (doc['gender'] != null) ? _getGenderFromString(doc['gender']) : null,
      birthDate: doc['birthDate'],
      churchRole: _getChurchRoleFromString(doc['churchRole']),
      points: doc['points'],
      pointsHistory: (doc['pointsHistory'] != null)
          ? List<Map<String, dynamic>>.from(doc['pointsHistory'])
          : null,
      fcmToken: doc['fcmToken'],
      followers: (doc['followers'] != null)
          ? List<String>.from(doc['followers'])
          : null,
      following: List<String>.from(doc['following']),
      topicsFollowing: (doc['topicsFollowing'] != null)
          ? List<String>.from(doc['topicsFollowing'])
          : [],
      isAdmin: doc['isAdmin'],
      participatedCompetitions:
          List<String>.from(doc['participatedCompetitions']),
      participatedCompetitionsTest:
          Map<String, dynamic>.from(doc['participatedCompetitionsTest']),
      userFeatures: (doc['userFeatures'] != null)
          ? UserFeatures.fromJson(doc['userFeatures'])
          : null,
      timeCreated: doc['timeCreated'],
      timeLastEdited: doc['timeLastEdited'],
      verificationId: doc['phoneVerificationID'],
      resendToken: doc['phoneResendToken'],
      lastTryTime: doc['phoneLastTryTime'],
    );
    return user;
  }

  factory AppUser.fromDocument(DocumentSnapshot? doc, firebaseUser) {
    if (doc != null)
      return AppUser.fromJson(
          doc.data() as Map<String, dynamic>, firebaseUser, doc.id);
    else
      return AppUser.fromJson(null, firebaseUser, null);
  }

  String? getDisplayName() {
    return this.firebaseUser!.displayName;
  }

  String? getPhotoURL() {
    if (this.profilePhotoURL != null) return this.profilePhotoURL;

    // Check if there provider that linked to account
    // and retrieve its photo url from it.
    if (firebaseUser == null) return null;

    UserInfo? provider = firebaseUser!.providerData.firstWhereOrNull(
        (provider) =>
            provider.providerId == "google.com" ||
            provider.providerId == "facebook.com");

    if (provider != null) {
      this.profilePhotoURL = provider.photoURL! + "?type=large";
      FirebaseFirestore.instance.doc("users/${firebaseUser!.uid}").update({
        "profilePhotoURL": this.profilePhotoURL,
      });
      return provider.photoURL! + "?type=large";
    } else
      return null;
  }

  bool get isServantOrLeaderOrPriest =>
      churchRole == ChurchRole.servant ||
      churchRole == ChurchRole.leader ||
      churchRole == ChurchRole.priest;

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
        (status) => status.toString().replaceAll("Gender.", "") == value,
        orElse: () => Gender.values.first);
  }
}
