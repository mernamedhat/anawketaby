// ignore_for_file: cancel_subscriptions

import 'dart:async';

import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/services/firestore_paths.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  AppUser? _appUser;

  StreamSubscription? _userChangesListener;

  Future listenUserChanges() async {
    if (this.appUser != null && _userChangesListener == null) {
      _userChangesListener = FirebaseFirestore.instance
          .doc(FirestorePaths.userDocument(this.appUser!.firebaseUser!.uid))
          .snapshots()
          .listen((event) {
        this.setUser(
            AppUser.fromDocument(event, FirebaseAuth.instance.currentUser));
      });
    } else if (this.appUser == null && _userChangesListener != null) {
      await _userChangesListener!.cancel();
      _userChangesListener = null;
    }
  }

  void setUser(AppUser? user) {
    this._appUser = user;
    listenUserChanges();
    notifyListeners();
  }

  AppUser? get appUser => _appUser;
}
