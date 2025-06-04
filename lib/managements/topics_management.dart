/*
 * Copyright (c) 2021 Shady Boshra.
 * IN: https://LinkedIn.com/in/ShadyBoshra2012
 * GitHub: https://github.com/ShadyBoshra2012
 * Mostaql: https://mostaql.com/u/ShadyBoshra2012
 */

import 'dart:async';
import 'dart:io';

import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/models/topic.dart';
import 'package:anawketaby/services/firestore_paths.dart';
import 'package:anawketaby/utils/real_time.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class TopicsManagement {
  TopicsManagement._();

  static final instance = TopicsManagement._();

  Stream<QuerySnapshot> getTopics({int? limit}) {
    Query query = FirebaseFirestore.instance
        .collection("${FirestorePaths.topicsCollections()}")
        .where("isShowing", isEqualTo: true)
        .orderBy("timeCreated", descending: true);

    if (limit != null) query = query.limit(limit);

    return query.snapshots();
  }

  Future<Topic?> getTopicByID(String topicID) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .doc("${FirestorePaths.topicsDocument(topicID)}")
        .get();

    if (doc.exists)
      return Topic.fromDocument(doc);
    else
      return null;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMyCreationTopics(AppUser appUser) {
    return FirebaseFirestore.instance
        .collection("${FirestorePaths.topicsCollections()}")
        .where("creatorID", isEqualTo: appUser.id)
        .orderBy('timeCreated', descending: true)
        .snapshots();
  }

  Future<bool> createTopic(Topic topic, AppUser appUser) async {
    try {
      DocumentReference doc = FirebaseFirestore.instance
          .collection("${FirestorePaths.topicsCollections()}")
          .doc();

      if (topic.tempPickedImage != null) {
        String imagesURL =
            await uploadTopicImage(topic.tempPickedImage!, doc.id);
        topic.imageURL = imagesURL;
      }

      topic.followers = [];
      topic.id = doc.id;
      topic.creatorID = appUser.firebaseUser!.uid;
      topic.creatorFullName = appUser.fullName;
      topic.timeCreated = Timestamp.fromDate(RealTime.instance.now!);

      await doc.set(topic.toJson());

      return true;
    } catch (ex) {
      return false;
    }
  }

  Future<bool> editTopic(Topic topic, AppUser? appUser) async {
    try {
      DocumentReference doc = FirebaseFirestore.instance
          .doc("${FirestorePaths.topicsDocument("${topic.id}")}");

      if (topic.tempPickedImage != null) {
        String imagesURL =
            await uploadTopicImage(topic.tempPickedImage!, doc.id);
        topic.imageURL = imagesURL;
      }

      await doc.update(topic.toJson());

      return true;
    } catch (ex) {
      return false;
    }
  }

  Future<String> uploadTopicImage(PlatformFile image, String topicID) async {
    String timestampId;
    Reference reference;
    UploadTask uploadTask;
    TaskSnapshot storageTaskSnapshot;

    await deleteOldImages(FirebaseStorage.instance
        .ref()
        .child("${FirestorePaths.topicsCollections()}/$topicID"));

    timestampId = DateTime.now().millisecondsSinceEpoch.toString();
    reference = FirebaseStorage.instance
        .ref()
        .child("${FirestorePaths.topicsCollections()}/$topicID/$timestampId");
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
}
