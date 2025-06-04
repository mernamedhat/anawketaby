import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/models/topic.dart';
import 'package:anawketaby/providers_models/main/user_provider.dart';
import 'package:anawketaby/ui/screens/admin_screens/new_topic_screens/admin_new_topic_screen.dart';
import 'package:anawketaby/utils/navigation.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class TopicDetailsScreenProvider extends ChangeNotifier {
  AppUser? appUser =
      Provider.of<UserProvider>(Get.context!, listen: false).appUser;

  bool _followingLoading = false;

  Future followTopic(Topic topic) async {
    followingLoading = true;
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('usersCallable-followTopic');
    return await callable.call({
      "appUserID": appUser!.firebaseUser!.uid,
      "topicID": topic.id,
    }).then((result) async {
      bool isSuccessful =  result.data;
      if (isSuccessful) {
        topic.followers!.add(appUser!.firebaseUser!.uid);
        appUser!.topicsFollowing?.add(topic.id);
        await FirebaseMessaging.instance.subscribeToTopic(topic.topicID!);
      }
      followingLoading = false;
      return isSuccessful;
    }).catchError((e) {
      followingLoading = false;
      return false;
    });
  }

  Future unfollowTopic(Topic topic) async {
    followingLoading = true;
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('usersCallable-unfollowTopic');
    return await callable.call({
      "appUserID": appUser!.firebaseUser!.uid,
      "topicID": topic.id,
    }).then((result) async {
      bool isSuccessful =  result.data;
      if (isSuccessful) {
        topic.followers!.remove(appUser!.firebaseUser!.uid);
        appUser!.topicsFollowing?.remove(topic.id);
        await FirebaseMessaging.instance.unsubscribeFromTopic(topic.topicID!);
      }
      followingLoading = false;
      return isSuccessful;
    }).catchError((e) {
      followingLoading = false;
      return false;
    });
  }

  bool get followingLoading => _followingLoading;

  set followingLoading(bool value) {
    _followingLoading = value;
    notifyListeners();
  }

  openResult(Topic topic) async {
    if (await canLaunchUrl(Uri.parse(topic.resultURL!))) {
      await launchUrl(Uri.parse(topic.resultURL!));
    }
  }

  editTopic(Topic? topic) {
    navigateTo(AdminNewTopicScreen(topic: topic));
  }
}
