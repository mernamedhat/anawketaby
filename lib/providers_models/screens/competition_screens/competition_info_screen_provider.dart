import 'dart:async';

import 'package:anawketaby/managements/competitions_management.dart';
import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/models/competition.dart';
import 'package:anawketaby/providers_models/main/settings_provider.dart';
import 'package:anawketaby/providers_models/main/user_provider.dart';
import 'package:anawketaby/ui/screens/admin_screens/new_competition_screens/admin_new_competition_screen.dart';
import 'package:anawketaby/ui/screens/competition_screens/competition_count_down_screen.dart';
import 'package:anawketaby/ui/screens/competition_screens/competition_full_report_screen.dart';
import 'package:anawketaby/ui/screens/competition_screens/competition_start_screen.dart';
import 'package:anawketaby/ui/screens/competition_screens/competition_test_screens/competition_test_start_screen.dart';
import 'package:anawketaby/utils/bible_util.dart';
import 'package:anawketaby/utils/navigation.dart';
import 'package:anawketaby/utils/real_time.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class CompetitionInfoScreenProvider extends ChangeNotifier {
  final String? defaultCompetitionImage =
      Provider.of<SettingsProvider>(Get.context!, listen: false)
          .defaultCompetitionImageURL;
  final AppUser? appUser =
      Provider.of<UserProvider>(Get.context!, listen: false).appUser;

  Competition competition;

  late StreamSubscription _competitionStream;

  CompetitionInfoScreenProvider(this.competition) {
    _competitionStream = CompetitionManagement.instance
        .getCompetitionStream(this.competition.id)
        .listen((event) {
      // this.competition = Competition.fromJson(event.data());
       this.competition = Competition.fromJson(event.data() as Map<String, dynamic>);
      notifyListeners();
    });
  }

  get isCompetitionCreator =>
      this.competition.creatorID == this.appUser!.firebaseUser!.uid;

  get prizePoints =>
      this.competition.participationPoints! *
      this.competition.participantsCount!;

  get isPreviewAvailable => isCompetitionCreator;

  get isArchiveAvailable =>
      this.competition.timeResultPublished != null &&
      !this.competition.archived! &&
      isCompetitionCreator;

  get isUnArchiveAvailable =>
      this.competition.timeResultPublished != null &&
      this.competition.archived! &&
      isCompetitionCreator;

  get isCompetitionFinished => this.competition.timeResultPublished != null;

  String getDateTime(DateTime date) {
    Intl.defaultLocale = Get.locale!.languageCode;
    var timeFormatter = DateFormat('yyyy/MM/dd');
    return timeFormatter.format(date);
  }

  Future<void> fullCompetitionReport() async {
    if (competition.timeEnd!.toDate().isBefore(RealTime.instance.now!) &&
        !isTestYourselfAvailable) {
      AwesomeDialog(
        context: Get.context!,
        animType: AnimType.scale,
        headerAnimationLoop: false,
        dialogType: DialogType.question,
        title: 'تأكيد فتح التقرير',
        desc:
            'عرض التقرير بالكامل هو إظهار جميع المعلومات الخاصة بالمسابقة بما فيها الاسئلة والاجابات الصحيحة، هل تريد الاستمرار؟',
        btnOkText: 'نعم',
        btnOkOnPress: () {
          navigateTo(
              CompetitionFullReportScreen(competition: this.competition));
        },
        btnCancelText: 'لا',
        btnCancelOnPress: () {},
      )..show();
    } else if (isTestYourselfAvailable) {
      showInfoDialog(
        title: "التقرير بالكامل غير متاح",
        desc:
            "يمكنك الاستفادة من حل جميع اسئلة المسابقة وربح نقطة على كل إجابة صحيحة تضاف إلى رصيد نقاطك. اضغط (اختبر نفسك) الأن.",
      );
    } else {
      showInfoDialog(
        title: "المسابقة لم تنتهي",
        desc:
            "مازالت المسابقة قيد العمل وجديدة، يمكنك التعلم من جديد بعد وقت الانتهاء.",
      );
    }
  }

  Future previewCompetition() async {
    await navigateTo(CompetitionCountDownScreen(
        competition: this.competition, learnAgain: true));
    notifyListeners();
  }

  Future learnAgain() async {
    if (competition.timeEnd!.toDate().isBefore(RealTime.instance.now!)) {
      await navigateTo(CompetitionStartScreen(
          competition: this.competition, learnAgain: true));
      notifyListeners();
    } else {
      showInfoDialog(
        title: "المسابقة لم تنتهي",
        desc:
            "مازالت المسابقة قيد العمل وجديدة، يمكنك التعلم من جديد بعد وقت الانتهاء.",
      );
    }
  }

  Future testYourself() async {
    await navigateTo(CompetitionTestStartScreen(competition: this.competition));
    notifyListeners();
  }

  Future editCompetition() async {
    if (this.isEditAvailable) {
      await navigateTo(
          AdminNewCompetitionScreen(competition: this.competition));
      notifyListeners();
    } else {
      showErrorDialog(
          title: 'غير متاح التعديل',
          desc: 'لا يمكن تعديل المسابقة الان بعد مرور وقت بدأها.');
    }
  }

  Future duplicateCompetition() async {
    Competition duplicatedCompetition = Competition.clone(this.competition);
    duplicatedCompetition.id = null;
    duplicatedCompetition.name = "نسخة من ${competition.name}";
    duplicatedCompetition.competitionCode = null;
    duplicatedCompetition.creatorID = null;
    duplicatedCompetition.creatorFullName = null;
    duplicatedCompetition.durationCompetitionSeconds =
        (duplicatedCompetition.durationCompetitionSeconds! / 60).floor();
    duplicatedCompetition.url = null;
    duplicatedCompetition.isPublishBeforeStartTime = false;
    duplicatedCompetition.isPopular = false;
    duplicatedCompetition.isTestYourself = false;
    duplicatedCompetition.isResultPublished = false;
    duplicatedCompetition.archived = false;
    duplicatedCompetition.participantsCount = null;
    duplicatedCompetition.timeStart = null;
    duplicatedCompetition.timeEnd = null;
    duplicatedCompetition.timeCalculateResults = null;
    duplicatedCompetition.timePublished = null;
    duplicatedCompetition.timeResultPublished = null;
    duplicatedCompetition.timeCreated = null;
    duplicatedCompetition.timeLastEdit = null;
    duplicatedCompetition.winnersIDs = [];
    await navigateReplacement(
        AdminNewCompetitionScreen(competition: duplicatedCompetition));
  }

  Future shareCompetition() async {
    if (this.isCompetitionCreator) {
      print("hghg");
      await navigateTo(AdminNewCompetitionScreen(
          competition: this.competition, step: CompetitionSteps.share));
      notifyListeners();
    } else {
      userShareCompetition();
    }
  }

  userShareCompetition() {
    String text = "مسابقة جديدة: ";
    text += "${competition.name}";
    text += "\n";
    text += "رابط المسابقة: ";
    text += "${competition.url}";
    text += "\n";
    text += "كود المسابقة: ";
    text += "${competition.competitionCode}";
    text += "\n";
    if (competition.closed!) {
      text += "كلمة المرور: ";
      text += "برجاء قم بالتواصل مع منشئ المسابقة للحصول على كلمة المرور.";
      text += "\n";
    }
    if (competition.reads!.isNotEmpty) {
      text += "القراءات: ";
      text +=
          "${competition.reads!.map((e) => BibleUtil.readFromKey(e)).join("، ")}";
      text += "\n";
    } else {
      text += "القراءات: ";
      text += "عام";
      text += "\n";
    }
    text += "بداية المسابقة: ";
    text += "${_getDateTime(competition.timeStart!.toDate())}";
    text += "\n";
    text += "نهاية المسابقة: ";
    text += "${_getDateTime(competition.timeEnd!.toDate())}";
    text += "\n";

    text += "\n";
    text += "تحمس معنا واشترك الآن ❤";

    Share.share(text, subject: 'مسابقة جديدة!');
  }

  Future deleteCompetition() async {
    if (this.isDeleteAvailable) {
      AwesomeDialog(
        context: Get.context!,
        animType: AnimType.scale,
        headerAnimationLoop: false,
        dialogType: DialogType.question,
        title: 'تأكيد الحذف',
        desc:
            'هل تريد بالتأكيد حذف هذه المسابقة؟ لا يمكن الرجوع في هذه الخطوة.',
        btnOkText: 'نعم',
        btnOkOnPress: () async {
          await CompetitionManagement.instance
              .deleteCompetition(this.competition);
          Navigator.pop(Get.context!);
        },
        btnCancelText: 'لا',
        btnCancelOnPress: () {},
      )..show();
    } else {
      showErrorDialog(
          title: 'غير متاح الحذف',
          desc: 'لا يمكن حذف المسابقة الان بعد مرور وقت بدأها.');
    }
  }

  Future archiveCompetition() async {
    if (this.isArchiveAvailable) {
      AwesomeDialog(
        context: Get.context!,
        animType: AnimType.scale,
        headerAnimationLoop: false,
        dialogType: DialogType.question,
        title: 'تأكيد الأرشفة',
        desc: 'هل تريد بالتأكيد أرشفة هذه المسابقة؟',
        btnOkText: 'نعم',
        btnOkOnPress: () async {
          await CompetitionManagement.instance
              .archiveCompetition(this.competition);
        },
        btnCancelText: 'لا',
        btnCancelOnPress: () {},
      )..show();
    } else {
      showErrorDialog(
          title: 'غير متاح الأرشفة', desc: 'لا يمكن أرشفة المسابقة الان.');
    }
  }

  Future unArchiveCompetition() async {
    if (this.isUnArchiveAvailable) {
      AwesomeDialog(
        context: Get.context!,
        animType: AnimType.scale,
        headerAnimationLoop: false,
        dialogType: DialogType.question,
        title: 'تأكيد عدم الأرشفة',
        desc: 'هل تريد بالتأكيد عدم أرشفة هذه المسابقة؟',
        btnOkText: 'نعم',
        btnOkOnPress: () async {
          await CompetitionManagement.instance
              .unArchiveCompetition(this.competition);
        },
        btnCancelText: 'لا',
        btnCancelOnPress: () {},
      )..show();
    } else {
      showErrorDialog(
          title: 'غير متاح عدم الأرشفة',
          desc: 'لا يمكن عدم أرشفة المسابقة الان.');
    }
  }

  bool get isEditAvailable =>
      this.competition.timeStart!.toDate().isAfter(RealTime.instance.now!);

  bool get isDeleteAvailable =>
      this.competition.timeStart!.toDate().isAfter(RealTime.instance.now!);

  bool get isTestYourselfAvailable =>
      this.competition.timeResultPublished != null &&
      this
          .competition
          .timeResultPublished!
          .toDate()
          .isBefore(RealTime.instance.now!) &&
      (this.appUser!.participatedCompetitionsTest[this.competition.id!] ==
              null ||
          (this.appUser!.participatedCompetitionsTest[this.competition.id!] !=
                  null &&
              this.appUser!.participatedCompetitionsTest[this.competition.id!]
                      ["questionsAnswered"] <
                  this
                          .appUser!
                          .participatedCompetitionsTest[this.competition.id!]
                      ["questionsTotal"]));

  String _getDateTime(DateTime date) {
    Intl.defaultLocale = Get.locale!.languageCode;
    var timeFormatter = DateFormat('yyyy/MM/dd - hh:mm a');
    return timeFormatter.format(date);
  }

  @override
  void dispose() {
    super.dispose();
    _competitionStream.cancel();
  }
}
