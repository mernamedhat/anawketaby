import 'dart:io';

import 'package:anawketaby/managements/competitions_management.dart';
import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/models/competition.dart';
import 'package:anawketaby/providers_models/main/settings_provider.dart';
import 'package:anawketaby/providers_models/main/user_provider.dart';
import 'package:anawketaby/utils/navigation.dart';
import 'package:anawketaby/utils/real_time.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:open_store/open_store.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class SplashScreenProvider extends ChangeNotifier {
  final AppUser? appUser =
      Provider.of<UserProvider>(Get.context!, listen: false).appUser;

  bool _isInit = false;

  bool? _isMaintenance = false;
  String? _maintenanceMessage;

  bool _needsUpdate = false;

  SplashScreenProvider() {
    _settingsUpApplication();
  }

  Future _settingsUpApplication() async {
    // Change Orientation to be only Portrait.
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    await Firebase.initializeApp();
    FirebaseFirestore.instance.settings = Settings(persistenceEnabled: false);

    User? firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc("${firebaseUser.uid}")
          .get();

      if (userDoc.data() != null) {
        AppUser user = AppUser.fromDocument(userDoc, firebaseUser);
        Provider.of<UserProvider>(Get.context!, listen: false).setUser(user);
      }
    }

    await RealTime.instance.init();

    await _checkMaintenanceAndVersions();

    await Future.delayed(Duration(seconds: 2));

    if (kReleaseMode && (_isMaintenance! || _needsUpdate)) {
      notifyListeners();
    } else {
      await Provider.of<SettingsProvider>(Get.context!, listen: false)
          .initialized(true);
      await _initDynamicLinks();
    }
  }

  Future _initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLink) {
      final Uri? deepLink = dynamicLink.link;
      if (deepLink != null) _deepLinkLaunch(deepLink);
    });

    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) _deepLinkLaunch(deepLink);
  }

  _deepLinkLaunch(Uri deepLink) async {
    List<String> linkData = deepLink.path.split("/");
    linkData.removeAt(0);

    String page = linkData[0];

    if (page == "competition") {
      showLoadingDialog();
      String competitionID = linkData[1];
      Competition? competition = await CompetitionManagement.instance
          .getCompetitionByID(competitionID);
      Navigator.pop(Get.context!);
      if (competition != null) {
        navigateToCompetition(competition);
      }
    }
  }

  Future<void> _checkMaintenanceAndVersions() async {
    try {
      final doc = await FirebaseFirestore.instance
          .doc("appConfig/configurations")
          .get();

      final configurationAppData = doc.data();
      if (configurationAppData == null) {
        print("No config data found.");
        return;
      }

      _isMaintenance = configurationAppData["isMaintenance"] ?? false;
      _maintenanceMessage = configurationAppData["maintenanceMessage"] ?? "";

      final versionAndroid = configurationAppData["versionAndroid"] ?? 0;
      final versionsAndroidMandatory = List<bool>.from(
          configurationAppData["versionsAndroidMandatory"] ?? []);

      final versionIOS = configurationAppData["versionIOS"] ?? 0;
      final versionsIOSMandatory = List<bool>.from(
          configurationAppData["versionsIOSMandatory"] ?? []);

      final osVersion = Platform.isAndroid ? versionAndroid : versionIOS;
      final versionsOSMandatory =
      Platform.isAndroid ? versionsAndroidMandatory : versionsIOSMandatory;

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = int.tryParse(packageInfo.buildNumber) ?? 0;

      if (osVersion > currentVersion) {
        for (int i = currentVersion + 1; i <= osVersion; i++) {
          if (i < versionsOSMandatory.length && versionsOSMandatory[i]) {
            _needsUpdate = true;
            break;
          }
        }
      }

      _isInit = true;
    } catch (e) {
      print("Error during maintenance/version check: $e");
      // Optionally: fall back or notify user
    }
  }


  void updateAppPressed() {
    OpenStore.instance.open(
      appStoreId: '1605462556', // AppStore id of your app
      androidAppBundleId:
          'com.powerfromabove.anawketaby', // Android app bundle package name
    );
  }

  bool get isInit => _isInit;

  bool get needsUpdate => _needsUpdate;

  String? get maintenanceMessage => _maintenanceMessage;

  bool? get isMaintenance => _isMaintenance;
}
