import 'package:anawketaby/managements/users_management.dart';
import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/providers_models/main/user_provider.dart';
import 'package:anawketaby/services/firestore_paths.dart';
import 'package:anawketaby/utils/navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ProfileScreenProvider extends ChangeNotifier {
  AppUser? appUser = Provider.of<UserProvider>(Get.context!).appUser;
  AppUser userProfile;

  ProfileScreenProvider(this.userProfile) {
    FirebaseFirestore.instance
        .doc("${FirestorePaths.userDocument(this.userProfile.id)}")
        .snapshots()
        .listen((value) {
      this.userProfile = AppUser.fromDocument(value, null);
    });
  }

  followUser() async {
    showLoadingDialog();

    await UsersManagement.instance.followUser(this.appUser!, this.userProfile);

    Navigator.pop(Get.context!);

    notifyListeners();
  }

  unfollowUser() async {
    showLoadingDialog();

    await UsersManagement.instance.unfollowUser(this.appUser!, this.userProfile);

    Navigator.pop(Get.context!);

    notifyListeners();
  }
}
