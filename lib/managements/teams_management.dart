/*
 * Copyright (c) 2021 Shady Boshra.
 * IN: https://LinkedIn.com/in/ShadyBoshra2012
 * GitHub: https://github.com/ShadyBoshra2012
 * Mostaql: https://mostaql.com/u/ShadyBoshra2012
 */

import 'dart:async';
import 'dart:io';

import 'package:anawketaby/models/app_team.dart';
import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/services/firestore_paths.dart';
import 'package:anawketaby/utils/real_time.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class TeamsManagement {
  TeamsManagement._();

  static final instance = TeamsManagement._();

  Stream<QuerySnapshot> getMyTeams(AppUser appUser, {int? limit}) {
    Query query = FirebaseFirestore.instance
        .collection("${FirestorePaths.teamsCollections()}")
        .where(AppTeam.MEMBERS_IDS_KEY, arrayContains: appUser.id)
        .orderBy(AppTeam.TIME_CREATED_KEY, descending: true);

    if (limit != null) query = query.limit(limit);

    return query.snapshots();
  }

  Future<AppTeam?> getAppTeamByID(String teamID) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .doc("${FirestorePaths.teamsDocument(teamID)}")
        .get();

    if (doc.exists)
      return AppTeam.fromDocument(doc);
    else
      return null;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMyCreationAppTeams(
      AppUser appUser) {
    return FirebaseFirestore.instance
        .collection("${FirestorePaths.teamsCollections()}")
        .where(AppTeam.CREATOR_ID_KEY, isEqualTo: appUser.id)
        .orderBy(AppTeam.TIME_CREATED_KEY, descending: true)
        .snapshots();
  }

  Future<bool> createTeam(AppTeam team, AppUser appUser) async {
    try {
      DocumentReference doc = FirebaseFirestore.instance
          .collection("${FirestorePaths.teamsCollections()}")
          .doc();

      if (team.tempPickedImage != null) {
        String imagesURL =
            await uploadAppTeamImage(team.tempPickedImage!, doc.id);
        team.imageURL = imagesURL;
      }

      team.id = doc.id;
      team.creatorID = appUser.firebaseUser!.uid;
      team.creatorFullName = appUser.fullName!;
      team.timeCreated = Timestamp.fromDate(RealTime.instance.now!);

      await doc.set(team.toJson());

      return true;
    } catch (ex) {
      print(ex);
      return false;
    }
  }

  Future<bool> editTeam(AppTeam team, AppUser? appUser) async {
    try {
      DocumentReference doc = FirebaseFirestore.instance
          .doc("${FirestorePaths.teamsDocument("${team.id}")}");

      if (team.tempPickedImage != null) {
        String imagesURL =
            await uploadAppTeamImage(team.tempPickedImage!, doc.id);
        team.imageURL = imagesURL;
      }

      await doc.update(team.toJson());

      return true;
    } catch (ex) {
      return false;
    }
  }

  Future<String> uploadAppTeamImage(PlatformFile image, String teamID) async {
    String timestampId;
    Reference reference;
    UploadTask uploadTask;
    TaskSnapshot storageTaskSnapshot;

    await deleteOldImages(FirebaseStorage.instance
        .ref()
        .child("${FirestorePaths.teamsCollections()}/$teamID"));

    timestampId = DateTime.now().millisecondsSinceEpoch.toString();
    reference = FirebaseStorage.instance
        .ref()
        .child("${FirestorePaths.teamsCollections()}/$teamID/$timestampId");
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

  Future<bool> deleteTeam(AppTeam team) async {
    try {
      DocumentReference doc = FirebaseFirestore.instance
          .doc("${FirestorePaths.teamsDocument(team.id!)}");

      await doc.delete();

      await deleteOldImages(FirebaseStorage.instance
          .ref()
          .child("${FirestorePaths.teamsCollections()}/${team.id}"));

      return true;
    } catch (ex) {
      return false;
    }
  }

  Future leaveTeam(AppTeam team, Map memberMap) async {
    try {
      DocumentReference doc = FirebaseFirestore.instance
          .doc("${FirestorePaths.teamsDocument(team.id!)}");

      team.membersProfiles.remove(memberMap["id"]);

      await doc.update({
        AppTeam.MEMBERS_IDS_KEY: FieldValue.arrayRemove([memberMap["id"]]),
        AppTeam.MEMBERS_FCM_TOKENS_KEY:
            FieldValue.arrayRemove([memberMap["fcmToken"]]),
        AppTeam.MEMBERS_PROFILES_KEY: team.membersProfiles,
      });

      return true;
    } catch (ex) {
      print(ex);
      return false;
    }
  }
}
