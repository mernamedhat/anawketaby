import 'package:anawketaby/models/app_settings.dart';
import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/providers_models/main/settings_provider.dart';
import 'package:anawketaby/providers_models/main/user_provider.dart';
import 'package:anawketaby/utils/navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SettingsScreenProvider extends ChangeNotifier {
  final AppUser? appUser = Provider.of<UserProvider>(Get.context!).appUser;
  final AppSettings appSettings =
      Provider.of<SettingsProvider>(Get.context!).appSettings;

  late bool _isCompetitionMusicEnabled;
  late bool _isCompetitionTimerSoundEnabled;
  late bool _isCompetitionClickSoundEnabled;
  late double _textScaleFactor;

  SettingsScreenProvider() {
    _isCompetitionMusicEnabled = appSettings.isCompetitionMusicEnabled;
    _isCompetitionTimerSoundEnabled =
        appSettings.isCompetitionTimerSoundEnabled;
    _isCompetitionClickSoundEnabled =
        appSettings.isCompetitionClickSoundEnabled;
    _textScaleFactor = appSettings.textScaleFactor;
  }

  Future saveEdits() async {
    showLoadingDialog();

    AppSettings newAppSettings = AppSettings(
      isCompetitionMusicEnabled: isCompetitionMusicEnabled,
      isCompetitionTimerSoundEnabled: isCompetitionTimerSoundEnabled,
      isCompetitionClickSoundEnabled: isCompetitionClickSoundEnabled,
      textScaleFactor: textScaleFactor,
    );

    bool successful =
        await Provider.of<SettingsProvider>(Get.context!, listen: false)
            .saveAppSettings(newAppSettings);

    Navigator.pop(Get.context!);

    if (successful) {
      showSuccessDialog(
        title: "تم التعديل",
        desc: "تم تعديل إعدادات التطبيق بنجاح.",
        onDismissCallback: (_) => Navigator.pop(Get.context!),
      );
    } else {
      showErrorDialog(
        title: "حدث خطأ",
        desc: "حدث خطأ في تعديل إعدادات التطبيق.",
      );
    }
  }

  bool get isCompetitionMusicEnabled => _isCompetitionMusicEnabled;

  set isCompetitionMusicEnabled(bool value) {
    _isCompetitionMusicEnabled = value;
    notifyListeners();
  }

  bool get isCompetitionTimerSoundEnabled => _isCompetitionTimerSoundEnabled;

  set isCompetitionTimerSoundEnabled(bool value) {
    _isCompetitionTimerSoundEnabled = value;
    notifyListeners();
  }

  bool get isCompetitionClickSoundEnabled => _isCompetitionClickSoundEnabled;

  set isCompetitionClickSoundEnabled(bool value) {
    _isCompetitionClickSoundEnabled = value;
    notifyListeners();
  }

  double get textScaleFactor => _textScaleFactor;

  set textScaleFactor(double value) {
    _textScaleFactor = value;
    notifyListeners();
  }
}
