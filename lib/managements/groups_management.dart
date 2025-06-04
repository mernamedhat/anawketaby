/*
 * Copyright (c) 2021 Shady Boshra.
 * IN: https://LinkedIn.com/in/ShadyBoshra2012
 * GitHub: https://github.com/ShadyBoshra2012
 * Mostaql: https://mostaql.com/u/ShadyBoshra2012
 */

import 'dart:async';
import 'dart:io';

import 'package:anawketaby/models/app_group.dart';
import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/services/firestore_paths.dart';
import 'package:anawketaby/utils/real_time.dart';
import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class GroupsManagement {
  GroupsManagement._();

  static final instance = GroupsManagement._();

  Stream<List<QuerySnapshot>> getMyGroups(AppUser appUser, {int? limit}) {
    final List<Stream<QuerySnapshot>> queries = [];

    Query query1 = FirebaseFirestore.instance
        .collection("${FirestorePaths.groupsCollections()}")
        .where(AppGroup.MEMBERS_IDS_KEY, arrayContains: appUser.id)
        .where(AppGroup.IS_ARCHIVED_KEY, isEqualTo: false)
        .where(AppGroup.IS_ACTIVATED_KEY, isEqualTo: true)
        .orderBy(AppGroup.TIME_CREATED_KEY, descending: true);

    if (limit != null) query1 = query1.limit(limit);

    queries.add(query1.snapshots());

    Query query2 = FirebaseFirestore.instance
        .collection("${FirestorePaths.groupsCollections()}")
        .where(AppGroup.LEADER_ID_KEY, isEqualTo: appUser.id)
        .where(AppGroup.IS_ARCHIVED_KEY, isEqualTo: false)
        .orderBy(AppGroup.TIME_CREATED_KEY, descending: true);

    if (limit != null) query2 = query2.limit(limit);

    queries.add(query2.snapshots());

    return StreamZip(queries).asBroadcastStream();
  }

  Stream<List<QuerySnapshot>> getMyControlGroups(AppUser appUser,
      {int? limit}) {
    final List<Stream<QuerySnapshot>> queries = [];

    Query query1 = FirebaseFirestore.instance
        .collection("${FirestorePaths.groupsCollections()}")
        .where(AppGroup.LEADER_ID_KEY, isEqualTo: appUser.id)
        .where(AppGroup.IS_ARCHIVED_KEY, isEqualTo: false)
        .where(AppGroup.IS_ACTIVATED_KEY, isEqualTo: true)
        .orderBy(AppGroup.TIME_CREATED_KEY, descending: true);

    if (limit != null) query1 = query1.limit(limit);

    queries.add(query1.snapshots());

    Query query2 = FirebaseFirestore.instance
        .collection("${FirestorePaths.groupsCollections()}")
        .where(AppGroup.MODERATORS_IDS_KEY, arrayContains: appUser.id)
        .where(AppGroup.IS_ARCHIVED_KEY, isEqualTo: false)
        .where(AppGroup.IS_ACTIVATED_KEY, isEqualTo: true)
        .orderBy(AppGroup.TIME_CREATED_KEY, descending: true);

    if (limit != null) query2 = query2.limit(limit);

    queries.add(query2.snapshots());

    return StreamZip(queries).asBroadcastStream();
  }

  Stream<QuerySnapshot> getAdminGroups({int? limit}) {
    Query query = FirebaseFirestore.instance
        .collection("${FirestorePaths.groupsCollections()}")
        .orderBy(AppGroup.TIME_CREATED_KEY, descending: true);

    if (limit != null) query = query.limit(limit);

    return query.snapshots();
  }

  Future<QuerySnapshot> getMyGroupsFuture(AppUser appUser) {
    Query query = FirebaseFirestore.instance
        .collection("${FirestorePaths.groupsCollections()}")
        .where(AppGroup.MEMBERS_IDS_KEY, arrayContains: appUser.id)
        .where(AppGroup.IS_ARCHIVED_KEY, isEqualTo: false)
        .orderBy(AppGroup.TIME_CREATED_KEY, descending: true);

    return query.get();
  }

  Future<AppGroup?> getAppGroupByID(String groupID) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .doc("${FirestorePaths.groupsDocument(groupID)}")
        .get();

    if (doc.exists)
      return AppGroup.fromDocument(doc);
    else
      return null;
  }

  Future<AppGroup?> getAppGroupByShareID(String shareID) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("${FirestorePaths.groupsCollections()}")
        .where(AppGroup.SHARE_ID_KEY, isEqualTo: shareID)
        .get();

    if (snapshot.docs.length == 1)
      return AppGroup.fromDocument(snapshot.docs.first);
    else
      return null;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMyCreationAppGroups(
      AppUser appUser) {
    return FirebaseFirestore.instance
        .collection("${FirestorePaths.groupsCollections()}")
        .where(AppGroup.CREATOR_ID_KEY, isEqualTo: appUser.id)
        .orderBy(AppGroup.TIME_CREATED_KEY, descending: true)
        .snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getMyCreationAppGroupsFuture(
      AppUser appUser) {
    return FirebaseFirestore.instance
        .collection("${FirestorePaths.groupsCollections()}")
        .where(AppGroup.CREATOR_ID_KEY, isEqualTo: appUser.id)
        .orderBy(AppGroup.TIME_CREATED_KEY, descending: true)
        .get();
  }

  Future<bool> createGroup(AppGroup group, AppUser appUser) async {
    try {
      DocumentReference doc = FirebaseFirestore.instance
          .collection("${FirestorePaths.groupsCollections()}")
          .doc();

      if (group.tempPickedImage != null) {
        String imagesURL =
            await uploadAppGroupImage(group.tempPickedImage!, doc.id);
        group.imageURL = imagesURL;
      }

      group.id = doc.id;
      group.creatorID = appUser.firebaseUser!.uid;
      group.creatorFullName = appUser.fullName!;
      group.timeCreated = Timestamp.fromDate(RealTime.instance.now!);

      await doc.set(group.toJson());

      return true;
    } catch (ex) {
      print(ex);
      return false;
    }
  }

  Future<bool> editGroup(AppGroup group, AppUser? appUser) async {
    try {
      DocumentReference doc = FirebaseFirestore.instance
          .doc("${FirestorePaths.groupsDocument("${group.id}")}");

      if (group.tempPickedImage != null) {
        String imagesURL =
            await uploadAppGroupImage(group.tempPickedImage!, doc.id);
        group.imageURL = imagesURL;
      }

      await doc.update(group.toJson());

      return true;
    } catch (ex) {
      return false;
    }
  }

  Future<String> uploadAppGroupImage(PlatformFile image, String groupID) async {
    String timestampId;
    Reference reference;
    UploadTask uploadTask;
    TaskSnapshot storageTaskSnapshot;

    await deleteOldImages(FirebaseStorage.instance
        .ref()
        .child("${FirestorePaths.groupsCollections()}/$groupID"));

    timestampId = DateTime.now().millisecondsSinceEpoch.toString();
    reference = FirebaseStorage.instance
        .ref()
        .child("${FirestorePaths.groupsCollections()}/$groupID/$timestampId");
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

  Future<bool> deleteGroup(AppGroup group) async {
    try {
      // We will not delete group, but archive it.
      DocumentReference doc = FirebaseFirestore.instance
          .doc("${FirestorePaths.groupsDocument(group.id!)}");

      group.isArchived = true;

      await doc.update(group.toJson());

      return true;
    } catch (ex) {
      return false;
    }
  }

  Future leaveGroup(AppGroup group, Map memberMap) async {
    try {
      DocumentReference doc = FirebaseFirestore.instance
          .doc("${FirestorePaths.groupsDocument(group.id!)}");

      group.membersProfiles.remove(memberMap["id"]);

      await doc.update({
        AppGroup.MEMBERS_IDS_KEY: FieldValue.arrayRemove([memberMap["id"]]),
        AppGroup.MEMBERS_FCM_TOKENS_KEY:
            FieldValue.arrayRemove([memberMap["fcmToken"]]),
        AppGroup.MEMBERS_PROFILES_KEY: group.membersProfiles,
      });

      return true;
    } catch (ex) {
      print(ex);
      return false;
    }
  }

  Future<bool> joinGroupByLink(String groupId) async {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('groupsCallable-joinGroup');
    return await callable.call({"groupId": groupId}).then((result) {
      bool isSuccessful = result.data;
      return isSuccessful;
    }).catchError((e) {
      return false;
    });
  }
}
