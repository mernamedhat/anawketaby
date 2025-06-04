/*
 * Copyright (c) 2021 Shady Boshra.
 * IN: https://LinkedIn.com/in/ShadyBoshra2012
 * GitHub: https://github.com/ShadyBoshra2012
 * Mostaql: https://mostaql.com/u/ShadyBoshra2012
 */

import 'dart:io';

import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/providers_models/main/settings_provider.dart';
import 'package:anawketaby/providers_models/main/user_provider.dart';
import 'package:anawketaby/services/firestore_paths.dart';
import 'package:anawketaby/utils/navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class UsersManagement {
  UsersManagement._();

  static final instance = UsersManagement._();

  Future<bool> loginWithEmail(String email, String password) async {
    // try {
      bool returnedValue = false;

      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then(((UserCredential userCredential) async {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .doc("${FirestorePaths.userDocument(userCredential.user!.uid)}")
            .get();
        AppUser user = AppUser.fromDocument(userDoc, userCredential.user);
        Provider.of<UserProvider>(Get.context!, listen: false).setUser(user);

        Navigator.pop(Get.context!);

        returnedValue = true;
      })).catchError((error) {
        print("kkkkk"+error.toString());
        Navigator.pop(Get.context!);
        _showErrorException(error);
      });

      return returnedValue;
    // } catch (ex) {
    //   return false;
    // }
  }

  Future<bool> resetPassword(String resetEmail) async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: resetEmail)
          .then((_) {})
          .catchError((error) {
        Navigator.pop(Get.context!);
        _showErrorException(error);
      });

      return true;
    } catch (ex) {
      return false;
    }
  }

  Future updateUserToken(
      {required String userID, bool isLoggedOut = false}) async {
    if (!isLoggedOut) {
      String? token =
          await Provider.of<SettingsProvider>(Get.context!, listen: false)
              .messaging!
              .getToken();
      await FirebaseFirestore.instance
          .doc("${FirestorePaths.userDocument(userID)}")
          .update({
        "fcmToken": token,
      });
    } else {
      await FirebaseFirestore.instance
          .doc("${FirestorePaths.userDocument(userID)}")
          .update({
        "fcmToken": null,
      });
    }
  }

  Future<bool> editUser(AppUser appUser) async {
    try {
      DocumentReference doc = FirebaseFirestore.instance.doc(
          "${FirestorePaths.userDocument("${appUser.firebaseUser!.uid}")}");

      if (appUser.tempPickedImage != null) {
        String imagesURL =
            await uploadUserImage(appUser.tempPickedImage!, doc.id);
        appUser.profilePhotoURL = imagesURL;
      }

      await doc.update({
        "fullName": appUser.fullName,
        "profilePhotoURL": appUser.profilePhotoURL,
        "church": appUser.church.toString().replaceAll("Church.", ""),
        "birthDate": appUser.birthDate,
        "churchRole":
            appUser.churchRole.toString().replaceAll("ChurchRole.", ""),
        'gender': (appUser.gender != null)
            ? appUser.gender.toString().replaceAll("Gender.", "")
            : null,
      });

      return true;
    } catch (ex) {
      return false;
    }
  }

  Future<String> uploadUserImage(PlatformFile image, String userID) async {
    String timestampId;
    Reference reference;
    UploadTask uploadTask;
    TaskSnapshot storageTaskSnapshot;

    await deleteOldImages(FirebaseStorage.instance
        .ref()
        .child("${FirestorePaths.usersCollections()}/$userID"));

    timestampId = DateTime.now().millisecondsSinceEpoch.toString();
    reference = FirebaseStorage.instance
        .ref()
        .child("${FirestorePaths.usersCollections()}/$userID/$timestampId");
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

  Future<AppUser> getUserByID(String? userID) async {
    DocumentReference appUserDocReference =
        FirebaseFirestore.instance.doc(FirestorePaths.userDocument(userID));
    DocumentSnapshot doc = await appUserDocReference.get();
    AppUser appUser = AppUser.fromDocument(doc, null);
    return appUser;
  }

  Future<AppUser?> getUserByPhone(String phone) async {
    Query query = FirebaseFirestore.instance
        .collection(FirestorePaths.usersCollections())
        .where("phone", isEqualTo: phone);
    QuerySnapshot doc = await query.get();
    if (doc.docs.length == 1) {
      return AppUser.fromDocument(doc.docs.first, null);
    } else {
      return null;
    }
  }

  followUser(AppUser appUser, AppUser userProfile) async {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('usersCallable-followUser');
    return await callable.call({
      "appUserID": appUser.firebaseUser!.uid,
      "userProfileID": userProfile.id,
    }).then((result) {
      bool isSuccessful = result.data;
      if (isSuccessful) {
        userProfile.followers?.add(appUser.firebaseUser!.uid);
        appUser.following.add(userProfile.id!);
      }
      return isSuccessful;
    }).catchError((e) {
      return false;
    });
  }

  unfollowUser(AppUser appUser, AppUser userProfile) async {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('usersCallable-unfollowUser');
    return await callable.call({
      "appUserID": appUser.firebaseUser!.uid,
      "userProfileID": userProfile.id,
    }).then((result) {
      bool isSuccessful = result.data;
      if (isSuccessful) {
        userProfile.followers?.remove(appUser.firebaseUser!.uid);
        appUser.following.remove(userProfile.id!);
      }
      return isSuccessful;
    }).catchError((e) {
      return false;
    });
  }

  String _showErrorException(e) {
    if (e is FirebaseAuthException) {
      switch (e.message) {
        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
          showErrorDialog(
              title: "فشل الدخول",
              desc:
                  "لا يوجد بريد الكتروني في قاعدة البيانات، من فضلك قم بالتسجيل اولاً.");
          return 'User with this e-mail not found.';
        case 'The password is invalid or the user does not have a password.':
          showErrorDialog(
              title: "فشل الدخول", desc: "كلمة المرور خاطئة، اعد المحاولة.");
          return 'Invalid password.';
        case 'Password should be at least 6 characters':
          showErrorDialog(
              title: "فشل التسجيل",
              desc:
                  "كلمة المرور خاطئة، يجب ان تكون على الاقل 6 احرف او ارقام.");
          return 'Invalid password.';
        case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
          showErrorDialog(title: "حدث خطأ", desc: "لا يوجد اتصال بالانترنت.");
          return 'No internet connection.';
        case 'The email address is already in use by another account.':
          showErrorDialog(
              title: "فشل التسجيل", desc: "هذا البريد الالكتروني مسجل من قبل.");
          return 'Email address is already taken.';
        case 'An account already exists with the same email address but different sign-in credentials. Sign in using a provider associated with this email address.':
          showErrorDialog(
              title: "فشل الدخول",
              desc:
                  "هذا البريد الالكتروني مسجل من قبل من خلال طريقة دخول اخرى.");
          return 'An account already exists with the same email address but different sign-in credentials..';
        default:
          showErrorDialog(title: "حدث خطأ", desc: "لقد حدث خطأ ما غير معروف.");
          return 'Unknown error occurred.';
      }
    } else {
      showErrorDialog(title: "حدث خطأ", desc: "لقد حدث خطأ ما، حاول مرة اخرى.");
      return 'Unknown error occurred.';
    }
  }
}
