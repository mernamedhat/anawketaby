import 'package:anawketaby/models/app_settings.dart';
import 'package:anawketaby/models/group_competition_creation_feature.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  static bool deepLinkHandled = false;

  final AudioPlayer player = AudioPlayer();
  final AudioPlayer playerMusic = AudioPlayer();
  final AppSettings appSettings = AppSettings();

  FirebaseMessaging? _messaging;

  bool _isInit = false;

  String? _defaultCompetitionImageURL;
  int _defaultGroupsMembersLimit = 50;
  int _defaultGroupsModeratorsLimit = 1;
  List<GroupCompetitionCreationFeature>
      _defaultGroupCompetitionCreationFeatures = [];
  bool? _iOSSocialLoginsEnabled;
  bool? _iOSRequiredFields;

  SettingsProvider() {
    SharedPreferences.getInstance().then((prefs) {
      appSettings.isCompetitionMusicEnabled =
          prefs.getBool("isCompetitionMusicEnabled") ??
              appSettings.isCompetitionMusicEnabled;
      appSettings.isCompetitionTimerSoundEnabled =
          prefs.getBool("isCompetitionTimerSoundEnabled") ??
              appSettings.isCompetitionTimerSoundEnabled;
      appSettings.isCompetitionClickSoundEnabled =
          prefs.getBool("isCompetitionClickSoundEnabled") ??
              appSettings.isCompetitionClickSoundEnabled;
      appSettings.textScaleFactor =
          prefs.getDouble("textScaleFactor") ?? appSettings.textScaleFactor;
      notifyListeners();
    });
  }

  Future initialized(bool init) async {
    this._isInit = init;

    _defaultCompetitionImageURL = (await FirebaseFirestore.instance
            .collection("appConfig")
            .doc("urls")
            .get())
        .get("defaultCompetitionImageURL");

    final defaultFeaturesDoc = await FirebaseFirestore.instance
        .collection("appConfig")
        .doc("defaultFeatures")
        .get();
    _defaultGroupsMembersLimit =
        defaultFeaturesDoc.get("defaultGroupsMembersLimit");
    _defaultGroupsModeratorsLimit =
        defaultFeaturesDoc.get("defaultGroupsModeratorsLimit");
    _defaultGroupCompetitionCreationFeatures = List<Map<String, dynamic>>.from(
            defaultFeaturesDoc.get("defaultGroupCompetitionCreationFeatures"))
        .map((e) => GroupCompetitionCreationFeature.fromJson(e))
        .toList();

    final configurationsDoc = await FirebaseFirestore.instance
        .collection("appConfig")
        .doc("configurations")
        .get();
    _iOSSocialLoginsEnabled = configurationsDoc.get("iOSSocialLoginsEnabled");
    _iOSRequiredFields = configurationsDoc.get("iOSRequiredFields");

    _messaging = FirebaseMessaging.instance;
    _initMessaging();

    notifyListeners();
  }

  Future<bool> saveAppSettings(AppSettings newAppSettings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('isCompetitionMusicEnabled',
          newAppSettings.isCompetitionMusicEnabled);
      prefs.setBool('isCompetitionTimerSoundEnabled',
          newAppSettings.isCompetitionTimerSoundEnabled);
      prefs.setBool('isCompetitionClickSoundEnabled',
          newAppSettings.isCompetitionClickSoundEnabled);
      prefs.setDouble('textScaleFactor', newAppSettings.textScaleFactor);

      appSettings.isCompetitionMusicEnabled =
          newAppSettings.isCompetitionMusicEnabled;
      appSettings.isCompetitionTimerSoundEnabled =
          newAppSettings.isCompetitionTimerSoundEnabled;
      appSettings.isCompetitionClickSoundEnabled =
          newAppSettings.isCompetitionClickSoundEnabled;

      appSettings.textScaleFactor = newAppSettings.textScaleFactor;
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future _initMessaging() async {
    /*NotificationSettings settings = */
    await _messaging!.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future playClickSound() async {
    if (appSettings.isCompetitionClickSoundEnabled) {
      await player.setAsset("assets/sounds/sound_click.mp3");
      await player.play();
    }
  }

  Future playAnswerSound(bool isTrue) async {
    if (appSettings.isCompetitionClickSoundEnabled) {
      if (isTrue)
        await player.setAsset("assets/sounds/true_answer_sound.mp3");
      else
        await player.setAsset("assets/sounds/wrong_answer_sound.mp3");

      await player.play();
    }
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    // await Firebase.initializeApp();

    // print("Handling a background message: ${message.messageId}");
  }

  bool get isInit => _isInit;

  String? get defaultCompetitionImageURL => _defaultCompetitionImageURL;

  int get defaultGroupsMembersLimit => _defaultGroupsMembersLimit;

  int get defaultGroupsModeratorsLimit => _defaultGroupsModeratorsLimit;

  List<GroupCompetitionCreationFeature>
      get defaultGroupCompetitionCreationFeatures =>
          _defaultGroupCompetitionCreationFeatures;

  bool? get iOSSocialLoginsEnabled => _iOSSocialLoginsEnabled;

  bool? get iOSRequiredFields => _iOSRequiredFields;

  FirebaseMessaging? get messaging => _messaging;
}
