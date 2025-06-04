/*
 * Copyright (c) 2021 Shady Boshra.
 * IN: https://LinkedIn.com/in/ShadyBoshra2012
 * GitHub: https://github.com/ShadyBoshra2012
 * Mostaql: https://mostaql.com/u/ShadyBoshra2012
 */

import 'dart:async';

import 'package:anawketaby/enums/request_status.dart';
import 'package:anawketaby/enums/request_type.dart';
import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/models/request.dart';
import 'package:anawketaby/services/firestore_paths.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RequestsManagement {
  RequestsManagement._();

  static final instance = RequestsManagement._();

  Stream<QuerySnapshot> getPendingRequests({int? limit}) {
    Query query = FirebaseFirestore.instance
        .collection("${FirestorePaths.requestsCollections()}")
        .where(Request.STATUS_KEY, isEqualTo: RequestStatus.pending.name)
        .orderBy(Request.TIME_CREATED_KEY, descending: true);

    if (limit != null) query = query.limit(limit);

    return query.snapshots();
  }

  Future<Request?> getRequestByID(String requestID) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .doc("${FirestorePaths.requestsDocument(requestID)}")
        .get();

    if (doc.exists)
      return Request.fromDocument(doc);
    else
      return null;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMyCreationRequests(
      AppUser appUser) {
    return FirebaseFirestore.instance
        .collection("${FirestorePaths.requestsCollections()}")
        .where(Request.USER_ID_KEY, isEqualTo: appUser.id)
        .orderBy(Request.TIME_CREATED_KEY, descending: true)
        .snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getMyCreationRequestsWithOptions(
    AppUser appUser, {
    RequestType? requestType,
    RequestStatus? requestStatus,
  }) {
    var query = FirebaseFirestore.instance
        .collection("${FirestorePaths.requestsCollections()}")
        .where(Request.USER_ID_KEY, isEqualTo: appUser.id);

    if (requestType != null) {
      query = query.where(Request.REQUEST_TYPE_KEY, isEqualTo: requestType.name);
    }

    if (requestStatus != null) {
      query = query.where(Request.STATUS_KEY, isEqualTo: requestStatus.name);
    }

    query = query.orderBy(Request.TIME_CREATED_KEY, descending: true);

    return query.get();
  }
}
