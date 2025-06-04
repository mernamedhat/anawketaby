import 'package:anawketaby/enums/request_status.dart';
import 'package:anawketaby/enums/request_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Request {
  static const String ID_KEY = 'id';
  static const String ACTION_USER_ID_KEY = 'actionUserID';
  static const String ACTION_USER_FULL_NAME_KEY = 'actionUserFullName';
  static const String REQUEST_TYPE_KEY = 'requestType';
  static const String STATUS_KEY = 'status';
  static const String USER_EMAIL_KEY = 'userEmail';
  static const String USER_FULL_NAME_KEY = 'userFullName';
  static const String USER_ID_KEY = 'userID';
  static const String USER_PHONE_KEY = 'userPhone';
  static const String TIME_ACTIONED_KEY = 'timeActioned';
  static const String TIME_CREATED_KEY = 'timeCreated';

  String id;
  String? actionUserID;
  String? actionUserFullName;
  RequestType requestType;
  RequestStatus status;
  String? userEmail;
  String userFullName;
  String userID;
  String userPhone;
  Timestamp? timeActioned;
  Timestamp timeCreated;

  Request({
    required this.id,
    this.actionUserID,
    this.actionUserFullName,
    required this.requestType,
    required this.status,
    this.userEmail,
    required this.userFullName,
    required this.userID,
    required this.userPhone,
    this.timeActioned,
    required this.timeCreated,
  });

  Map<String, dynamic> toJson() {
    return {
      ID_KEY: id,
      ACTION_USER_ID_KEY: actionUserID,
      ACTION_USER_FULL_NAME_KEY: actionUserFullName,
      REQUEST_TYPE_KEY: requestType,
      STATUS_KEY: status,
      USER_EMAIL_KEY: userEmail,
      USER_FULL_NAME_KEY: userFullName,
      USER_ID_KEY: userID,
      USER_PHONE_KEY: userPhone,
      TIME_ACTIONED_KEY: timeActioned,
      TIME_CREATED_KEY: timeCreated,
    };
  }

  factory Request.fromJson(Map<String, dynamic> doc) {
    Request request = Request(
      id: doc[ID_KEY],
      actionUserID: doc[ACTION_USER_ID_KEY],
      actionUserFullName: doc[ACTION_USER_FULL_NAME_KEY],
      requestType: requestTypeFromString(doc[REQUEST_TYPE_KEY]),
      status: requestStatusFromString(doc[STATUS_KEY]),
      userEmail: doc[USER_EMAIL_KEY],
      userFullName: doc[USER_FULL_NAME_KEY],
      userID: doc[USER_ID_KEY],
      userPhone: doc[USER_PHONE_KEY],
      timeActioned: doc[TIME_ACTIONED_KEY],
      timeCreated: doc[TIME_CREATED_KEY],
    );
    return request;
  }

  factory Request.fromDocument(DocumentSnapshot doc) {
    return Request.fromJson(doc.data() as Map<String, dynamic>);
  }
}
