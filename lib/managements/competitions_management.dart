/*
 * Copyright (c) 2021 Shady Boshra.
 * IN: https://LinkedIn.com/in/ShadyBoshra2012
 * GitHub: https://github.com/ShadyBoshra2012
 * Mostaql: https://mostaql.com/u/ShadyBoshra2012
 */

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as Math;
import 'dart:math';

import 'package:anawketaby/enums/competition_type.dart';
import 'package:anawketaby/enums/points_history_type.dart';
import 'package:anawketaby/managements/groups_management.dart';
import 'package:anawketaby/models/app_group.dart';
import 'package:anawketaby/models/app_team.dart';
import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/models/competition.dart';
import 'package:anawketaby/models/competition_participant.dart';
import 'package:anawketaby/models/competition_participant_individual.dart';
import 'package:anawketaby/models/competition_participant_team.dart';
import 'package:anawketaby/models/point_history.dart';
import 'package:anawketaby/providers_models/main/user_provider.dart';
import 'package:anawketaby/services/firestore_paths.dart';
import 'package:anawketaby/utils/real_time.dart';
import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class CompetitionManagement {
  CompetitionManagement._();

  static final instance = CompetitionManagement._();
  Future<bool> createCompetition(Competition competition, AppUser appUser, {AppGroup? group}) async {
    try {
      DocumentReference docRef = FirebaseFirestore.instance.collection(FirestorePaths.competitionsCollections()).doc();
      competition.id = docRef.id;
      competition.creatorID = appUser.firebaseUser!.uid;
      competition.creatorFullName = appUser.fullName;
      competition.timeCreated = Timestamp.now();
      competition.timeLastEdit = Timestamp.now();
      competition.winnersIDs = <String>[];
      competition.participantsCount=0;



      final code = await _generateCompetitionCode();


      competition.competitionCode = code;
      competition.url='https://app.anawketaby.com/c/${code}';

      await docRef.set(competition.toJson());

      // Update user and group if necessary
      if (group != null) {
              group.createdCompetitions.add(competition.id!);
              await GroupsManagement.instance.editGroup(group, appUser);
        // await FirebaseFirestore.instance.doc(FirestorePaths.groupDocument(group.id!)).update({
        //   'competitionsIDs': FieldValue.arrayUnion([competition.id]),
        // });
      }

      await FirebaseFirestore.instance.doc(FirestorePaths.userDocument(appUser.firebaseUser!.uid)).update({
        'competitionsCreated': FieldValue.arrayUnion([competition.id]),
      });

      return true;
    } catch (ex) {
      print('Error creating competition: $ex');
      return false;
    }
  }

  Future<int> _generateCompetitionCode() async {
    final collection = FirebaseFirestore.instance.collection(FirestorePaths.competitionsCollections());
    final querySnapshot = await collection
        .orderBy('competitionCode', descending: true)
        .limit(1)
        .get();

    int lastCode = 1000;

    if (querySnapshot.docs.isNotEmpty) {
      final lastDoc = querySnapshot.docs.first;
      final lastCodeFromDB = lastDoc.get('competitionCode');
      if (lastCodeFromDB is int && lastCodeFromDB >= 1000) {
        lastCode = lastCodeFromDB;
      }
    }

    return lastCode + 1;
  }
  Future<Competition?> getCompetition(String id) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .doc(FirestorePaths.competitionsDocument(id))
          .get();
      if (doc.exists) {
        return Competition.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (ex) {
      print('Error getting competition: $ex');
      return null;
    }
  }

  Stream<DocumentSnapshot> getCompetitionStream(String? id) {
    return FirebaseFirestore.instance
        .doc(FirestorePaths.competitionsDocument(id!))
        .snapshots();
  }

  Future<Competition?> getCompetitionByCode(int code) async {
    try {
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection(FirestorePaths.competitionsCollections())
          .where('competitionCode', isEqualTo: code)
          .limit(1)
          .get();
      if (query.docs.isNotEmpty) {
        return Competition.fromJson(query.docs.first.data() as Map<String, dynamic>);
      }
      return null;
    } catch (ex) {
      print('Error getting competition by code: $ex');
      return null;
    }
  }

  Future<bool> editCompetition(Competition competition, AppUser? appUser, {bool shareOnly = false}) async {
    try {
      competition.timeLastEdit = Timestamp.now();
      await FirebaseFirestore.instance
          .doc(FirestorePaths.competitionsDocument(competition.id!))
          .update(competition.toJson());
      return true;
    } catch (ex) {
      print('Error editing competition: $ex');
      return false;
    }
  }

  // Future<bool> createCompetition(Competition competition, AppUser appUser,
  //     {AppGroup? group}) async
  // {
  //   try {
  //     DocumentReference doc = FirebaseFirestore.instance
  //         .collection("${FirestorePaths.competitionsCollections()}")
  //         .doc();
  //
  //     if (competition.tempPickedImage != null) {
  //       String imagesURL =
  //           await uploadCompetitionImage(competition.tempPickedImage!, doc.id);
  //       competition.imageURL = imagesURL;
  //     }
  //
  //     // Remove seconds and milliseconds in times
  //     final timeStart = competition.timeStart!.toDate();
  //     competition.timeStart = Timestamp.fromDate(DateTime(timeStart.year,
  //         timeStart.month, timeStart.day, timeStart.hour, timeStart.minute));
  //
  //     final timeEnd = competition.timeEnd!.toDate();
  //     competition.timeEnd = Timestamp.fromDate(DateTime(timeEnd.year,
  //         timeEnd.month, timeEnd.day, timeEnd.hour, timeEnd.minute));
  //
  //     // Change minutes to seconds
  //     competition.durationCompetitionSeconds =
  //         competition.durationCompetitionSeconds! * 60;
  //
  //     // Set default values
  //     competition.isPopular = false;
  //     competition.isResultPublished = false;
  //     competition.archived = false;
  //     competition.winnersIDs = [];
  //
  //     // Calculate time to result.
  //     var seconds;
  //     if (competition.durationPerCompetition!) {
  //       seconds = competition.durationCompetitionSeconds;
  //     } else {
  //       seconds = competition.questions
  //           .map((e) => e.durationSeconds)
  //           .reduce((value, element) => value = value! + element!);
  //       while (seconds % 60 != 0) {
  //         seconds++;
  //       }
  //     }
  //     competition.timeCalculateResults = Timestamp.fromDate(
  //         competition.timeEnd!.toDate().add(Duration(seconds: seconds)));
  //
  //     competition.participantsCount = 0;
  //     competition.id = doc.id;
  //     competition.creatorID = appUser.firebaseUser!.uid;
  //     competition.creatorFullName = appUser.fullName;
  //     competition.timeCreated = Timestamp.fromDate(RealTime.instance.now!);
  //
  //     await doc.set(competition.toJson());
  //
  //     if (group != null) {
  //       group.createdCompetitions.add(competition.id!);
  //       await GroupsManagement.instance.editGroup(group, appUser);
  //     }
  //
  //     return true;
  //   } catch (ex) {
  //     return false;
  //   }
  // }

  // Future<bool> editCompetition(Competition competition, AppUser? appUser,
  //     {bool shareOnly = false}) async
  // {
  //   try {
  //     DocumentReference doc = FirebaseFirestore.instance
  //         .doc("${FirestorePaths.competitionsDocument("${competition.id}")}");
  //
  //     if (competition.tempPickedImage != null) {
  //       String imagesURL =
  //           await uploadCompetitionImage(competition.tempPickedImage!, doc.id);
  //       competition.imageURL = imagesURL;
  //     }
  //
  //     // Change minutes to seconds
  //     if (!shareOnly)
  //       competition.durationCompetitionSeconds =
  //           competition.durationCompetitionSeconds! * 60;
  //
  //     // Remove seconds and milliseconds in times
  //     final timeStart = competition.timeStart!.toDate();
  //     competition.timeStart = Timestamp.fromDate(DateTime(timeStart.year,
  //         timeStart.month, timeStart.day, timeStart.hour, timeStart.minute));
  //
  //     final timeEnd = competition.timeEnd!.toDate();
  //     competition.timeEnd = Timestamp.fromDate(DateTime(timeEnd.year,
  //         timeEnd.month, timeEnd.day, timeEnd.hour, timeEnd.minute));
  //
  //     // Calculate time to result.
  //     var seconds;
  //     if (competition.durationPerCompetition!) {
  //       seconds = competition.durationCompetitionSeconds;
  //     } else {
  //       seconds = competition.questions
  //           .map((e) => e.durationSeconds)
  //           .reduce((value, element) => value = value! + element!);
  //       while (seconds % 60 != 0) {
  //         seconds++;
  //       }
  //     }
  //
  //     if (!shareOnly)
  //       competition.timeCalculateResults = Timestamp.fromDate(
  //           competition.timeEnd!.toDate().add(Duration(seconds: seconds)));
  //
  //     competition.timeLastEdit = Timestamp.fromDate(RealTime.instance.now!);
  //
  //     await doc.update(competition.toJson());
  //
  //     return true;
  //   } catch (ex) {
  //     return false;
  //   }
  // }

  Future<String> uploadCompetitionImage(
      PlatformFile image, String competitionID) async
  {
    String timestampId;
    Reference reference;
    UploadTask uploadTask;
    TaskSnapshot storageTaskSnapshot;

    await deleteOldImages(FirebaseStorage.instance
        .ref()
        .child("${FirestorePaths.competitionsCollections()}/$competitionID"));

    timestampId = DateTime.now().millisecondsSinceEpoch.toString();
    reference = FirebaseStorage.instance.ref().child(
        "${FirestorePaths.competitionsCollections()}/$competitionID/$timestampId");
    uploadTask = reference.putFile(File(image.path!));
    storageTaskSnapshot = await uploadTask;
    String imageUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return imageUrl;
  }

  Future deleteOldImages(Reference reference) async {
    ListResult list = await reference.listAll();
    for (Reference file in list.items) {
      await file.delete();
    }
  }

  Stream<dynamic> getMyCompetitions({int? limit}) {
    final appUserID =
        Provider.of<UserProvider>(Get.context!, listen: false).appUser!.id;

    final List<Stream<QuerySnapshot<Object?>>> queries = [];

    Query query1 = FirebaseFirestore.instance
        .collection("competitions")
        .where("participantsIDs", arrayContains: appUserID);

    Query query2 = FirebaseFirestore.instance
        .collection("competitions")
        .where("participantsTeamsMembersIDs", arrayContains: appUserID);

    Query query3 = FirebaseFirestore.instance
        .collection("competitions")
        .where("participantsIDsTestYourself", arrayContains: appUserID);

    if (limit != null) {
      query1 = query1.limit(limit);
      query2 = query2.limit(limit);
      query3 = query3.limit(limit);
    }

    queries.add(query1.snapshots());
    queries.add(query2.snapshots());
    queries.add(query3.snapshots());

    return StreamZip(queries).asBroadcastStream();
  }

  Future<bool> deleteCompetition(Competition competition) async {
    try {
      DocumentReference doc = FirebaseFirestore.instance
          .doc("${FirestorePaths.competitionsDocument(competition.id)}");

      await doc.delete();

      return true;
    } catch (ex) {
      return false;
    }
  }

  Future<bool> archiveCompetition(Competition competition) async {
    try {
      DocumentReference doc = FirebaseFirestore.instance
          .doc("${FirestorePaths.competitionsDocument(competition.id)}");

      await doc.update({"archived": true});

      return true;
    } catch (ex) {
      return false;
    }
  }

  Future<bool> unArchiveCompetition(Competition competition) async {
    try {
      DocumentReference doc = FirebaseFirestore.instance
          .doc("${FirestorePaths.competitionsDocument(competition.id)}");

      await doc.update({"archived": false});

      return true;
    } catch (ex) {
      return false;
    }
  }

  Stream<QuerySnapshot> getMyCreationCompetitions(AppUser appUser) {
    return FirebaseFirestore.instance
        .collection("competitions")
        .where("creatorID", isEqualTo: appUser.id)
        .orderBy('timeCreated', descending: true)
        .snapshots();
  }

  Future<QuerySnapshot> getMyCreationCompetitionsFuture(AppUser appUser,
      {int? limit})
  {
    Query query = FirebaseFirestore.instance
        .collection("competitions")
        .where("creatorID", isEqualTo: appUser.id)
        .orderBy('timeCreated', descending: true);

    if (limit != null) query = query.limit(limit);

    return query.get();
  }

  Stream<QuerySnapshot> getPopularCompetitions({int? limit}) {
    Query query = FirebaseFirestore.instance
        .collection("${FirestorePaths.competitionsCollections()}")
        .where("isPopular", isEqualTo: true)
        .where("timeStart",
            isGreaterThanOrEqualTo: Timestamp.fromDate(RealTime.instance.now!))
        .where("archived", isEqualTo: false)
        .orderBy("timeStart", descending: true);

    if (limit != null) query = query.limit(limit);

    return query.snapshots();
  }

  Stream<List<QuerySnapshot>> getTestYourselfCompetitions({int? limit}) {
    List<String> alreadyCompetitionsTested =
        Provider.of<UserProvider>(Get.context!, listen: false)
            .appUser!
            .participatedCompetitionsTest
            .keys
            .toList();

    if (alreadyCompetitionsTested.isEmpty) {
      alreadyCompetitionsTested.add("");
    }

    alreadyCompetitionsTested.sort((s1, s2) => s1.compareTo(s2));

    final List<Stream<QuerySnapshot>> queries = [];

    while (alreadyCompetitionsTested.isNotEmpty) {
      int lastItemCount = Math.min(10, alreadyCompetitionsTested.length);
      List<String> takenIDs =
          alreadyCompetitionsTested.sublist(0, lastItemCount);

      Query query = FirebaseFirestore.instance
          .collection("${FirestorePaths.competitionsCollections()}")
          .where("id", whereNotIn: takenIDs)
          .where("isTestYourself", isEqualTo: true)
          .where("isResultPublished", isEqualTo: true)
          .where("archived", isEqualTo: false);

      if (limit != null)
        query = query.limit(limit);
      else
        query = query.limit(10);

      queries.add(query.snapshots());

      alreadyCompetitionsTested.removeWhere((e) => takenIDs.contains(e));
    }

    return StreamZip(queries).asBroadcastStream();
  }

  Stream<List<QuerySnapshot>> getPublishedCompetitions({int? limit}) {
    final List<Stream<QuerySnapshot>> queries = [];

    Query query1 = FirebaseFirestore.instance
        .collection("${FirestorePaths.competitionsCollections()}")
        .where("isResultPublished", isEqualTo: false)
        .where("isPublishBeforeStartTime", isEqualTo: true)
        .where("timePublished",
            isLessThanOrEqualTo: Timestamp.fromDate(RealTime.instance.now!))
        .where("archived", isEqualTo: false)
        .where("groupsIDs", isNull: true)
        .orderBy("timePublished", descending: true);

    if (limit != null) query1 = query1.limit(limit);

    queries.add(query1.snapshots());

    Query query2 = FirebaseFirestore.instance
        .collection("${FirestorePaths.competitionsCollections()}")
        .where("isResultPublished", isEqualTo: false)
        .where("isPublishBeforeStartTime", isEqualTo: false)
        .where("timeStart",
            isLessThanOrEqualTo: Timestamp.fromDate(RealTime.instance.now!))
        .where("archived", isEqualTo: false)
        .where("groupsIDs", isNull: true)
        .orderBy("timeStart", descending: true);

    if (limit != null) query2 = query2.limit(limit);

    queries.add(query2.snapshots());

    // Query query3 = FirebaseFirestore.instance
    //     .collection("${FirestorePaths.competitionsCollections()}")
    //     .where("isResultPublished", isEqualTo: false)
    //     .where("isPublishBeforeStartTime", isEqualTo: false)
    //     .where("timeStart",
    //         isLessThanOrEqualTo: Timestamp.fromDate(RealTime.instance.now!))
    //     .where("archived", isEqualTo: false)
    //     .where("groupsIDs", arrayContains: true)
    //     .orderBy("timeStart", descending: true);
    //
    // if (limit != null) query3 = query3.limit(limit);
    //
    // queries.add(query3.snapshots());

    return StreamZip(queries).asBroadcastStream();
  }

  // Stream getCompetitionStream(String? competitionID) {
  //   return FirebaseFirestore.instance
  //       .doc("${FirestorePaths.competitionsDocument(competitionID)}")
  //       .snapshots();
  // }

  Future<Competition?> getCompetitionByID(String competitionID) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .doc("${FirestorePaths.competitionsDocument(competitionID)}")
        .get();

    if (doc.exists)
      return Competition.fromDocument(doc);
    else
      return null;
  }

  Future<List<Competition>> getCompetitionsByIDs(
      List<String?> originalCompetitionsIDs) async
  {
    final List<String?> competitionsIDs = [...originalCompetitionsIDs];
    final List<Competition> competitions = [];

    while (competitionsIDs.length > 0) {
      final tempCompetitionsIDs =
      competitionsIDs.getRange(0, min(10, competitionsIDs.length)).toList();
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(FirestorePaths.competitionsCollections())
          .where("id", whereIn: tempCompetitionsIDs)
          .get();

      for (final doc in snapshot.docs) {
        Competition competition = Competition.fromDocument(doc);
        competitions.add(competition);
      }
      competitionsIDs.removeWhere((e) => tempCompetitionsIDs.contains(e));
    }

    competitions.sort((a, b) => a.timeStart!.compareTo(b.timeStart!));

    return competitions;
  }

  // Future<Competition?> getCompetitionByCode(int competitionCode) async {
  //   List<QueryDocumentSnapshot> docs = (await FirebaseFirestore.instance
  //           .collection("${FirestorePaths.competitionsCollections()}")
  //           .where("competitionCode", isEqualTo: competitionCode)
  //           .where("archived", isEqualTo: false)
  //           .get())
  //       .docs;
  //
  //   if (docs.isNotEmpty)
  //     return Competition.fromDocument(docs.first);
  //   else
  //     return null;
  // }

  Future<bool> participateIndividualCompetition(
      AppUser appUser, Competition competition) async
  {
    DocumentReference newParticipantDocReference = FirebaseFirestore.instance
        .collection(
            FirestorePaths.competitionParticipantsIndividualsCollections(
                competition.id))
        .doc(appUser.firebaseUser!.uid);

    DocumentReference appUserDocReference = FirebaseFirestore.instance
        .doc(FirestorePaths.userDocument(appUser.firebaseUser!.uid));

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      CompetitionParticipantIndividual participant =
          CompetitionParticipantIndividual(
        id: appUser.firebaseUser!.uid,
        fullName: appUser.fullName,
        profilePhotoURL: appUser.profilePhotoURL,
        fcmToken: appUser.fcmToken,
        points: 0,
        answers: [],
        statusStarted: false,
        statusFinished: false,
        timeStarted: null,
        timeFinished: null,
        timeParticipated: Timestamp.fromDate(RealTime.instance.now!),
      );

      transaction
          .set(newParticipantDocReference, participant.toJson())
          .update(appUserDocReference, {
        'participatedCompetitions': FieldValue.arrayUnion([competition.id]),
        'points': FieldValue.increment(-competition.participationPoints!),
        "pointsHistory": FieldValue.arrayUnion([
          {
            "type": "competition_participation",
            "competitionCode": competition.competitionCode,
            "competitionID": competition.id,
            "points": -competition.participationPoints!,
            "timeCreated": Timestamp.fromDate(RealTime.instance.now!),
          }
        ]),
      });
      return true;
    }).then((_) {
      competition.participantsCount = competition.participantsCount! + 1;
      appUser.participatedCompetitions.add(competition.id!);
      return true;
    }).catchError((e) {
      return false;
    });
  }

  Future<bool> unParticipateCompetition(
      AppUser appUser, Competition competition) async
  {
    DocumentReference newParticipantDocReference = FirebaseFirestore.instance
        .collection(
            FirestorePaths.competitionParticipantsIndividualsCollections(
                competition.id))
        .doc(appUser.firebaseUser!.uid);

    DocumentReference appUserDocReference = FirebaseFirestore.instance
        .doc(FirestorePaths.userDocument(appUser.firebaseUser!.uid));

    // find timestamp of timeCreated point history of this competition
    // to be removed from user doc.
    DocumentSnapshot doc = await appUserDocReference.get();
    AppUser updatedAppUser = AppUser.fromDocument(doc, null);

    Map? pointHistoryMap = updatedAppUser.pointsHistory.firstWhereOrNull((e) {
      PointHistory pointHistory = PointHistory.fromJson(e);
      return pointHistory.type == PointsHistoryType.competition_participation &&
          pointHistory.competitionCode == competition.competitionCode;
    });

    Timestamp? timestamp;
    if (pointHistoryMap != null) {
      PointHistory pointHistory =
          PointHistory.fromJson(pointHistoryMap as Map<String, dynamic>);
      timestamp = pointHistory.timeCreated;
    }

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction
          .delete(newParticipantDocReference)
          .update(appUserDocReference, {
        'participatedCompetitions': FieldValue.arrayRemove([competition.id]),
        'points': FieldValue.increment(competition.participationPoints!),
        "pointsHistory": FieldValue.arrayRemove([
          {
            "type": "competition_participation",
            "competitionCode": competition.competitionCode,
            "competitionID": competition.id,
            "points": -competition.participationPoints!,
            "timeCreated": timestamp,
          }
        ]),
      });
      return true;
    }).then((_) {
      competition.participantsCount = competition.participantsCount! - 1;
      appUser.participatedCompetitions.remove(competition.id);
      return true;
    }).catchError((e) {
      return false;
    });
  }

  Future<bool> participateTeamCompetition(
      AppTeam team, Competition competition) async
  {
    DocumentReference newParticipantDocReference = FirebaseFirestore.instance
        .collection(FirestorePaths.competitionParticipantsTeamsCollections(
            competition.id))
        .doc(team.id);

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      CompetitionParticipantTeam participant = CompetitionParticipantTeam(
        id: team.id,
        points: 0,
        answers: [],
        statusStarted: false,
        statusFinished: false,
        timeStarted: null,
        timeFinished: null,
        timeParticipated: Timestamp.fromDate(RealTime.instance.now!),
        leaderID: team.leaderID,
        leaderFullName: team.leaderFullName,
        membersIDs: team.membersIDs,
        membersFCMTokens: team.membersFCMTokens,
        membersProfiles: team.membersProfiles,
        name: team.name,
        description: team.description,
        imageURL: team.imageURL,
      );

      transaction
          .set(newParticipantDocReference, participant.toJson())
          .update(FirebaseFirestore.instance.doc("teams/${team.id}"), {
        "participatedCompetitions": FieldValue.arrayUnion([competition.id]),
      });
      return true;
    }).then((_) {
      competition.participantsCount = competition.participantsCount! + 1;
      team.participatedCompetitions.add(competition.id!);
      return true;
    }).catchError((e) {
      return false;
    });
  }

  Stream<QuerySnapshot> getParticipants(Competition competition) {
    return FirebaseFirestore.instance
        .collection((competition.competitionType == CompetitionType.individual)
            ? "${FirestorePaths.competitionParticipantsIndividualsCollections(competition.id)}"
            : "${FirestorePaths.competitionParticipantsTeamsCollections(competition.id)}")
        .orderBy("points", descending: true)
        .orderBy("timeStarted")
        .snapshots();
  }

  Future<List> getWinners(Competition competition) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection((competition.competitionType == CompetitionType.individual)
            ? "${FirestorePaths.competitionParticipantsIndividualsCollections(competition.id)}"
            : "${FirestorePaths.competitionParticipantsTeamsCollections(competition.id)}")
        .where("id", whereIn: competition.winnersIDs)
        .orderBy("points")
        .get();

    List winners = [];
    for (final doc in snapshot.docs) {
      if (competition.competitionType == CompetitionType.individual) {
        final participant = CompetitionParticipantIndividual.fromDocument(doc);
        winners.add(participant);
      } else {
        final team = CompetitionParticipantTeam.fromDocument(doc);
        winners.add(team);
      }
    }

    winners.sort((a, b) => b.points.compareTo(a.points));

    return winners;
  }

  Future<List> startedParticipantCompetition(
    Competition competition, {
    AppUser? appUser,
    AppTeam? team,
  }) async
  {
    DocumentSnapshot participantDoc = (team == null)
        ? await FirebaseFirestore.instance
            .collection(
                FirestorePaths.competitionParticipantsIndividualsCollections(
                    competition.id))
            .doc(appUser!.firebaseUser!.uid)
            .get()
        : await FirebaseFirestore.instance
            .collection(FirestorePaths.competitionParticipantsTeamsCollections(
                competition.id))
            .doc(team.id)
            .get();

    bool isStarted = participantDoc.get('statusStarted');

    if (!isStarted) {
      List<int> questionsOrder =
          List.generate(competition.questions.length, (index) => index + 1);

      if (competition.shuffleQuestions != null &&
          competition.shuffleQuestions == true) {
        questionsOrder.shuffle();
      }

      DocumentReference participantDocReference = (team == null)
          ? FirebaseFirestore.instance
              .collection(
                  FirestorePaths.competitionParticipantsIndividualsCollections(
                      competition.id))
              .doc(appUser!.firebaseUser!.uid)
          : FirebaseFirestore.instance
              .collection(
                  FirestorePaths.competitionParticipantsTeamsCollections(
                      competition.id))
              .doc(team.id);

      await participantDocReference.update({
        'questionsOrder': questionsOrder,
        'statusStarted': true,
        'timeStarted': Timestamp.fromDate(RealTime.instance.now!),
      });

      Map participantData = participantDoc.data() as Map<dynamic, dynamic>;

      participantData['questionsOrder'] = questionsOrder;
      participantData['statusStarted'] = true;
      participantData['timeStarted'] =
          Timestamp.fromDate(RealTime.instance.now!);

      // Return false if he/she is just started.
      return [
        false,
        CompetitionParticipant.fromJson(participantData as Map<String, dynamic>)
      ];
    } else {
      // Return true if he/she is started before and also his answers.
      return [true, CompetitionParticipant.fromDocument(participantDoc)];
    }
  }

  Future updateParticipantAnswers(
    Competition competition, {
    AppUser? appUser,
    AppTeam? team,
  }) async
  {
    DocumentReference participantDocReference = (team == null)
        ? FirebaseFirestore.instance
            .collection(
                FirestorePaths.competitionParticipantsIndividualsCollections(
                    competition.id))
            .doc(appUser!.firebaseUser!.uid)
        : FirebaseFirestore.instance
            .collection(FirestorePaths.competitionParticipantsTeamsCollections(
                competition.id))
            .doc(team.id);

    List answers = competition.questions
        .map((e) => {
              '${e.orderNo}': {
                'answer': e.userAnswer,
                'remainingSeconds': e.userAnswerRemainingSeconds,
              },
            })
        .toList();

    await participantDocReference.update({'answers': answers});
  }

  Future finishedParticipantCompetition(
    Competition competition, {
    AppUser? appUser,
    AppTeam? team,
  }) async
  {
    DocumentReference participantDocReference = (team == null)
        ? FirebaseFirestore.instance
            .collection(
                FirestorePaths.competitionParticipantsIndividualsCollections(
                    competition.id))
            .doc(appUser!.firebaseUser!.uid)
        : FirebaseFirestore.instance
            .collection(FirestorePaths.competitionParticipantsTeamsCollections(
                competition.id))
            .doc(team.id);

    List answers = competition.questions
        .map((e) => {
              '${e.orderNo}': {
                'answer': e.userAnswer,
                'remainingSeconds': e.userAnswerRemainingSeconds,
              },
            })
        .toList();

    await participantDocReference.update({
      'answers': answers,
      'statusFinished': true,
      'timeFinished': Timestamp.fromDate(RealTime.instance.now!),
    });
  }

  Future<bool?> checkWhetherParticipantIndividualFinished(
      AppUser appUser, Competition competition) async
  {
    DocumentSnapshot participantDoc = await FirebaseFirestore.instance
        .collection(
            FirestorePaths.competitionParticipantsIndividualsCollections(
                competition.id))
        .doc(appUser.firebaseUser!.uid)
        .get();

    return participantDoc.get('statusFinished');
  }

  Future<bool?> checkWhetherParticipantTeamFinished(
      AppTeam team, Competition competition) async
  {
    DocumentSnapshot participantDoc = await FirebaseFirestore.instance
        .collection(FirestorePaths.competitionParticipantsTeamsCollections(
            competition.id))
        .doc(team.id)
        .get();

    return participantDoc.exists && participantDoc.get('statusFinished');
  }

  Future<bool> checkWhetherAnyTeamMemberParticipatedBefore(
      AppTeam team, Competition competition) async
  {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(FirestorePaths.competitionParticipantsTeamsCollections(
            competition.id))
        .where(AppTeam.MEMBERS_IDS_KEY, arrayContainsAny: team.membersIDs)
        .get();

    Function unOrdDeepEq = const DeepCollectionEquality.unordered().equals;
    if (querySnapshot.docs.isEmpty ||
        (querySnapshot.docs.length == 1 &&
            unOrdDeepEq(
                (querySnapshot.docs.first.data()
                    as Map)[AppTeam.MEMBERS_IDS_KEY],
                team.membersIDs))) {
      return false;
    } else {
      return true;
    }
  }

  Future updateUserCompetitionTestData(
      {required Competition competition, int? questionIndex}) async
  {
    AppUser appUser =
        Provider.of<UserProvider>(Get.context!, listen: false).appUser!;
    await FirebaseFirestore.instance
        .doc(FirestorePaths.userDocument(appUser.firebaseUser!.uid))
        .update({
      "participatedCompetitionsTest.${competition.id}": {
        "questionsTotal": competition.questions.length,
        "questionsAnswered": (questionIndex == null) ? 0 : questionIndex,
        "pointsTotal": (questionIndex == null)
            ? 0
            : appUser.participatedCompetitionsTest[competition.id!]
                ["pointsTotal"],
      },
    });
  }

  Future answerUserCompetitionTestQuestion({
    required Competition competition,
    int? questionIndex,
    required bool isRightAnswer,
  }) async
  {
    AppUser appUser =
        Provider.of<UserProvider>(Get.context!, listen: false).appUser!;
    await FirebaseFirestore.instance
        .doc(FirestorePaths.userDocument(appUser.firebaseUser!.uid))
        .update({
      "participatedCompetitionsTest.${competition.id}": {
        "questionsTotal": competition.questions.length,
        "questionsAnswered": (questionIndex == null) ? 0 : questionIndex,
        "pointsTotal": isRightAnswer
            ? appUser.participatedCompetitionsTest[competition.id!]
                    ["pointsTotal"] +
                1
            : appUser.participatedCompetitionsTest[competition.id!]
                ["pointsTotal"],
      },
    });
  }

  Future addUserCompetitionTestPointsToHistory(
      {required Competition competition}) async
  {
    AppUser appUser =
        Provider.of<UserProvider>(Get.context!, listen: false).appUser!;
    await FirebaseFirestore.instance
        .doc(FirestorePaths.userDocument(appUser.firebaseUser!.uid))
        .update({
      "points": FieldValue.increment(
          appUser.participatedCompetitionsTest[competition.id!]["pointsTotal"]),
      "pointsHistory": FieldValue.arrayUnion([
        {
          "competitionCode": competition.competitionCode,
          "competitionID": competition.id,
          "points": appUser.participatedCompetitionsTest[competition.id!]
              ["pointsTotal"],
          "timeCreated": RealTime.instance.now,
          "type": "competition_test_yourself",
        }
      ]),
    });
  }
}
